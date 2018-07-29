#include "Math.hpp"

namespace ogl
{

  std::default_random_engine Math::mRandomGenerator = std::default_random_engine();
  std::uniform_real_distribution<float> Math::mUniformDistribution = std::uniform_real_distribution<float>();

}