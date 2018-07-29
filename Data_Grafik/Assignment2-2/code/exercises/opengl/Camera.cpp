#include "Camera.hpp"

namespace ogl
{

Camera::Camera(int width, int height,float fovy, float zNear, float zFar) :
  mRotationActive(false), 
  mPanningActive(false),
  mWidth(width),
  mHeight(height),
  mFOVY(fovy),
  mZNear(zNear),
  mZFar(zFar)
{
  // Create a uniform buffer that fits 2*Mat4 and 1*Vec4 -> 36 floats
  glGenBuffers(1, &mMatrixUniformBuffer);
  glBindBuffer(GL_UNIFORM_BUFFER, mMatrixUniformBuffer);
  glBufferData(GL_UNIFORM_BUFFER, sizeof(float) * 36, NULL, GL_STREAM_DRAW);
  glBindBuffer(GL_UNIFORM_BUFFER, 0);

  // Initialize class attributes
  mOldMousePosition[0]=0;
  mOldMousePosition[1]=0;

  this->setPosition(Vec3f(4,4,4));
  this->setTarget(Vec3f(0,0,0));
  this->setUp(Vec3f(0,0,1));

  // Create a glViewport
  this->resize(width,height);
}

void Camera::resize(int width, int height)
{
  mWidth = width;
  mHeight = height;
  glViewport(0, 0, width, height);
}

void Camera::mouseMoved(int x, int y)
{
  //Compute difference to last mouse position
  int dx =x-mOldMousePosition[0];
  int dy =y-mOldMousePosition[1];

  if(mRotationActive)
  {
    float rotationSpeed=360.0f;
    Mat4x4f M;
    M.setIdentity();
    // In order to perform the rotation:
    // M=T(target)*R(roll)*R(yaw)*T(-target)

    M.translate(-mTarget); // Translate to origin

    // Rotate around up-axis -> yaw
    float yaw=-(float)dx*rotationSpeed/(float)mWidth;
    M.rotate(yaw,mUp);

    // Compute roll angle and axis
    float roll=-(float)dy*rotationSpeed/(float)mHeight;
    Vec3f viewDirection = (mEye-mTarget).normalize();

    float alpha = (float)acos(dot(viewDirection,mUp))*180.0f/(float)M_PI;

    // Clamp the rotation to interval (1, 179)
    // larger values will lead to a view direction that coincides with the up vector
    // Such a view matrix would become singular which must NOT happen
    float minAngle=1.f;
    float maxAngle = 179.f;
    if(alpha+roll>maxAngle)
      roll = maxAngle-alpha;
    if(alpha+roll<minAngle)
      roll = minAngle-alpha;

    Vec3f rollAxis = cross(viewDirection,mUp).normalize();
    M.rotate(-roll,rollAxis);

    M.translate(mTarget); // Translate back

    // Compute new world position of camera eye position
    mEye = M*mEye;
  }

  if(mPanningActive)
  {
    Mat4x4f M;
    M.setIdentity();
    float panningSpeed=0.001f*(mEye-mTarget).length();
    float panningHorizontal=-panningSpeed*dx;
    float panningVertical=panningSpeed*dy;

    // In camera space the visible plane is spanned by
    // the xy-plane and the depth along the z-axis (thus z buffer!)

    // We need to compute these axis in world space
    // This done by reverting the view transformation, i.e.
    // multiplying the axes with the inverse of the view matrix
    Vec3f horizontalOffset = Vec3f(1,0,0);
    Vec3f verticalOffset = Vec3f(0,1,0);
    Mat4x4f V = this->getLookAt();
    V.invert();

    // These axes are now in world space
    horizontalOffset =V.as3x3()*horizontalOffset;
    verticalOffset =V.as3x3()*verticalOffset;

    // Now pan by translating along the axes
    M.translate(horizontalOffset*panningHorizontal);
    M.translate(verticalOffset*panningVertical);

    // Compute new (shifted) eye and target position
    mEye = M*mEye;
    mTarget = M*mTarget;
  }

  // Store new mouse position
  mOldMousePosition[0]=x;
  mOldMousePosition[1]=y;
}

void Camera::mouseButtonPressed(int button, int state)
{
  // If left mouse button is pressed -> activate rotation
  // If left mouse button is released -> deactivate rotation
  if(button == GLFW_MOUSE_BUTTON_LEFT)
  {
    if(state==GLFW_PRESS) //button pressed
      mRotationActive=true;
    else if(state==GLFW_RELEASE) //button released
      mRotationActive=false;
  }

  // If left mouse button is pressed -> activate panning
  // If left mouse button is released -> deactivate panning
  else if (button == GLFW_MOUSE_BUTTON_MIDDLE)
  {
    if(state == GLFW_PRESS)
      mPanningActive=true;
    else if(state==GLFW_RELEASE)
      mPanningActive=false;
  }
}

void Camera::mouseWheelScrolled( int direction)
{
  float scaleSpeed = -0.15f;
  Mat4x4f M;
  M.setIdentity();
  M.translate(-mTarget); // Translate into origin
  // Zooming scales the distance between camera eye and target position
  // You could also scale the field of view (which is done by real world cameras)
  M.scale(1+direction*scaleSpeed,1+direction*scaleSpeed,1+direction*scaleSpeed);
  M.translate(mTarget);  // Translate back
  mEye = M*mEye;
}

void Camera::updateUniforms()
{
  // Compute matrices
  Mat4x4f proj = getPerspective();
  Mat4x4f view = getLookAt();

  // Upload new data to the GPU
  glBindBuffer(GL_UNIFORM_BUFFER, mMatrixUniformBuffer);
  glBufferSubData(GL_UNIFORM_BUFFER, 0,sizeof(float) * 16, proj.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 16, sizeof(float) * 16,view.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 32, sizeof(float) * 3,&mEye[0]);
  glBindBuffer(GL_UNIFORM_BUFFER, 0);
}

Camera::~Camera()
{
  // Free the uniform buffer on the GPU
  glDeleteBuffers(1,&mMatrixUniformBuffer);
}

Mat4x4f Camera::getLookAt() const
{
  return Mat4x4f::getLookAt(mEye,mTarget,mUp);
}

Mat4x4f Camera::getPerspective() const
{
  float aspect_ratio=(float)mWidth/(float)mHeight;
  return Mat4x4f::getPerspective(mFOVY,aspect_ratio,mZNear,mZFar);
}

void Camera::bind(const GLuint shaderProgram,const GLuint bindingPoint, const std::string &blockName) const
{
  // Bind the camera uniform buffer that contains the projection and view matrices as well
  // as the world eye position
  GLuint uniformBlockIndex = glGetUniformBlockIndex(shaderProgram, blockName.c_str());
  glUniformBlockBinding(shaderProgram, uniformBlockIndex, bindingPoint);
  glBindBufferRange(GL_UNIFORM_BUFFER, bindingPoint, mMatrixUniformBuffer, 0, sizeof(float)*36);
}

} //namespace ogl