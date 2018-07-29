/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Friday, October 20, 2017 - 12:20:21
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/util.h>

namespace inviwo {

Util::Util() {
}

const double Util::epsilon = 0.0001;

vec3 Util::normalize(const vec3& v) {
    vec3 ret(0, 0, 0);
    auto len = sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    if (len > epsilon) {
        ret.x = v.x / len; // as right now base code does not check for zero length
        ret.y = v.y / len;
        ret.z = v.z / len;
    }
    return ret;
}

vec3 Util::scalarMult(const double& s, const vec3& v) {
    return vec3(s * v.x, s * v.y, s * v.z);
}

void Util::drawLineSegment(const vec3& v1, const vec3& v2, const vec4& color,
                           IndexBufferRAM* indexBuffer, std::vector<BasicMesh::Vertex>& vertices) {
    indexBuffer->add(static_cast<std::uint32_t>(vertices.size()));
    vertices.push_back({v1, vec3(0, 0, 0), v1, color});
    indexBuffer->add(static_cast<std::uint32_t>(vertices.size()));
    vertices.push_back({v2, vec3(0, 0, 0), v2, color});
}

} // namespace
