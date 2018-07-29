#include "Image.hpp"
#include "Math.hpp"

#include <fstream>
#include <iostream>
#include <string>
#include <algorithm>

namespace rt {

Image::Image() : mWidth(0), mHeight(0)
{
}

Image::Image(size_t width, size_t height)
{
  assert(width>0 && height>0);
  this->init(width,height);
}

void Image::init(size_t width, size_t height)
{
  mWidth=width;
  mHeight=height;
  mData.clear();
  mData.resize(width*height);

  //size_t numBytes=width*height*sizeof(Vec4d);
  //double megaBytes = (numBytes/(1024.0*1024.0));
  //std::cerr<<"Image MB: "<<megaBytes<<std::endl;
}

bool Image::saveToTGA(std::string fileName) const
{
  //add .tga file extension if not yet present
  std::string suffix(".tga"), outName(fileName), outNameLower(fileName);

  std::transform(outNameLower.begin(),
                 outNameLower.end(),
                 outNameLower.begin(),
                 ::tolower);

  if (!std::equal(suffix.rbegin(),
                  suffix.rend(),
                  outNameLower.rbegin()))
    outName+=suffix;

  std::ofstream f(outName, std::ios::binary | std::ios::out);

  if (!f.is_open())
  {
    std::cerr<<"Image::saveToBitmap: could not open file." <<
               outName <<std::endl;
    return false;
  }

  if (!mData.size())
  {
    std::cerr<<"Image::saveToBitmap: image data uninitialized." << std::endl;
    return false;
  }

  if (mWidth<1 || mHeight<1)
  {
    std::cerr << "Image::saveToBitmap: image dimensions too small to write ("
              << mWidth << "," << mHeight << ")" << std::endl;
    return false;
  }

  //Write the header
  f.put(0);
  f.put(0);
  f.put(2);                       /* uncompressed RGB */
  f.put(0); 	f.put(0);
  f.put(0); 	f.put(0);
  f.put(0);
  f.put(0); 	f.put(0);           /* X origin */
  f.put(0); 	f.put(0);           /* y origin */
  f.put((mWidth & 0x00FF));
  f.put((unsigned char)((mWidth & 0xFF00) / 256));
  f.put((unsigned char)(mHeight & 0x00FF));
  f.put((unsigned char)((mHeight & 0xFF00) / 256));
  f.put(32);                      /* 32 bit RGBA bitmap */
  f.put(0);

  //Write the pixel data in BGRA
  for (size_t i=0; i<mHeight*mWidth; i++)
  {
    f.put((unsigned char)(Math::clamp(mData[i][2])*255));
    f.put((unsigned char)(Math::clamp(mData[i][1])*255));
    f.put((unsigned char)(Math::clamp(mData[i][0])*255));
    f.put((unsigned char)(Math::clamp(mData[i][3])*255));
  }

  f.close();

  return true;
}

} //namespace rt
