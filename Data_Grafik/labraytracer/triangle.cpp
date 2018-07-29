/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Tuesday, October 17, 2017 - 10:24:30
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/triangle.h>
#include <labraytracer/util.h>
#include <memory>

namespace inviwo {

Triangle::Triangle() {
}

Triangle::Triangle(const vec3& v0, const vec3& v1, const vec3& v2, const vec3& uvw0,
                   const vec3& uvw1, const vec3& uvw2) {
    mVertices[0] = v0;
    mVertices[1] = v1;
    mVertices[2] = v2;
    mUVW[0] = uvw0;
    mUVW[1] = uvw1;
    mUVW[2] = uvw2;
}

vec3 cross_pro(vec3 t1, vec3 t2) {
	vec3 n;
    n[0] = t1[1]*t2[2] - t1[2]*t2[1];
    n[1] = t1[2]*t2[0] - t1[0]*t2[2];
    n[2] = t1[0]*t2[1] - t1[1]*t2[0];
    return n;
}

double dot_pro(vec3 t1, vec3 t2) {
	return t1[0]*t2[0] + t1[1]*t2[1] + t1[2]*t2[2];
}

bool Triangle::closestIntersection(const Ray& ray, double maxLambda,
                                   RayIntersection& intersection) const {
    //Programming TASK 1: Implement this method
    //Your code should compute the intersection between a ray and a triangle.
    //
    //If you detect an intersection, the return type should look similar to this:
    //if(rayIntersectsTriangle)
    //{
    //  intersection = RayIntersection(ray,shared_from_this(),lambda,ray.normal,uvw);
    //  return true;
    //} 
    //
    // Hints :
    // Ray origin p_r : ray.getOrigin()
    // Ray direction t_r : ray.getDirection()
    // Compute the intersection point using ray.pointOnRay(lambda) 
    vec3 v0 = mVertices[0];
    vec3 v1 = mVertices[1];
    vec3 v2 = mVertices[2];
    vec3 t1 = v1 - v0;
    vec3 t2 = v2 - v0;
    vec3 n = Util::normalize(cross_pro(t1, t2));
	vec3 tr = ray.getDirection();
	vec3 pr = ray.getOrigin();
	if (fabs(dot(tr, n)) > Util::epsilon) {
		double lambda = dot(v0-pr, n)/dot(tr, n);
		if (lambda < 0.0 || lambda + Util::epsilon > maxLambda) return false;
		vec3 q = ray.pointOnRay(lambda) - v0;
		double lambda1 = (dot_pro(t1, t2)*dot_pro(q, t1) - dot_pro(t1,t1)*dot_pro(q,t2))/(dot_pro(t1,t2)*dot(t1,t2) - dot_pro(t1,t1)*dot_pro(t2,t2));
		double lambda2 =-(dot_pro(t2, t2)*dot_pro(q, t1) - dot_pro(t1,t2)*dot_pro(q,t2))/(dot_pro(t1,t2)*dot(t1,t2) - dot_pro(t1,t1)*dot_pro(t2,t2));
		if(lambda1 >= 0.0 && lambda2 >= 0.0 && (lambda1 + lambda2 <= 1.0)) {
			vec3 uvw;
			uvw[0] = uvw[1] = uvw[2] = 0;
			intersection = RayIntersection(ray, shared_from_this(), lambda, n, uvw);
			return true;
		}
	}
	return false;
}

bool Triangle::anyIntersection(const Ray& ray, double maxLambda) const {
    RayIntersection temp;
    return closestIntersection(ray, maxLambda, temp);
}

void Triangle::drawGeometry(std::shared_ptr<BasicMesh> mesh,
                            std::vector<BasicMesh::Vertex>& vertices) const {
    auto indexBuffer = mesh->addIndexBuffer(DrawType::Lines, ConnectivityType::None);

    Util::drawLineSegment(mVertices[0], mVertices[1], vec4(0.2, 0.2, 0.2, 1), indexBuffer,
                          vertices);
    Util::drawLineSegment(mVertices[1], mVertices[2], vec4(0.2, 0.2, 0.2, 1), indexBuffer,
                          vertices);
    Util::drawLineSegment(mVertices[2], mVertices[0], vec4(0.2, 0.2, 0.2, 1), indexBuffer,
                          vertices);
}

} // namespace
