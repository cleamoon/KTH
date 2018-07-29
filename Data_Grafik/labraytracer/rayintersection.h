/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:41:28
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <labraytracer/ray.h>
#include <labraytracer/renderable.h>

namespace inviwo {

class Renderable;

/** \class RayIntersection
    \brief Intersection of a Renderable with a ray. 
        It is defined by the intersection point, normal at the intersection, etc.

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API RayIntersection {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    RayIntersection();

    RayIntersection(const Ray& ray, std::shared_ptr<const Renderable> renderable,
                    const double lambda, const vec3& normal, const vec3& uvw);

    virtual ~RayIntersection() = default;

    //Methods
public:
    double getLambda() const { return mLambda; }
    const vec3& getNormal() const { return mNormal; }
    const vec3& getPosition() const { return mPosition; }
    std::shared_ptr<const Renderable> getRenderable() const { return mRenderable; }
    const Ray& getRay() const { return mRay; }
    //Attributes
protected:
    Ray mRay;
    std::shared_ptr<const Renderable> mRenderable;
    double mLambda;
    vec3 mPosition;
    vec3 mNormal;
    vec3 mUVW;
};

} // namespace
