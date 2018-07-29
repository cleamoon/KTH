/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:37:19
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
#include <labraytracer/light.h>
#include <labraytracer/renderable.h>
#include <inviwo/core/datastructures/image/layerram.h>

namespace inviwo {

/** \class Scene
    \brief Scene with a number of renderable objects (e.g. Spheres, Triangles), lights
    and properties of the camera.

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API Scene {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    Scene();
    virtual ~Scene() = default;

    //Methods
public:
    void init(const ivec2& imageSize);
    void setCameraProperties(const vec3& lookFrom, const vec3& lookTo, const vec3& lookUp,
                             const double& fov);
    void drawCameraGeometry(std::shared_ptr<BasicMesh> mesh,
                            std::vector<BasicMesh::Vertex>& vertices) const;
    void drawAxesGeometry(std::shared_ptr<BasicMesh> mesh,
                          std::vector<BasicMesh::Vertex>& vertices) const;
    void drawRenderablesGeometry(std::shared_ptr<BasicMesh> mesh,
                                 std::vector<BasicMesh::Vertex>& vertices) const;
    void render(LayerRAM* lr) const;
    Ray getRay(size2_t point) const;
    void addLight(std::shared_ptr<Light> light);
    void addRenderable(std::shared_ptr<Renderable> renderable);
    void clear();
    //Attributes
private:
    vec3 bottomLeft_;
    vec3 topLeft_;
    vec3 bottomRight_;
    vec3 topRight_;
    vec3 forward_;
    vec3 up_;
    vec3 right_;
    vec3 camPos_;
    ivec2 imageSize_;
    std::vector<std::shared_ptr<Light>> lights_;
    std::vector<std::shared_ptr<Renderable>> renderables_;
};

} // namespace
