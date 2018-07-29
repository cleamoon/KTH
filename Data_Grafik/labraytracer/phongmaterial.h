/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 24, 2017 - 17:17:44
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <labraytracer/material.h>

namespace inviwo {

/** \class PhongMaterial
    \brief Material that can be lit with the Phong illumination model

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API PhongMaterial : public Material {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    PhongMaterial(const vec3& color = vec3(0, 0.4, 0.8),
                  const double reflectance = 1.0,
                  const double shininess = 10.0,
                  const vec3& ambientMaterialColor = vec3(0, 0.4, 0.8),
                  const vec3& diffuseMaterialColor_ = vec3(0, 0.4, 0.8),
                  const vec3& specularMatierialColor_ = vec3(0, 0.4, 0.8)
        );
    virtual ~PhongMaterial() = default;

    //Methods
public:
    vec4 shade(const RayIntersection& intersection, const Light& light) const override;
    //Attributes
public:
    double shininess_;
    vec3 ambientMaterialColor_;
    vec3 diffuseMaterialColor_;
    vec3 specularMatierialColor_;
};

} // namespace
