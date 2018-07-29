#ifndef OPENGL_MATH_HPP_INCLUDE_ONCE
#define OPENGL_MATH_HPP_INCLUDE_ONCE
#include "openglConfig.hpp"

#include <cmath>
#include <algorithm>
#include <limits>
#include <raytracer/Math.hpp>
#include <random>


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

namespace ogl
{
  typedef rt::Vec2f   Vec2f;
  typedef rt::Vec3f   Vec3f;
  typedef rt::Vec4f   Vec4f;

  typedef rt::Vec2d   Vec2d;
  typedef rt::Vec3d   Vec3d;
  typedef rt::Vec4d   Vec4d;

  typedef rt::Mat3x3f Mat3x3f;
  typedef rt::Mat4x4f Mat4x4f;

  typedef rt::Mat3x3d Mat3x3d;
  typedef rt::Mat4x4d Mat4x4d;


  typedef rt::Vec2i   Vec2i;
  typedef rt::Vec3i   Vec3i;
  typedef rt::Vec4i   Vec4i;

class Math
{
public:

  template <typename T>
  static T clamp(T val, T minVal=T(0), T maxVal=T(1))
  {
    return std::max(minVal, std::min(maxVal,val));
  }

  inline static const float safetyEps() { return float(0.0001f); }



  template <typename T>
  static T log2(T d) {return log(d)/log(T(2)) ;}


  OPENGL_EXPORTS static void orthonormalBasis(const Vec3f& normal, Vec3f& U, Vec3f& V, Vec3f& W)
  {
    // create orthonormal basis
    W = normal;
    W.normalize();
    U = cross(W, Vec3f(0,1,0));
    if (fabs(U[0]) < Math::safetyEps() && fabs(U[1]) < Math::safetyEps() && fabs(U[2]) < Math::safetyEps())
      U = cross(W, Vec3f(1,0,0));
    U.normalize();
    V = cross(W,U);
  }

  OPENGL_EXPORTS static Vec3f sampleUnitSphere()
  {
    float phi = random(0,float(2*M_PI));
    float r = random(); r=r*r*r;
    float cos_theta = random(-1,1);

    float x = r*sqrt(1-cos_theta*cos_theta)*cos(phi);
    float y = r*sqrt(1-cos_theta*cos_theta)*sin(phi);
    float z = r*cos_theta;

    return Vec3f(x,y,z).normalize();
  }

  OPENGL_EXPORTS static Vec3f sampleUnitHemisphereCosine()
  {
    float sample_x = random();
    float sample_y = random();
    float phi = float(2.f * M_PI * sample_x);
    float r = float(sqrt(sample_y));
    float x = r * float(cos(phi));
    float y = r * float(sin(phi));
    float z = 1.f - x*x - y*y;
    z = z > 0.f ? sqrt(z) : 0.f;
    return Vec3f(x,y,z);
  }

  OPENGL_EXPORTS static Vec3f sampleDirectionUnitHemisphereCosine(const Vec3f &N)
  {
    Vec3f U,V,W;
    orthonormalBasis(N,U,V,W);

    Vec3f D = sampleUnitHemisphereCosine();

    return (U * D[0] + V * D[1] + W * D[2]).normalize();
  }

  OPENGL_EXPORTS static Vec3f samplePhongLobe(const float exponent)
  {
   float sample_x = random();
   float sample_y = random();
   float power = exp( log(sample_y) / (exponent+1.f) );
   float phi = float(2.f * M_PI * sample_x);
   float scale = sqrt(1.f-power*power);
   float x = scale * float(cos(phi));
   float y = scale * float(sin(phi));
   float z = power;
   return Vec3f(x,y,z);
  }

  OPENGL_EXPORTS static Vec3f sampleDirectionPhongLobe(const Vec3f & N, const float exponent)
  {
    Vec3f U,V,W;
    orthonormalBasis(N,U,V,W);

    Vec3f D = samplePhongLobe(exponent);

    return (U * D[0] + V * D[1] + W * D[2]).normalize();
  }

  // generates a uniformly distributed random number in [0..1]
  OPENGL_EXPORTS inline static const float random(float minValue = 0.f, float maxValue = 1.f)
  {
    return mUniformDistribution(mRandomGenerator) * (maxValue-minValue)+minValue;
  }

private:
  static std::default_random_engine mRandomGenerator;
  static std::uniform_real_distribution<float> mUniformDistribution;
};

} //namespace cg

#endif //OPENGL_MATH_HPP_INCLUDE_ONCE
