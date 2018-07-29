#ifndef _INDEXEDTRIANGLEIO_INCLUDE_ONCE
#define _INDEXEDTRIANGLEIO_INCLUDE_ONCE
#include "openglConfig.hpp"

#include "Math.hpp"
#include <unordered_map>
#include <vector>
#include <iostream>

namespace ogl
{

// This class loads an indexes triangle mesh from an Wavefront OBJ file.
// Supported are triangle faces with absolute (positive) indices,
// and vertex positions, vertex normals, and vertex texture coordinates.
// Triangle vertices with differing indices for v, vt, an vn are duplicated.
class IndexedTriangleIO
{
public:
  OPENGL_EXPORTS void clear();
  OPENGL_EXPORTS bool loadFromOBJ(const std::string &filePath);
  OPENGL_EXPORTS bool saveToOBJ(const std::string &filePath, bool textureCoordinates=true, bool normals=true) const;

  OPENGL_EXPORTS const std::vector<Vec3f>& vertexPositions()          const {return mVertexPosition;}
  OPENGL_EXPORTS const std::vector<Vec3f>& vertexTextureCoordinates() const {return mVertexTextureCoordinate;}
  OPENGL_EXPORTS const std::vector<Vec3f>& vertexNormals()            const {return mVertexNormal;}
  OPENGL_EXPORTS const std::vector<unsigned int>&  triangleIndices()          const {return mIndices;}

  OPENGL_EXPORTS void setVertexPositions(const std::vector<Vec3f>& v) {mVertexPosition=std::vector<Vec3f>(v);}
  OPENGL_EXPORTS void setVertexTextureCoordinates(const std::vector<Vec3f>& v) {mVertexTextureCoordinate=std::vector<Vec3f>(v);}
  OPENGL_EXPORTS void setVertexNormals(const std::vector<Vec3f>& v) {mVertexNormal=std::vector<Vec3f>(v);}
  OPENGL_EXPORTS void setTriangleIndices(const std::vector<unsigned int>& v) {mIndices=std::vector<unsigned int>(v);}

private:

  // Container for printing warnings on Wavefront OBJ format specs
  // that are unsupported by this loader.
  struct UnsupportedFeatures
  {
    UnsupportedFeatures() : hasLine(false),
      hasGroup(false),
      hasSmoothingGroup(false),
      hasMaterial(false)
    { }

    bool hasLine;
    bool hasGroup;
    bool hasSmoothingGroup;
    bool hasMaterial;
  };

  //Vertex flattening (or duplication) requires a strict weak ordering
  struct Vec3iEqual {
    bool operator()(const Vec3i& lhs, const Vec3i& rhs) const
    {
      for (int i=0;i<3;++i)
      {
        if (lhs[i] != rhs[i]) return false;
      }
      return true;
    }
  };
  struct Vec3iHash {
    size_t operator()(const Vec3i& x) const
    {
      return std::hash<int>()(x[0])^std::hash<int>()(x[1])^std::hash<int>()(x[2]);
    }
  };

  typedef std::unordered_map<Vec3i,size_t,Vec3iHash,Vec3iEqual> map_t;

  void insertFlattenedTriangleV  (const Vec3i &v);
  void insertFlattenedTriangleVT (const Vec3i &v,const Vec3i &t);
  void insertFlattenedTriangleVN (const Vec3i &v,const Vec3i &n);
  void insertFlattenedTriangleVTN(const Vec3i &v,const Vec3i &t,const Vec3i &n);
  int insertFlattenedVertexVTN(const int v, const int t, const  int n);
  void clearCaches();

  std::vector<Vec3f>                   mVertexPosition;
  std::vector<Vec3f>                   mVertexTextureCoordinate;
  std::vector<Vec3f>                   mVertexNormal;
  std::vector<unsigned int>           mIndices;

  std::vector<Vec3f>                   mVertexPositionCache;
  std::vector<Vec3f>                   mVertexTextureCoordinateCache;
  std::vector<Vec3f>                   mVertexNormalCache;
  map_t                               mIndicesCache;
};

} //namespace ogl

#endif //_INDEXEDTRIANGLEIO_INCLUDE_ONCE
