/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Thursday, October 19, 2017 - 12:14:16
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/constantmaterial.h>

namespace inviwo {

ConstantMaterial::ConstantMaterial(const vec3& color): Material(color) {

}

vec4 ConstantMaterial::shade(const RayIntersection& intersection, const Light& light) const {
    return vec4(this->color(), 1.0);
}

} // namespace
