/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:41:28
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/rayintersection.h>

namespace inviwo {

RayIntersection::RayIntersection() {
}

RayIntersection::RayIntersection(const Ray& ray, std::shared_ptr<const Renderable> renderable,
                                 const double lambda, const vec3& normal, const vec3& uvw) {
    mRay = ray;
    mRenderable = renderable;
    mLambda = lambda;
    mNormal = normal;
    mUVW = uvw;
    mPosition = ray.pointOnRay(mLambda);
}

} // namespace
