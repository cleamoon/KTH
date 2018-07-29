#include "IndexedTriangleIO.hpp"

#include <fstream>
#include <string>
#include <cstring>

#ifdef _MSC_VER
#pragma warning(disable: 4996) //Visual Studio compiler complains about unsafe C function
#endif

namespace ogl
{

void IndexedTriangleIO::clear()
{
  //Clear and shrink data containers
  std::vector<Vec3f>().swap(mVertexPosition);
  std::vector<Vec3f>().swap(mVertexTextureCoordinate);
  std::vector<Vec3f>().swap(mVertexNormal);
  std::vector<unsigned int>().swap(mIndices);
  this->clearCaches();
}


bool IndexedTriangleIO::loadFromOBJ(const std::string &filePath)
{
  std::fstream in(filePath, std::ios::binary | std::ios::in);

  //could not open file, reject
  if(!in.is_open())
  {
    std::cerr<<"Error: Could not open file "<<filePath<<std::endl;
    return false;
  }

  char line[1024];
  Vec3f v,t,n;
  Vec3i idx_v,idx_t,idx_n;

  int lineIndex(0);

  UnsupportedFeatures features;

  //read lines in file
  while (!in.eof())
  {
    //line could not be read, this may have multiple reasons
    if (!in.getline(line,1024))
    {
      if (in.eof())
        break;
      std::cerr<<"Error: Could not read file"<<std::endl;
      this->clear();
      return false;
    }
    ++lineIndex;

    //comment
    if (line[0]=='#')  continue;

    //empty line
    if (line[0]=='\n' || line[0]=='\r') continue;

    //vertex position
    if (line[0]=='v' && line[1]==' ')
    {
      if (sscanf(line+2,"%f %f %f\n",&v[0],&v[1],&v[2])!=3)
      {
        std::cerr<<"Error: Could not read 'v' line "<<lineIndex<<std::endl;
        this->clear();
        return false;
      }
      mVertexPositionCache.push_back(v);
    }
    //vertex texture coordinate
    else if (line[0]=='v' && line[1]=='t')
    {
      if (sscanf(line+3,"%f %f %f\n",&t[0],&t[1],&t[2])!=3)
      {
        std::cerr<<"Error: Could not read 'vt' line "<<lineIndex<<std::endl;
        this->clear();
        return false;
      }
      mVertexTextureCoordinateCache.push_back(t);
    }
    //vertex normal
    else if (line[0]=='v' && line[1]=='n')
    {
      if (sscanf(line+3,"%f %f %f\n",&n[0],&n[1],&n[2])!=3)
      {
        std::cerr<<"Error: Could not read 'vn' line "<<lineIndex<<std::endl;
        this->clear();
        return false;
      }
      mVertexNormalCache.push_back(n);
    }

    //(triangle) face
    else if (line[0]=='f' && line[1]==' ')
    {
      // position index
      if (sscanf(line+2,"%d %d %d\n",&idx_v[0],&idx_v[1],&idx_v[2])==3)
      {
        this->insertFlattenedTriangleV(idx_v);
      }
      // position and texture coordinate index
      else if (sscanf(line+2,"%d/%d %d/%d %d/%d\n",&idx_v[0],&idx_t[0],
        &idx_v[1],&idx_t[1],
        &idx_v[2],&idx_t[2])==6)
      {
        this->insertFlattenedTriangleVT(idx_v,idx_t);
      }
      // position and normal index
      else if (sscanf(line+2,"%d//%d %d//%d %d//%d\n",&idx_v[0],&idx_n[0],
        &idx_v[1],&idx_n[1],
        &idx_v[2],&idx_n[2])==6)
      {
        this->insertFlattenedTriangleVN(idx_v,idx_n);
      }
      // position, texture coordinate and normal index
      else if (sscanf(line+2,"%d/%d/%d %d/%d/%d %d/%d/%d\n",&idx_v[0],&idx_t[0],&idx_n[0],
        &idx_v[1],&idx_t[1],&idx_n[1],
        &idx_v[2],&idx_t[2],&idx_n[2])==9)
      {
        this->insertFlattenedTriangleVTN(idx_v,idx_t,idx_n);
      }
      //quads and other n-gons are not supported
      else
      {
        std::cerr<<"Error: face format invalid in line "<<lineIndex<<std::endl;
        this->clear();
        return false;
      }
    }
    else if(line[0]=='s') //smoothing group
      features.hasSmoothingGroup=true;
    else if(line[0]=='g')
      features.hasGroup=true;
    else if(line[0]=='l')
      features.hasLine=true;
    else if(strstr(line,"usemtl")!=0 || strstr(line,"mtllib")!=0)
      features.hasMaterial=true;
    else if (line[0]!=0)
    {
      std::cerr<<"Warning: unknown data in line "<<lineIndex<<std::endl;
    }
  }

  if(features.hasGroup || features.hasLine || features.hasMaterial || features.hasSmoothingGroup)
    std::cerr<<"Warning: obj file contains unsupported data."<<std::endl;

  this->clearCaches();
  return true;
}

bool IndexedTriangleIO::saveToOBJ(const std::string &filePath,bool textureCoordinates,bool normals) const
{
  std::fstream out(filePath, std::ios::binary | std::ios::out);

  if (mVertexPosition.empty() || mIndices.empty())
  {
    std::cerr<<"Error: Mesh does not contain vertex positions"<<std::endl;
    return false;
  }
  if (textureCoordinates && mVertexTextureCoordinate.empty())
  {
    std::cerr<<"Warning: Mesh does not contain vertex texture coordinates"<<std::endl;
    textureCoordinates=false;
  }
  if (textureCoordinates && mVertexNormal.empty())
  {
    std::cerr<<"Warning: Mesh does not contain vertex normals"<<std::endl;
    normals=false;
  }

  if (!out.is_open())
  {
    std::cerr<<"Error: Could not write file "<<filePath<<std::endl;
    return false;
  }

  out<<"# IndexedTriangleIO exporter"<<std::endl;
  out<<"# exporting:"<<std::endl;
  out<<"# "<<mVertexPosition.size()<<" vertex positions"<<std::endl;
  if (textureCoordinates)
    out<<"# "<<mVertexTextureCoordinate.size()<<" texture coordinates"<<std::endl;
  if (normals)
    out<<"# "<<mVertexNormal.size()<<" normals"<<std::endl;
  out<<"# "<<mIndices.size()/3<<" triangles"<<std::endl;
  out<<std::endl;

  Vec3f v;
  Vec3i idx_v,idx_t,idx_n;

  //vertex positions
  for (size_t i=0;i<mVertexPosition.size();++i)
  {
    v = mVertexPosition[i];
    out<<"v "<<v[0]<<" "<<v[1]<<" "<<v[2]<<std::endl;
  }
  out<<std::endl;
  //texture Coordinates
  if (textureCoordinates)
  {
    for (size_t i=0;i<mVertexTextureCoordinate.size();++i)
    {
      v = mVertexTextureCoordinate[i];
      out<<"vt "<<v[0]<<" "<<v[1]<<" "<<v[2]<<std::endl;
    }
  }
  out<<std::endl;
  //normals
  if (normals)
  {
    for (size_t i=0;i<mVertexNormal.size();++i)
    {
      v = mVertexNormal[i];
      out<<"vn "<<v[0]<<" "<<v[1]<<" "<<v[2]<<std::endl;
    }
  }
  out<<std::endl;

  //triangles
  if (mIndices.size() % 3 !=0)
  {
    std::cerr<<"Error: Number of position indices not divisible by 3"<<std::endl;
    return false;
  }
  if (normals && textureCoordinates)
    for (size_t i=0;i<mIndices.size();i+=3)
      out<<"f "<<mIndices[i+0]+1<<"/"<<mIndices[i+0]+1<<"/"<<mIndices[i+0]+1<<" "<<
      mIndices[i+1]+1<<"/"<<mIndices[i+1]+1<<"/"<<mIndices[i+1]+1<<" "<<
      mIndices[i+2]+1<<"/"<<mIndices[i+2]+1<<"/"<<mIndices[i+2]+1<<std::endl;
  else if (textureCoordinates)
    for (size_t i=0;i<mIndices.size();i+=3)
      out<<"f "<<mIndices[i+0]+1<<"/"<<mIndices[i+0]+1<<" "<<
      mIndices[i+1]+1<<"/"<<mIndices[i+1]+1<<" "<<
      mIndices[i+2]+1<<"/"<<mIndices[i+2]+1<<std::endl;
  else if (normals)
    for (size_t i=0;i<mIndices.size();i+=3)
      out<<"f "<<mIndices[i+0]+1<<"//"<<mIndices[i+0]+1<<" "<<
      mIndices[i+1]+1<<"//"<<mIndices[i+1]+1<<" "<<
      mIndices[i+2]+1<<"//"<<mIndices[i+2]+1<<std::endl;
  else
    for (size_t i=0;i<mIndices.size();i+=3)
      out<<"f "<<mIndices[i+0]+1<<" "<<mIndices[i+1]+1<<" "<<mIndices[i+2]+1<<std::endl;

  return true;
}

void IndexedTriangleIO::insertFlattenedTriangleV(const Vec3i &v)
{
  for (int i = 0; i < 3;++i)
    mIndices.push_back(insertFlattenedVertexVTN(v[i],-1,-1));
}
void IndexedTriangleIO::insertFlattenedTriangleVT(const Vec3i &v, const Vec3i &t)
{
  for (int i = 0; i < 3;++i)
    mIndices.push_back(insertFlattenedVertexVTN(v[i],t[i],-1));
}
void IndexedTriangleIO::insertFlattenedTriangleVN(const Vec3i &v, const Vec3i &n)
{
  for (int i = 0; i < 3;++i)
    mIndices.push_back(insertFlattenedVertexVTN(v[i],-1,n[i]));
}
void IndexedTriangleIO::insertFlattenedTriangleVTN(const Vec3i &v, const Vec3i &t, const Vec3i &n)
{
  for (int i = 0; i < 3;++i)
    mIndices.push_back(insertFlattenedVertexVTN(v[i],t[i],n[i]));
}

int IndexedTriangleIO::insertFlattenedVertexVTN(const int v, const int t, const  int n)
{
  Vec3i idx(v,t,n);
  map_t::iterator it = mIndicesCache.find(idx);

  //vertex does not exist
  if(it==mIndicesCache.end())
  {
    it = (mIndicesCache.insert(std::make_pair(idx,mVertexPosition.size()))).first;
    mVertexPosition.push_back(mVertexPositionCache[v-1]);

    // copy / duplicate texcoords and normals if appropriate
    if(t >= 0)
      mVertexTextureCoordinate.push_back(mVertexTextureCoordinateCache[t-1]);
    if(n >= 0)
      mVertexNormal.push_back(mVertexNormalCache[n-1]);
  }
  return (int)it->second;
}
void IndexedTriangleIO::clearCaches()
{
  //clear() doesn't free the memory for vectors
  mVertexNormalCache.clear();
  mVertexNormalCache.shrink_to_fit();

  mVertexTextureCoordinateCache.clear();
  mVertexTextureCoordinateCache.shrink_to_fit();

  mVertexNormalCache.clear();
  mVertexNormalCache.shrink_to_fit();

  mIndicesCache.clear(); // clear() does the job for maps
}

#ifdef _MSC_VER
#pragma warning(default: 4996)
#endif

} //namespace rt
