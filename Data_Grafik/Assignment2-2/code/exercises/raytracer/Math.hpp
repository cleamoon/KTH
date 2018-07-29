#ifndef MATH_HPP_INCLUDE_ONCE
#define MATH_HPP_INCLUDE_ONCE

#include "raytracerConfig.hpp"

#include <cmath>
#include <chrono>
#include <algorithm>
#include <limits>
#include <iostream>
#include "Vector2.hpp"
#include "Vector3.hpp"
#include "Vector4.hpp"
#include "Matrix2.hpp"
#include "Matrix3.hpp"
#include "Matrix4.hpp"

#ifndef M_PI
# define M_PI 3.14159265358979323846 /* pi */
# define M_PI_2 1.57079632679489661923 /* pi/2 */
# define M_PI_4 0.78539816339744830962 /* pi/4 */
# define M_1_PI 0.31830988618379067154 /* 1/pi */
# define M_2_PI 0.63661977236758134308 /* 2/pi */
# define M_2_SQRTPI 1.12837916709551257390 /* 2/sqrt(pi) */
# define M_PIl 3.1415926535897932384626433832795029L /* pi */
# define M_PI_2l 1.5707963267948966192313216916397514L /* pi/2 */
# define M_PI_4l 0.7853981633974483096156608458198757L /* pi/4 */
# define M_1_PIl 0.3183098861837906715377675267450287L /* 1/pi */
# define M_2_PIl 0.6366197723675813430755350534900574L /* 2/pi */
# define M_2_SQRTPIl 1.1283791670955125738961589031215452L /* 2/sqrt(pi) */
#endif

namespace rt
{
  typedef std::chrono::time_point<std::chrono::high_resolution_clock> Chrono;
  typedef std::chrono::duration<double> ChronoDuration;

  typedef vl::Vector2<float> Vec2f;
  typedef vl::Vector3<float> Vec3f;
  typedef vl::Vector4<float> Vec4f;

  typedef vl::Vector2<double> Vec2d;
  typedef vl::Vector3<double> Vec3d;
  typedef vl::Vector4<double> Vec4d;

  typedef vl::Matrix3<float> Mat3x3f;
  typedef vl::Matrix4<float> Mat4x4f;

  typedef vl::Matrix3<double> Mat3x3d;
  typedef vl::Matrix4<double> Mat4x4d;


  typedef vl::Vector2<int> Vec2i;
  typedef vl::Vector3<int> Vec3i;
  typedef vl::Vector4<int> Vec4i;

class Math
{
public:

  template <typename T>
  static T clamp(T val, T minVal=T(0), T maxVal=T(1))
  {
    return std::max(minVal, std::min(maxVal,val));
  }

  RAYTRACER_EXPORTS inline static const double safetyEps() { return 0.000000001; }

  template <typename T>
  static T log2(T d) {return log(d)/log(T(2)) ;}	



  RAYTRACER_EXPORTS static void replaceSubstring(std::string& str, const std::string& oldStr, const std::string& newStr)
  {
    size_t pos = 0;
    while((pos = str.find(oldStr, pos)) != std::string::npos)
    {
      str.replace(pos, oldStr.length(), newStr);
      pos += newStr.length();
    }
  }
  RAYTRACER_EXPORTS static std::string getParentDirectoryFromFilePath(std::string filePath)
  {
    replaceSubstring(filePath,"\\","/");
    std::string::reverse_iterator sit=filePath.rbegin();
    int stopAt(0);
    while(stopAt != 2 && sit!=filePath.rend())
    {
      if((*sit) == '/')
        ++stopAt;
      ++sit;
    }

    std::string directory(sit,filePath.rend());
    std::reverse(directory.begin(),directory.end());
    directory+="/";
    return directory;
  }



};

} //namespace rt

inline std::ostream& operator<<(std::ostream& _s,const rt::Vec3d& _v)
{
  _s << _v[0]<<"," << _v[1]<<","<< _v[2];
  return _s;
}

#endif //MATH_HPP_INCLUDE_ONCE
