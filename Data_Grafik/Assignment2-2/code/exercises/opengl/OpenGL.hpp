#ifndef OPENGL_HEADER_INCLUDE_ONCE
#define OPENGL_HEADER_INCLUDE_ONCE
#include "openglConfig.hpp"

#include <GL/glew.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include <string>
#include <memory>
#include "Math.hpp"

namespace ogl
{
#define printOpenGLError() _printOpenGLError(__FILE__, __LINE__)
#define printGLSLShaderError(shader) _printGLSLShaderError(shader,__FILE__, __LINE__)
#define printGLSLProgramError(program) _printGLSLProgramError(program,__FILE__, __LINE__)
  OPENGL_EXPORTS inline int _printOpenGLError(const std::string &file, int line)
  {
    GLenum glErr;
    int    retCode = 0;

    glErr = glGetError();
    if (glErr != GL_NO_ERROR)
    {
      std::cerr<<"glError in file "<<file<<" @ line "<<line<<":"<<gluErrorString(glErr)<<std::endl;
      retCode = 1;
    }
    return retCode;
  }

  OPENGL_EXPORTS inline void _printGLSLShaderError(GLuint shader, const std::string &file, int line)
  {
    GLint shaderCompileStatus(GL_TRUE);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &shaderCompileStatus);

    if(shaderCompileStatus != GL_TRUE) //something critical went wrong
    {
      std::string res;
      int infologLength = 0;
      int charsWritten  = 0;
      char *infoLog;
      glGetShaderiv(shader, GL_INFO_LOG_LENGTH,&infologLength);

      if (infologLength > 0)
      {
        infoLog = (char *)malloc(infologLength);
        glGetShaderInfoLog(shader, infologLength, &charsWritten, infoLog);
        std::cerr<<"GLSL Shader Compile Error: "<<file<<" @ line "<<line<<":"<<std::endl;
        std::cerr<<infoLog<<std::endl;
        free(infoLog);
      }
    }
  }

  OPENGL_EXPORTS inline void _printGLSLProgramError(GLuint program, const std::string &file, int line)
  {
    GLint programLinkStatus(GL_TRUE);
    ogl::printOpenGLError();
    glGetProgramiv(program, GL_LINK_STATUS, &programLinkStatus); 
    ogl::printOpenGLError();

    if(programLinkStatus != GL_TRUE) //something critical went wrong
    {
      std::string res;
      int infologLength = 0;
      int charsWritten  = 0;
      char *infoLog;
      glGetProgramiv(program, GL_INFO_LOG_LENGTH,&infologLength);

      if (infologLength > 0)
      {
        infoLog = (char *)malloc(infologLength);
        glGetProgramInfoLog(program, infologLength, &charsWritten, infoLog);
        std::cerr<<"GLSL Shader Linker Error: "<<file<<" @ line "<<line<<":"<<std::endl;
        std::cerr<<infoLog<<std::endl;
        free(infoLog);
      }
    }
  }
  
  OPENGL_EXPORTS inline void printContextInformation()
  {
    std::cout<<"OpenGL Context Information:"<<std::endl;
    std::cerr<<"Renderer: "<<glGetString(GL_RENDERER)<<std::endl;
    std::cerr<<"Vendor: "<<glGetString(GL_VENDOR)<<std::endl;
    std::cerr<<"Version: "<<glGetString(GL_VERSION)<<std::endl;

    GLint profile;
    glGetIntegerv(GL_CONTEXT_PROFILE_MASK,&profile);

    switch (profile)
    {
    case GL_CONTEXT_CORE_PROFILE_BIT:
      std::cout<<"Profile: Core"<<std::endl;
      break;
    case GL_CONTEXT_COMPATIBILITY_PROFILE_BIT:
      std::cout<<"Profile: Compatibility"<<std::endl;
      break;
    default:
      std::cout<<"Profile: unknown ("<<profile<<")"<<std::endl;
      break;
    }

    std::cout<<std::endl;
  }

}

#endif //OPENGL_HEADER_INCLUDE_ONCE
