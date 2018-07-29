/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:39:17
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwo.h>

namespace inviwo {

/** \class Ray
    \brief Ray in 3D defined by an origin point and a direction vector

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API Ray {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    Ray();
    virtual ~Ray() = default;
    Ray(const vec3& origin, const vec3& direction);

    //Methods
public:
    const vec3& getOrigin() const { return mOrigin; }
    const vec3& getDirection() const { return mDirection; }
    /// Compute the point on a ray for a given scalar (origin + lamda * direction)
    vec3 pointOnRay(double lambda) const {
        return mOrigin + vec3(mDirection[0] * lambda, mDirection[1] * lambda,
                              mDirection[2] * lambda);
    }

    //Attributes
private:
    vec3 mOrigin;
    vec3 mDirection;

};


} // namespace
