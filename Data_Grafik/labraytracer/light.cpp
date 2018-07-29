/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:37:00
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/light.h>

namespace inviwo {

Light::Light(const vec3& position, const vec3& ambientColor, const vec3& diffuseColor, const vec3& specularColor) {
    mPosition = position;
    mAmbientColor = ambientColor;
    mDiffuseColor = diffuseColor;
    mSpecularColor = specularColor;
}

} // namespace
