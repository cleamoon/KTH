#ifndef RAYTRACER_WINDOW_HPP_INCLUDE_ONCE
#define RAYTRACER_WINDOW_HPP_INCLUDE_ONCE
#include "openglConfig.hpp"

#include <opengl/OpenGL.hpp>
#include <raytracer/Image.hpp>

namespace rt
{
  class RaytracerWindow
  {
  public:
    OPENGL_EXPORTS RaytracerWindow(int width=800, int height=600) {mWidth=width;mHeight=height;}

    OPENGL_EXPORTS virtual ~RaytracerWindow(){this->deinit();}

    OPENGL_EXPORTS void deinit();

    OPENGL_EXPORTS bool init();

    OPENGL_EXPORTS void drawOnce(std::shared_ptr<Image> image);

  private:

    int mWidth;  ///< The width of the OpenGL window
    int mHeight; ///< The height of the OpenGL window
    GLFWwindow* mGLFWWindow;

    struct Texel
    {
      unsigned char r;
      unsigned char g;
      unsigned char b;
   };
  };
}

#endif //RAYTRACER_WINDOW_HPP_INCLUDE_ONCE