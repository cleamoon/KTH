/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:37:19
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/scene.h>
#include <labraytracer/util.h>

#ifndef __clang__
#include <omp.h>
#endif


namespace inviwo {

Scene::Scene() {

}

void Scene::init(const ivec2& imageSize) {
    imageSize_ = imageSize;
}

void Scene::setCameraProperties(const vec3& lookFrom, const vec3& lookTo, const vec3& lookUp,
                                const double& fov) {
    camPos_ = lookFrom;

    forward_ = Util::normalize(lookTo - lookFrom);
    right_ = Util::normalize(cross(forward_, lookUp));
    up_ = Util::normalize(cross(right_, forward_));

    right_ = Util::scalarMult(tan(fov * M_PI / 360.0), right_);
    up_ = Util::scalarMult(tan(fov * M_PI / 360.0), up_);

    bottomLeft_ = lookFrom + forward_ - right_ - up_;
    topLeft_ = lookFrom + forward_ - right_ + up_;
    bottomRight_ = lookFrom + forward_ + right_ - up_;
    topRight_ = lookFrom + forward_ + right_ + up_;

    right_ = Util::scalarMult(2.0 / imageSize_.x, right_);
    up_ = Util::scalarMult(2.0 / imageSize_.y, up_);

}

void Scene::drawCameraGeometry(std::shared_ptr<BasicMesh> mesh,
                               std::vector<BasicMesh::Vertex>& vertices) const {
    auto indexBuffer = mesh->addIndexBuffer(DrawType::Lines, ConnectivityType::None);

    Util::drawLineSegment(camPos_, bottomLeft_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(camPos_, topLeft_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(camPos_, bottomRight_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(camPos_, topRight_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);

    Util::drawLineSegment(topLeft_, bottomLeft_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(bottomLeft_, bottomRight_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(bottomRight_, topRight_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(topRight_, topLeft_, vec4(1, 0.5, 0, 1), indexBuffer, vertices);
}

void Scene::drawAxesGeometry(std::shared_ptr<BasicMesh> mesh,
                             std::vector<BasicMesh::Vertex>& vertices) const {
    auto indexBuffer = mesh->addIndexBuffer(DrawType::Lines, ConnectivityType::None);

    Util::drawLineSegment(vec3(0, 0, 0), vec3(1, 0, 0), vec4(1, 0, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(vec3(0, 0, 0), vec3(0, 1, 0), vec4(0, 1, 0, 1), indexBuffer, vertices);
    Util::drawLineSegment(vec3(0, 0, 0), vec3(0, 0, 1), vec4(0, 0, 1, 1), indexBuffer, vertices);
}

void Scene::drawRenderablesGeometry(std::shared_ptr<BasicMesh> mesh,
                                    std::vector<BasicMesh::Vertex>& vertices) const {
    for (auto& R : renderables_) {
        R->drawGeometry(mesh, vertices);
    }
}

void Scene::render(LayerRAM* lr) const {
    size2_t P;

    const double maxLambda = 1000.0;
    size_t count_inter = 0;
    size_t count_light_on = 0;

    for (P.x = 0; P.x < size_t(imageSize_[0]); P.x++) {
        for (P.y = 0; P.y < size_t(imageSize_[1]); P.y++) {

            Ray ray = getRay(P);

            //find the closest renderable that this ray hits
            auto closestLambda = maxLambda;
            RayIntersection temp, closest;

            for (auto& R : renderables_) {
                if (R->closestIntersection(ray, closestLambda, temp)) {
                    if (temp.getLambda() < closestLambda) {
                        closestLambda = temp.getLambda();
                        closest = temp;
                    }
                }
            }

            if (!(closestLambda < maxLambda)) {
                lr->setFromDVec4(P, vec4(0, 0, 0, 1)); // set to background color
                continue;
            }

            count_inter++;

            const vec3 offset = Util::scalarMult(Util::epsilon, closest.getNormal());

            vec4 retColor(0, 0, 0, 1);

            for (auto& light : lights_) {

                //Shadow ray from light to hit point.
                const vec3 L = (closest.getPosition() + offset) - light->getPosition();
                const Ray shadowRay(light->getPosition(), L);

                //Shade only if light is visible from intersection point.

                bool inShadow = false;
                for (size_t r = 0; r < renderables_.size(); r++) {
                    if (renderables_[r]->anyIntersection(shadowRay, length(L))) {
                        inShadow = true;
                        break;
                    }
                }

                if (!inShadow) {
                    retColor += closest.getRenderable()->getMaterial()->shade(closest, *light);
                    count_light_on++;
                }
            }

            lr->setFromDVec4(P, retColor);

        }
    }

    LogInfo("Scene raytraced. " << count_inter << " intersections have been found, for which " << count_light_on << " shading computations have been made.");
}

Ray Scene::getRay(size2_t point) const {
    return Ray(camPos_,
               bottomLeft_ + Util::scalarMult(point.x, right_) + Util::scalarMult(point.y, up_) -
               camPos_);
}

void Scene::addLight(std::shared_ptr<Light> light) {
    lights_.push_back(light);
}

void Scene::addRenderable(std::shared_ptr<Renderable> renderable) {
    renderables_.push_back(renderable);
}

void Scene::clear() {
    renderables_.clear();
    lights_.clear();
}

} // namespace
