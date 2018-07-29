/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:37:00
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

/** \class Light
    \brief Light defined by position and light colors

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API Light {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    Light(const vec3& position = vec3(0, 0, 0), 
        const vec3& mAmbientColor = vec3(1, 1, 1),
        const vec3& mDiffuseColor = vec3(1, 1, 1),
        const vec3& mSpecularColor = vec3(1, 1, 1));
    virtual ~Light() = default;

    //Methods
public:
    const vec3& getPosition() const { return mPosition; }
    const vec3& getAmbientColor() const { return mAmbientColor; }
    const vec3& getDiffuseColor() const { return mDiffuseColor; }
    const vec3& getSpecularColor() const { return mSpecularColor; }

    //Attributes
private:
    vec3 mPosition;
    vec3 mAmbientColor;
    vec3 mDiffuseColor;
    vec3 mSpecularColor;

};

} // namespace
