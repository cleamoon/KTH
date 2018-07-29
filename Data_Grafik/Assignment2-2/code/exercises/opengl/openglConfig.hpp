#ifndef OPENGL_CONFIG_INCLUDE_ONCE
#define OPENGL_CONFIG_INCLUDE_ONCE

#if defined WIN32
#   if defined opengl_EXPORTS
#      define OPENGL_EXPORTS __declspec(dllexport)
#   else
#      define OPENGL_EXPORTS __declspec(dllimport)
#   endif
#else
#   define OPENGL_EXPORTS
#endif

#endif //OPENGL_CONFIG_INCLUDE_ONCE