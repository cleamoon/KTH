#include "ShaderProgram.hpp"
#include <fstream>

namespace ogl
{

ShaderProgram::ShaderProgram() : mInitialized(false)
{
}

bool ShaderProgram::init(const std::string &file_vs, const std::string &file_gs, const std::string &file_fs)
{
  this->clear();

  // Load and compile the shader code
  GLuint vertexShader = this->createShader(GL_VERTEX_SHADER,file_vs);
  GLuint geometryShader = this->createShader(GL_GEOMETRY_SHADER,file_gs);
  GLuint fragmentShader = this->createShader(GL_FRAGMENT_SHADER,file_fs);

  // Create a shader program
  mProgram = glCreateProgram();
  ogl::printOpenGLError();

  // Add and link the shaders to a program
  glAttachShader(mProgram,vertexShader);
  glAttachShader(mProgram,geometryShader);
  glAttachShader(mProgram,fragmentShader);
  glLinkProgram(mProgram);
  ogl::printGLSLProgramError(mProgram);
  ogl::printOpenGLError();

  // Free the memory of the compiled shader sources
  // We only need the shader program for rendering!
  glDeleteShader(vertexShader);
  glDeleteShader(geometryShader);
  glDeleteShader(fragmentShader);

  mInitialized=true;
  return true;
}

GLuint ShaderProgram::createShader(GLenum shaderType, const std::string &file)
{
  GLuint shaderHandle;
  // Load and compile shader
  {
    std::ifstream in(file, std::ios::binary | std::ios::in);
    if (!in.is_open())
      std::cerr<<"Could not open shader source file "<<file<<std::endl;

    //load file content to string
    std::string source((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    shaderHandle = glCreateShader(shaderType);
    ogl::printOpenGLError();
    const char* s = source.c_str();
    glShaderSource(shaderHandle,1,&s,NULL);
    glCompileShader(shaderHandle);
    ogl::printGLSLShaderError(shaderHandle);
    ogl::printOpenGLError();
  }

  return shaderHandle;
}

ShaderProgram::~ShaderProgram()
{
  this->clear();
}

void ShaderProgram::clear()
{
  if(mInitialized)
    glDeleteProgram(mProgram);

  mInitialized=false;
}

}