#include <opengl/OpenGL.hpp>
#include <memory>
#include <opengl/IndexedTriangleIO.hpp>
#include <opengl/TriangleGeometry.hpp>
#include <opengl/ShaderProgram.hpp>
#include <opengl/Camera.hpp>
//#include <raytracer/Math.hpp>


int gWidth = 800;  ///< The width of the OpenGL window
int gHeight = 600; ///< The height of the OpenGL window
GLFWwindow* gGLFWWindow;

size_t gNumDice=6; ///< The number of dice
ogl::Vec3f gBackgroundColor(0.7f,0.7f,0.7f); ///< The OpenGL background color

std::shared_ptr<ogl::ShaderProgram> gShaderProgram;        ///< Phong shader handle
std::shared_ptr<ogl::Camera> gCamera;                      ///< Orbit camera
std::vector<std::shared_ptr<ogl::TriangleGeometry>> gDice; ///< The dice
std::shared_ptr<ogl::TriangleGeometry> gLightSphere[3];    ///< Three point lights
std::shared_ptr<ogl::TriangleGeometry> gGroundPlane;       ///< The ground plane
std::shared_ptr<ogl::TriangleGeometry> gAxisArrows[3];     ///< XYZ (RGB) coordinate widget
float gLastFrameTime=0.f;     

std::string gDataPath= ""; ///< The path pointing to the resources (OBJ, shader)
// Display the dice
void displayDice()
{
  for(size_t i=0;i<gDice.size();++i)
  {
    // Set the updated light positions
    std::shared_ptr<ogl::TriangleGeometry> die=gDice[i];
    die->setLightPosition0(gLightSphere[0]->getPosition());
    die->setLightPosition1(gLightSphere[1]->getPosition());
    die->setLightPosition2(gLightSphere[2]->getPosition());

    // Upload the new data to the GPU
    die->updateUniforms();

    // Bind model uniform buffer
    die->bind(gShaderProgram->handle(),1,"ub_Geometry");

    // Bind triangle geometry
    glBindVertexArray(die->handle());

    // Draw the indexed triangle set
    glDrawElements(GL_TRIANGLES, die->numIndices(),GL_UNSIGNED_INT, (void*)0);
  }
};

// Display the coordinate axes
// red arrow   = x-axis
// green arrow = y-axis
// blue arrow  = z-axis
void displayAxisArrows()
{
  for(size_t i=0;i<3;++i)
  {
    // Set the updated light positions
    gAxisArrows[i]->setLightPosition0(gLightSphere[0]->getPosition());
    gAxisArrows[i]->setLightPosition1(gLightSphere[1]->getPosition());
    gAxisArrows[i]->setLightPosition2(gLightSphere[2]->getPosition());

    // Upload the new data to the GPU
    gAxisArrows[i]->updateUniforms();

    // Bind model uniform buffer
    gAxisArrows[i]->bind(gShaderProgram->handle(),1,"ub_Geometry");

    // Bind triangle geometry
    glBindVertexArray(gAxisArrows[i]->handle());

    // Draw the indexed triangle set
    glDrawElements(GL_TRIANGLES, gAxisArrows[i]->numIndices(),GL_UNSIGNED_INT, (void*)0);
  }
}

// Display the ground plane
void displayGroundPlane()
{
  // Set the updated light positions
  gGroundPlane->setLightPosition0(gLightSphere[0]->getPosition());
  gGroundPlane->setLightPosition1(gLightSphere[1]->getPosition());
  gGroundPlane->setLightPosition2(gLightSphere[2]->getPosition());

  // Upload the new data to the GPU
  gGroundPlane->updateUniforms();

  // Bind model uniform buffer
  gGroundPlane->bind(gShaderProgram->handle(),1,"ub_Geometry");

  // Bind triangle geometry
  glBindVertexArray(gGroundPlane->handle());

  // Draw the indexed triangle set
  glDrawElements(GL_TRIANGLES, gGroundPlane->numIndices(),GL_UNSIGNED_INT, (void*)0);
}

// Display the light spheres indicating the light positions
void displayLightSpheres()
{
  // Update the light positions by rotating 3.6 degrees per second about z-axis (up vector)
  // One full rotation thus takes 100 seconds
  for(int i=0;i<3;++i)
    gLightSphere[i]->modelMatrix().rotate(gLastFrameTime*3.6f,ogl::Vec3f(0,0,1));

  // Set the updated light positions
  for(int i=0;i<3;++i)
  {
    gLightSphere[i]->setLightPosition0(gLightSphere[0]->getPosition());
    gLightSphere[i]->setLightPosition1(gLightSphere[1]->getPosition());
    gLightSphere[i]->setLightPosition2(gLightSphere[2]->getPosition());

    // Upload the new data to the GPU
    gLightSphere[i]->updateUniforms();

    // Bind model uniform buffer
    gLightSphere[i]->bind(gShaderProgram->handle(),1,"ub_Geometry");

    // Bind triangle geometry
    glBindVertexArray(gLightSphere[i]->handle());

    // Draw the indexed triangle set
    glDrawElements(GL_TRIANGLES, gLightSphere[i]->numIndices(),GL_UNSIGNED_INT, (void*)0);
  }
}

void displayCB()
{
  // Set polygon mode to allow solid front and back-facing triangles
  glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);

  // Use the Phong shader
  glUseProgram(gShaderProgram->handle());

  // Upload possibly changed camera setup (e.g. camera eye) to GPU
  gCamera->updateUniforms();

  // Bind camera uniform buffer
  gCamera->bind(gShaderProgram->handle(),0,"ub_Camera");

  // Render the scene content
  displayLightSpheres();
  displayAxisArrows();
  displayGroundPlane();
  displayDice();

  // Unbind the Phong shader
  glUseProgram(0);
}

// Initialize the dice geometry
// Load the OBJ files, apply materials and transformations
bool initDice()
{
  ogl::IndexedTriangleIO io;
#ifdef _DEBUG
   // This smaller model loads much faster in debug mode
  io.loadFromOBJ(gDataPath+"assets/dieDebug.obj");
#else
  // This large model loads fast only in release mode
  io.loadFromOBJ(gDataPath+"assets/die.obj");
#endif
  if(io.vertexNormals().empty())
  {
    std::cerr<<"OBJ model needs vertex normals!"<<std::endl;
    return false;
  }

  std::cerr<<"Loaded "<<io.vertexPositions().size()<< " vertices, "<<
    io.triangleIndices().size()/3<<" triangles.\n\n";

  // Create the dice
  gDice.resize(gNumDice);

  for(size_t i=0;i<gDice.size();++i)
  {
    gDice[i]= std::make_shared<ogl::TriangleGeometry>();
    // The first die stores the original geometry (indexed triangle set)
    if(i==0)
      gDice[0]->init(io.vertexPositions(),io.vertexNormals(),io.triangleIndices());
    // The other dice are instances of the original geometry (no duplicate geometry stored)
    else
      gDice[i]->initInstance(gDice[0]);

    // Set a bluish material with shininess=100.f
    gDice[i]->setMaterial(100.f,ogl::Vec3f(0.2f,0.5f,1.0f));
  }

  // TODO: Transform the dice gDice[0..5] to obtain the result
  // shown in the exercise sheet.

  // You can use the Mat4 transformation functions of the model matrices:
  // modelMatrix().translate(tx,ty,tz);
  // modelMatrix().scale(sy,sy,sz);
  // modelMatrix().rotate(angleInDegree,Vec3(axis_X, axis_Y, axis_Z);

  // Note: the origin of the untransformed cube with dimensions
  // x= -0.5 .. 0.5
  // y= -0.5 .. 0.5
  // z=  0.0 .. 1.0
  // is (0,0,0) is the center of the bottom face (with number 1 on it)
  typedef vl::Vector3<float> Vec3f;
  //TODO: Replace these simple transformations
  //gDice[0] should be the large cube with number 1 facing the camera
  gDice[0]->modelMatrix().rotate(-90.0, Vec3f(0, 1, 0));
  gDice[0]->modelMatrix().scale(2, 2, 2);
  gDice[0]->modelMatrix().translate(4,3,1);

  //gDice[1] should be the cube with number 2 facing the camera
  gDice[1]->modelMatrix().rotate(90.0, Vec3f(0, 0, 1));
  gDice[1]->modelMatrix().translate(2.5,2.5,2);

  //gDice[2] should be the cube with number 3 facing the camera
  gDice[2]->modelMatrix().rotate(180.0, Vec3f(0, 0, 1));
  gDice[2]->modelMatrix().translate(2.5,3.5,2);

  //gDice[3] should be the cube with number 4 facing the camera
  gDice[3]->modelMatrix().rotate(180, Vec3f(1, 0, 0));
  gDice[3]->modelMatrix().rotate(90, Vec3f(0, 0, 1));
  gDice[3]->modelMatrix().translate(2.5,3.5,4);

  //gDice[4] should be the cube with number 5 facing the camera
  gDice[4]->modelMatrix().translate(2.5,2.5,3);

  // Hint for gDice[5] that stands on the tip showing number 6
  // the rotation that is performed on this die is equivalent to the rotation
  // of the vector (1,1,1)^T onto the z-axis (0,0,1).
  // It is helpful to compute this transformation on a sheet of paper.

  //gDice[5] should be the cube with number 6 facing the camera
  //gDice[5]->modelMatrix().rotate(90, Vec3f(0, 1, 0));
  //gDice[5]->modelMatrix().translate(0,0,0.5);

  // Bonus, begin
  gDice[5]->modelMatrix().rotate(-40, Vec3f(1, 0, 0));
  gDice[5]->modelMatrix().rotate(30, Vec3f(0, 1, 0));
  gDice[5]->modelMatrix().rotate(-60, Vec3f(0, 0, 1));
  gDice[5]->modelMatrix().translate(2.05, 3.05, 4.55);
  // Bonus, end

  return true;
}

// Initialize the arrow geometry
// Load the OBJ files, apply materials and transformations
bool initAxisArrows()
{
  ogl::IndexedTriangleIO io;
  io.loadFromOBJ(gDataPath+"assets/arrowZ.obj");
  if(io.vertexNormals().empty())
  {
    std::cerr<<"OBJ model needs vertex normals!"<<std::endl;
    return false;
  }

  std::cerr<<"Loaded "<<io.vertexPositions().size()<< " vertices, "<<
    io.triangleIndices().size()/3<<" triangles.\n\n";

  // Create the blue z-axis arrow
  gAxisArrows[0]= std::make_shared<ogl::TriangleGeometry>();
  gAxisArrows[0]->init(io.vertexPositions(),io.vertexNormals(),io.triangleIndices());
  gAxisArrows[0]->setMaterial(50.f,ogl::Vec3f(0,0,1));

  // Create the green y-axis arrow
  gAxisArrows[1]= std::make_shared<ogl::TriangleGeometry>();
  gAxisArrows[1]->initInstance(gAxisArrows[0]);
  gAxisArrows[1]->setMaterial(50.f,ogl::Vec3f(0,1,0));
  // Rotate about x-axis by -90 degrees
  gAxisArrows[1]->modelMatrix().rotate(-90.f,ogl::Vec3f(1,0,0));

  // Create the red x-axis arrow
  gAxisArrows[2]= std::make_shared<ogl::TriangleGeometry>();
  gAxisArrows[2]->setMaterial(50.f,ogl::Vec3f(1,0,0));
  gAxisArrows[2]->initInstance(gAxisArrows[0]);
  // Rotate about y-axis by 90 degrees
  gAxisArrows[2]->modelMatrix().rotate(90.f,ogl::Vec3f(0,1,0));

  return true;
}

// Initialize the ground plane geometry
// Load the OBJ files, apply materials and transformations
bool initGroundPlane()
{
  ogl::IndexedTriangleIO io;
  io.loadFromOBJ(gDataPath+"assets/groundPlane.obj");

  if(io.vertexNormals().empty())
  {
    std::cerr<<"OBJ model needs vertex normals!"<<std::endl;
    return false;
  }

  std::cerr<<"Loaded "<<io.vertexPositions().size()<< " vertices, "<<
    io.triangleIndices().size()/3<<" triangles.\n\n";

  // Create the yellow ground plane
  gGroundPlane= std::make_shared<ogl::TriangleGeometry>();
  gGroundPlane->init(io.vertexPositions(),io.vertexNormals(),io.triangleIndices());

  // Initially the ground plane spans x=-3..3 and y=-3..3
  // Move it such that it spans  x=0..6 and y=0..6
  gGroundPlane->modelMatrix().translate(3,3,0);
  gGroundPlane->setMaterial(100.f,ogl::Vec3f(1.0f,0.7f,0.1f));
  return true;
}

// Initialize the light sphere geometry
// Load the OBJ files, apply materials and transformations
bool initLightSpheres()
{
  ogl::IndexedTriangleIO io;
  io.loadFromOBJ(gDataPath+"assets/lightSphere.obj");

  if(io.vertexNormals().empty())
  {
    std::cerr<<"OBJ model needs vertex normals!"<<std::endl;
    return false;
  }

  std::cerr<<"Loaded "<<io.vertexPositions().size()<< " vertices, "<<
    io.triangleIndices().size()/3<<" triangles.\n\n";

  for(int i=0;i<3;++i)
  {
    gLightSphere[i]= std::make_shared<ogl::TriangleGeometry>();
    // The first sphere stores the original geometry (indexed triangle set)
    if(i==0)
      gLightSphere[i]->init(io.vertexPositions(),io.vertexNormals(),io.triangleIndices());
    // The other spheres are instances of the original geometry (no duplicate geometry stored)
    else
      gLightSphere[i]->initInstance(gLightSphere[0]);

    // Move away from the origin
    gLightSphere[i]->modelMatrix().translate(6,0,2);
  }

  // Position three spheres on a circle equidistantly
  //gLightSphere[0]->modelMatrix().rotate(0,ogl::Vec3f(0,0,1));
  gLightSphere[1]->modelMatrix().rotate(120,ogl::Vec3f(0,0,1));
  gLightSphere[2]->modelMatrix().rotate(240,ogl::Vec3f(0,0,1));

  return true;
}

// Initialize the OpenGL, camera, shader and calls
// geometry-related init-functions.
bool init()
{
  // Activate depth test to discard fragment that are hidden
  glEnable(GL_DEPTH_TEST);

  // Activate anti-aliasing
  glEnable(GL_MULTISAMPLE);

  // Create camera
  gCamera = std::make_shared<ogl::Camera>(gWidth,gHeight);
  gCamera->setPosition(ogl::Vec3f(16,-9,6));
  gCamera->setTarget(ogl::Vec3f(3,3,2));

  // Create Phong shader
  gShaderProgram   = std::make_shared<ogl::ShaderProgram>();
    if(!gShaderProgram->init(
      gDataPath+"assets/SolidWirePhong.vs",
      gDataPath+"assets/SolidWirePhong.gs",
      gDataPath+"assets/SolidWirePhong.fs"))
      return false;

  //Call geometry-related init-functions
  if(!initLightSpheres())
    return false;

  if(!initAxisArrows())
    return false;

  if(!initGroundPlane())
    return false;

  if(!initDice())
    return false;


  return true;
}

// This callback is called upon resizing the OpenGL window,
// e.g. when maximizing the window
void resizeCB(GLFWwindow* window, int width, int height)
{
  gCamera->resize(width,height);
}

// This callback is called when moving the mouse while a button is pressed
void motionCB(GLFWwindow* window,double x, double y)
{
  gCamera->mouseMoved(int(x),int(y));
}

// This callback is called when a mouse button is pressed or released
void mouseCB(GLFWwindow* window, int button, int state, int mods)
{
  gCamera->mouseButtonPressed(button,state);
}

// This callback is called when the scroll wheel is used
void wheelCB(GLFWwindow* window, double xOffset, double yOffset)
{
  gCamera->mouseWheelScrolled(int(yOffset));
}

void glfwErrorCallback(int errorCode, const char* description)
{
  std::cerr<<"GLFW Error Code "<<errorCode<<": "<<description<<std::endl;
}


// Main entry point
int main (int argc, char** argv)
{
  std::string pathToThisFile=__FILE__;

  if(gDataPath.empty())
    gDataPath=rt::Math::getParentDirectoryFromFilePath(pathToThisFile);
  std::cerr<<"Using data path: "<<gDataPath<<std::endl;

  std::cerr<<"Use your mouse to rotate,pan and zoom the camera"<<std::endl;
  std::cerr<<"left mouse button + drag -> rotate"<<std::endl;
  std::cerr<<"middle mouse button + drag -> pan"<<std::endl;
  std::cerr<<"scroll wheel up / down -> zoom in / out"<<std::endl;

  if( !glfwInit() )
  {
    std::cerr<<"Failed to initialize GLFW\n"<<std::endl;
    return -1;
  }

  glfwSetErrorCallback(glfwErrorCallback);

  // Create the OpenGL window
  glfwWindowHint(GLFW_DEPTH_BITS, 16);
  glfwWindowHint(GLFW_SAMPLES, 4);

  //Those stop GLFW from initializing successfully?
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  // Open OpenGL fullscreen window
  gGLFWWindow = glfwCreateWindow(gWidth,gHeight,"GLFW OpenGL Window",nullptr,nullptr);

  //// Open OpenGL fullscreen window
  //if( !glfwOpenWindow( gWidth, gHeight, 0,0,0,0, 16,0, GLFW_WINDOW ) )
  //{
  //  fprintf( stderr, "Failed to open GLFW window\n" );
  //  glfwTerminate();
  //  exit( EXIT_FAILURE );
  //}

  if(!gGLFWWindow)
  {
    std::cerr<<"Failed to open GLFW window\n"<<std::endl;
    glfwTerminate();
    return -1;
  }

  // Disable VSync (we want to get as high FPS as possible!)

  glfwMakeContextCurrent(gGLFWWindow);
  glfwSwapInterval( 1 );

  // Setting this is necessary for core profile (tested with MSVC 2013 x64, Windows 7)
  glewExperimental = GL_TRUE;
  // GLEW wraps all OpenGL functions and extensions
  GLenum err = glewInit();
  if(err != GLEW_OK)
  {
    std::cerr<<"Failed to initialize GLEW"<<std::endl;
    std::cerr<<(char*)glewGetErrorString(err)<<std::endl;
    glfwTerminate();
    return -1;
  }
  glGetError(); //GLEW might cause an 'invalid enum' error, safely ignore it?

  // Print OpenGL context information to console
  ogl::printContextInformation();

  // Perform our initialization (OpenGL states, shader, camera, geometry)
  if(!init())
    return -1;

  // Set the appropriate callback functions
  // Window resize callback function
  glfwSetFramebufferSizeCallback(gGLFWWindow,resizeCB);
  glfwSetMouseButtonCallback(gGLFWWindow,mouseCB);
  glfwSetScrollCallback(gGLFWWindow,wheelCB);
  glfwSetCursorPosCallback(gGLFWWindow,motionCB);


  while( !glfwWindowShouldClose(gGLFWWindow) )
  {
    // Get the current time (in milliseconds since program start)
    double t0 =glfwGetTime();

    // Clear frame and depth buffers
    glClearColor(gBackgroundColor[0],gBackgroundColor[1],gBackgroundColor[2], 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // Draw...
    displayCB();

    // Hopefully there hasn't been any mistake?
    ogl::printOpenGLError();

    // Swap the rendering target with the frame buffer shown on the monitor
    glfwSwapBuffers(gGLFWWindow);

    glfwPollEvents() ;

    // Compute rendering time in seconds by taking difference to current time
    double t1=glfwGetTime();
    gLastFrameTime = float(t1-t0);
  }

  // Terminate OpenGL
  glfwTerminate();
  return 0;
}
