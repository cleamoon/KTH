#ifndef RAYTRACER_CONFIG_INCLUDE_ONCE
#define RAYTRACER_CONFIG_INCLUDE_ONCE

#if defined WIN32
#   if defined raytracer_EXPORTS
#      define RAYTRACER_EXPORTS __declspec(dllexport)
#   else
#      define RAYTRACER_EXPORTS __declspec(dllimport)
#   endif
#else
#   define RAYTRACER_EXPORTS
#endif

#endif //RAYTRACER_CONFIG_INCLUDE_ONCE