#ifndef SHADER_HPP_INCLUDE_ONCE
#define SHADER_HPP_INCLUDE_ONCE
#include "openglConfig.hpp"

#include "OpenGL.hpp"

namespace ogl
{

// This class creates a shader program by loading and compiling
// a vertex shader, a geometry shader, and a fragment shader.
// After loading and compiling their source files
// they are linked into a shader program which can later be used for rendering.
class ShaderProgram
{
public:

  OPENGL_EXPORTS ShaderProgram();

  // The init functions needs files for vertex, geometry and fragment shader
  OPENGL_EXPORTS bool init(const std::string &file_vs,
            const std::string &file_gs,
            const std::string &file_fs);

  // The destructor frees the GPU memory for the shader program
  OPENGL_EXPORTS virtual ~ShaderProgram();

  // Returns the handle of the shader program
  OPENGL_EXPORTS GLuint handle() {return mProgram;}

private:

  // Create and compile a shader of a specific type
  GLuint createShader(GLenum shaderType, const std::string &file);

  void clear();

  GLuint mProgram;
  bool   mInitialized;

};
}

#endif //SHADER_HPP_INCLUDE_ONCE