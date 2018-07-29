#include "TriangleGeometry.hpp"

namespace ogl
{

TriangleGeometry::TriangleGeometry() : mInitialized(false)
{
  // Initialize default values
  mModelMatrix.setIdentity();

  mShininess = 10.f;
  mLineWidth = 0.f;
  mColor = Vec4f(0.5,0.5,0.5,1);
  mLineColor = Vec4f(0,0,0,0);
  mLightPosition[0]=Vec4f(0,0,0,0);
  mLightPosition[1]=Vec4f(0,0,0,0);
  mLightPosition[2]=Vec4f(0,0,0,0);
}

TriangleGeometry::~TriangleGeometry()
{
  this->clear();
}

void TriangleGeometry::init(const std::vector<Vec3f>& p, const std::vector<Vec3f>& n, const std::vector<unsigned int>& t)
{
  //Create and copy buffer data for the indexed triangle set

  this->clear();

  mNumIndices = GLsizei(t.size());

  // Create and copy index buffer on GPU
  glGenBuffers(1, &mIndexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned int) * t.size(), &t[0], GL_STATIC_DRAW);
  ogl::printOpenGLError();

  // Create and copy index buffer on GPU
  glGenBuffers(1, &mPositionBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, mPositionBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vec3f) * p.size(), &p[0], GL_STATIC_DRAW);
  ogl::printOpenGLError();

  // Create and copy index buffer on GPU
  glGenBuffers(1, &mNormalBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, mNormalBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vec3f) * n.size(), &n[0], GL_STATIC_DRAW);
  ogl::printOpenGLError();

  // Generate a vertex array object
  glGenVertexArrays(1, &mVertexArrayObject);
  glBindVertexArray(mVertexArrayObject);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, mPositionBuffer);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
  glBindBuffer(GL_ARRAY_BUFFER, mNormalBuffer);
  glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, 0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glEnableVertexAttribArray(0);
  glEnableVertexAttribArray(1);
  glBindVertexArray(0);
  
  //Create uniform buffer
  glGenBuffers(1, &mUniformBuffer);
  glBindBuffer(GL_UNIFORM_BUFFER, mUniformBuffer);
  glBufferData(GL_UNIFORM_BUFFER, sizeof(float) * 56, NULL, GL_STREAM_DRAW);
  glBindBuffer(GL_UNIFORM_BUFFER, 0);

  mInitialized=true;
}

void TriangleGeometry::initInstance(std::shared_ptr<TriangleGeometry> original)
{
  // For instances, only create uniform buffer 
  // Point to the geometry of the original

  this->clear();
  mInstance=original;

  //Create uniform buffer
  glGenBuffers(1, &mUniformBuffer);
  glBindBuffer(GL_UNIFORM_BUFFER, mUniformBuffer);
  glBufferData(GL_UNIFORM_BUFFER, sizeof(float) * 56, NULL, GL_STREAM_DRAW);
  glBindBuffer(GL_UNIFORM_BUFFER, 0);

  mInitialized=true;
}

void TriangleGeometry::setMaterial(float shininess, const Vec3f& color, float lineWidth, const Vec3f& lineColor)
{
  mShininess=shininess;
  mColor=Vec4f(color,1);
  mLineWidth=lineWidth;
  mLineColor=Vec4f(lineColor,1);
}

GLuint TriangleGeometry::handle() const
{
  if(mInstance)
    return mInstance->handle();
  return mVertexArrayObject;
}
GLsizei TriangleGeometry::numIndices() const
{
  if(mInstance)
    return mInstance->numIndices();
  return mNumIndices;
}

Vec3f TriangleGeometry::getPosition() const
{
  return mModelMatrix*Vec3f(0,0,0);
}

void TriangleGeometry::clear()
{
  if(!mInitialized)
    return;

  // Clear buffers and array
  if(!mInstance)
  {
    glDeleteBuffers(1,&mIndexBuffer);
    glDeleteBuffers(1,&mPositionBuffer);
    glDeleteBuffers(1,&mNormalBuffer);
    glDeleteVertexArrays(1,&mVertexArrayObject);
  }

  glDeleteBuffers(1,&mUniformBuffer);

  mInitialized=false;
}

void TriangleGeometry::updateUniforms()
{
  // Compute the normal matrix
  Mat4x4f normalMatrix = mModelMatrix.getInverse().transpose();

  // Upload the new geometry and material properties to the GPU
  glBindBuffer(GL_UNIFORM_BUFFER, mUniformBuffer);
  glBufferSubData(GL_UNIFORM_BUFFER, 0, sizeof(float) * 16,mModelMatrix.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 16, sizeof(float) * 16,normalMatrix.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 32, sizeof(float) * 1,&mShininess);
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 33, sizeof(float) * 1,&mLineWidth);
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 36, sizeof(float) * 4,mColor.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 40, sizeof(float) * 4,mLineColor.ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 44, sizeof(float) * 4,mLightPosition[0].ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 48, sizeof(float) * 4,mLightPosition[1].ptr());
  glBufferSubData(GL_UNIFORM_BUFFER, sizeof(float) * 52, sizeof(float) * 4,mLightPosition[2].ptr());
  glBindBuffer(GL_UNIFORM_BUFFER, 0);
}

void TriangleGeometry::bind(const GLuint shaderProgram,const GLuint bindingPoint, const std::string &blockName) const
{
  GLuint uniformBlockIndex = glGetUniformBlockIndex(shaderProgram, blockName.c_str());
  glUniformBlockBinding(shaderProgram, uniformBlockIndex, bindingPoint);
  glBindBufferRange(GL_UNIFORM_BUFFER, bindingPoint, mUniformBuffer, 0, sizeof(float)*56);
}

} //namespace ogl