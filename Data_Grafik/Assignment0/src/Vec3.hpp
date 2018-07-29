#ifndef __VEC3_bla__
#define __VEC3_bla__


class Vec3
{
public:

	Vec3(float x, float y, float z);

	float x() const { return m[0]; }
	float y() const { return m[1]; }
	float z() const { return m[2]; }

	void print();

	Vec3 operator +(const Vec3& other) const
	{
		return Vec3(x() + other.x(), y() + other.y(), z() + other.z());
	}

private:
	float m[3];
};


#endif