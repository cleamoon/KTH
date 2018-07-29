#include "RaytracerWindow.hpp"
#include <fstream>
#include <chrono>
#include <thread>

namespace rt
{

void glfwErrorCallback(int errorCode, const char* description)
{
  std::cerr<<"GLFW Error Code "<<errorCode<<": "<<description<<std::endl;
}

void RaytracerWindow::deinit()
{
  glfwTerminate();
}

bool RaytracerWindow::init()
{
  if( !glfwInit() )
  {
    std::cerr<<"Failed to initialize GLFW\n"<<std::endl;
    return false;
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
  mGLFWWindow = glfwCreateWindow(mWidth,mHeight,"GLFW OpenGL Window",nullptr,nullptr);

  if(!mGLFWWindow)
  {
    std::cerr<<"Failed to open GLFW window\n"<<std::endl;
    this->deinit();
    return false;
  }
  // Disable VSync (we want to get as high FPS as possible!)

  glfwMakeContextCurrent(mGLFWWindow);
  glfwSwapInterval( 1 );

  // Setting this is necessary for core profile (tested with MSVC 2013 x64, Windows 7)
  glewExperimental = GL_TRUE;
  // GLEW wraps all OpenGL functions and extensions
  GLenum err = glewInit();
  if(err != GLEW_OK)
  {
    std::cerr<<"Failed to initialize GLEW"<<std::endl;
    std::cerr<<(char*)glewGetErrorString(err)<<std::endl;
    this->deinit();
    return false;
  }
  glGetError(); //GLEW might cause an 'invalid enum' error, safely ignore it?

  // Print OpenGL context information to console
  ogl::printContextInformation();

  // Perform OpenGL initialization

  // Activate depth test to discard fragment that are hidden
  glEnable(GL_DEPTH_TEST);

  // Activate anti-aliasing
  glEnable(GL_MULTISAMPLE);

  // Enable alpha blending
  glEnable(GL_BLEND);

  // Set polygon mode to allow solid front and back-facing triangles
  glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);


  return true;
}

void RaytracerWindow::drawOnce(std::shared_ptr<Image> image)
{
  // Generate a vertex array object
  float tri[] = { -1.f, 1.f,0.f,
                  -1.f,-1.f,0.f,
                   1.f,-1.f,0.f,
                   1.f,-1.f,0.f,
                   1.f, 1.f,0.f,
                  -1.f, 1.f,0.f};
  GLuint triangleDummy;
  glGenBuffers(1,&triangleDummy);
  glBindBuffer(GL_ARRAY_BUFFER, triangleDummy);
  glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 18, &tri[0], GL_STATIC_DRAW);
  ogl::printOpenGLError();

  GLuint quadVAO;
  glGenVertexArrays(1, &quadVAO);
  glBindVertexArray(quadVAO);
  glBindBuffer(GL_ARRAY_BUFFER, triangleDummy);
  glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glEnableVertexAttribArray(0);
  glBindVertexArray(0);
  ogl::printOpenGLError();

  GLuint vertexShaderHandle,fragmentShaderHandle;
  {
    vertexShaderHandle = glCreateShader(GL_VERTEX_SHADER);
    const char* s = "#version 330 core\n"
                    "#pragma optionNV(strict on)\n"
                    "layout(location = 0) in vec3 position;\n"
                    "out vec2 vUV;\n"
                    "void main(void)\n"
                    "{\n"
                    "gl_Position=vec4(position,1.f);\n"
                    "vUV=(position.xy+vec2(1.f))/2.f;\n"
                    "}\n";
    glShaderSource(vertexShaderHandle,1,&s,NULL);
    glCompileShader(vertexShaderHandle);
    ogl::printGLSLShaderError(vertexShaderHandle);
    ogl::printOpenGLError();
  }
  {
    fragmentShaderHandle = glCreateShader(GL_FRAGMENT_SHADER);
    const char* s = "#version 330 core\n"
                    "#pragma optionNV(strict on)\n"
                    "in vec2 vUV;\n"
                    "out vec4 fColor;\n"
                    "uniform sampler2D imageSampler;\n"
                    "void main()\n"
                    "{\n"
                    "fColor = texture(imageSampler, vUV);\n"
                    "}\n";
    glShaderSource(fragmentShaderHandle,1,&s,NULL);
    glCompileShader(fragmentShaderHandle);
    ogl::printGLSLShaderError(fragmentShaderHandle);
    ogl::printOpenGLError();
  }

  GLuint shaderProgram =glCreateProgram();
  ogl::printOpenGLError();

  // Add and link the shaders to a program
  glAttachShader(shaderProgram,vertexShaderHandle);
  glAttachShader(shaderProgram,fragmentShaderHandle);
  glLinkProgram(shaderProgram);
  ogl::printGLSLProgramError(shaderProgram);
  ogl::printOpenGLError();

  glUseProgram(shaderProgram);
  ogl::printOpenGLError();

  GLuint imageTexture;
  glGenTextures(1, &imageTexture);
  glBindTexture(GL_TEXTURE_2D, imageTexture);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,     GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,     GL_CLAMP_TO_EDGE);

  std::vector<Texel> texels(image->width()*image->height());
  for(size_t j=0;j<image->height();++j)
  {
    for(size_t i=0;i<image->width();++i)
    {
      const Vec4d& pixel=image->pixel(i,j);
      Texel& texel=texels[i+image->width()*j];
      texel.r=(unsigned char) std::max(0.0,std::min(255.0,255.0*pixel[0]));
      texel.g=(unsigned char) std::max(0.0,std::min(255.0,255.0*pixel[1]));
      texel.b=(unsigned char) std::max(0.0,std::min(255.0,255.0*pixel[2]));
    }
  }

  glTexImage2D(
    GL_TEXTURE_2D, 0,           /* target, level of detail */
    GL_RGB8,                    /* internal format */
    GLsizei(image->width()), GLsizei(image->height()), 0,           /* width, height, border */
    GL_RGB, GL_UNSIGNED_BYTE,   /* external format, type */
    &(texels[0].r)                      /* pixels */
    );

  while( !glfwWindowShouldClose(mGLFWWindow) )
  {
    // Clear frame and depth buffers
    glClearColor(0.f,1.f,0.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, imageTexture);
    // glUniform1i(g_resources.uniforms.textures[0], 0);

    glBindVertexArray(quadVAO);
    glDrawArrays(GL_TRIANGLES, 0, 6);

    // Hopefully there hasn't been any mistake?
    ogl::printOpenGLError();

    // Swap the rendering target with the frame buffer shown on the monitor
    glfwSwapBuffers(mGLFWWindow);

    std::chrono::milliseconds timespan(50); // or whatever

    std::this_thread::sleep_for(timespan);

    glfwPollEvents() ;
  }
}
}
