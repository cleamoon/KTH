/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:39:17
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/ray.h>
#include <labraytracer/util.h>

namespace inviwo {

Ray::Ray() {
}

Ray::Ray(const vec3& origin, const vec3& direction) {
    mOrigin = origin;
    mDirection = Util::normalize(direction);
}

} // namespace
