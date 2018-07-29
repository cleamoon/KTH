/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 24, 2017 - 14:35:30
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/plane.h>
#include <labraytracer/util.h>

namespace inviwo {

PlaneX::PlaneX(const vec3& normal, const vec3& point) {
    normal_ = normal;
    point_ = point;
}

bool PlaneX::closestIntersection(const Ray& ray, double maxLambda,
                                 RayIntersection& intersection) const {
    double d = dot(ray.getDirection(), normal_);

    if (fabs(d) < Util::epsilon) {
        return false;
    }

    double a = dot((point_ - ray.getOrigin()), normal_);

    double lambda = a / d;

    if (lambda < 0 || lambda + Util::epsilon > maxLambda) {
        return false;
    }

    const vec3 uvw(0, 0, 0);
    intersection = RayIntersection(ray, shared_from_this(), lambda, normal_, uvw);
    return true;
}

bool PlaneX::anyIntersection(const Ray& ray, double maxLambda) const {
    RayIntersection temp;
    return closestIntersection(ray, maxLambda, temp);
}

void PlaneX::drawGeometry(std::shared_ptr<BasicMesh> mesh,
                          std::vector<BasicMesh::Vertex>& vertices) const {
    int S = 2;

    vec3 tangent = vec3(1, 0, 0);

    vec3 bitangent = cross(normal_, tangent);

    const double bitanlen = length(bitangent);

    if (bitanlen > Util::epsilon) {
        bitangent = Util::scalarMult(1 / bitanlen, bitangent);
        tangent = Util::normalize(cross(bitangent, normal_));
    } else {
        tangent = vec3(0, 1, 0);
        bitangent = vec3(0, 0, 1);
    }

    auto indexBuffer = mesh->addIndexBuffer(DrawType::Lines, ConnectivityType::None);

    Util::drawLineSegment(point_ + Util::scalarMult(S, bitangent) + Util::scalarMult(-S, tangent),
                          point_ + Util::scalarMult(S, bitangent) + Util::scalarMult(S, tangent),
                          vec4(0.2, 0.2, 0.2, 1), indexBuffer, vertices);

    Util::drawLineSegment(point_ + Util::scalarMult(-S, bitangent) + Util::scalarMult(-S, tangent),
                          point_ + Util::scalarMult(-S, bitangent) + Util::scalarMult(S, tangent),
                          vec4(0.2, 0.2, 0.2, 1), indexBuffer, vertices);

    Util::drawLineSegment(point_ + Util::scalarMult(-S, bitangent) + Util::scalarMult(S, tangent),
                          point_ + Util::scalarMult(S, bitangent) + Util::scalarMult(S, tangent),
                          vec4(0.2, 0.2, 0.2, 1), indexBuffer, vertices);

    Util::drawLineSegment(point_ + Util::scalarMult(-S, bitangent) + Util::scalarMult(-S, tangent),
                          point_ + Util::scalarMult(S, bitangent) + Util::scalarMult(-S, tangent),
                          vec4(0.2, 0.2, 0.2, 1), indexBuffer, vertices);

}

} // namespace
