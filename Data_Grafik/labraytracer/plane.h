/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 24, 2017 - 14:35:30
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <labraytracer/renderable.h>

namespace inviwo {

/** \class Plane
    \brief Plane in 3D defined by a point and a normal vector

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API PlaneX : public Renderable {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    PlaneX(const vec3& normal = vec3(0, 0, 1), const vec3& point = vec3(0, 0, 0));
    virtual ~PlaneX() = default;

    //Methods
public:
    bool closestIntersection(const Ray& ray, double maxLambda, RayIntersection& intersection) const
    override;
    bool anyIntersection(const Ray& ray, double maxLambda) const override;
    void drawGeometry(std::shared_ptr<BasicMesh> mesh,
                      std::vector<BasicMesh::Vertex>& vertices) const override;
    //Attributes
private:
    vec3 normal_;
    vec3 point_;

};

} // namespace
