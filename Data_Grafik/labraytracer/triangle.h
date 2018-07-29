/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:24:30
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

/** \class Triangle
    \brief Triangle defined by three points

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API Triangle : public Renderable {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    Triangle();
    Triangle(const vec3& v0, const vec3& v1, const vec3& v2,
             const vec3& uvw0 = vec3(0, 0, 0), const vec3& uvw1 = vec3(0, 0, 0),
             const vec3& uvw2 = vec3(0, 0, 0));
    virtual ~Triangle() = default;

    //Methods
public:
    bool closestIntersection(const Ray& ray, double maxLambda, RayIntersection& intersection) const
    override;
    bool anyIntersection(const Ray& ray, double maxLambda) const override;
    void drawGeometry(std::shared_ptr<BasicMesh> mesh,
                      std::vector<BasicMesh::Vertex>& vertices) const override;

    //Attributes
private:
    vec3 mVertices[3];
    vec3 mUVW[3];
};

} // namespace
