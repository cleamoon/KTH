#include "Vec3.hpp"
#include <iostream>

Vec3::Vec3(float x, float y, float z)
{
	m[0] = x;
	m[1] = y;
	m[2] = z;
}

void Vec3::print()
{
	std::cout << "x: " << x() << ", y: " << y() << ", z: " << z() << std::endl;
}