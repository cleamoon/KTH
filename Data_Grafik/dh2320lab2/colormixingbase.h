/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 08, 2018 - 08:00:14
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <modules/dh2320lab2/dh2320lab2moduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <inviwo/core/processors/processor.h>
#include <inviwo/core/ports/imageport.h>
#include <inviwo/core/datastructures/image/layerram.h>
//#include <inviwo/core/ports/meshport.h>
//#include <inviwo/core/properties/boolcompositeproperty.h>
//#include <inviwo/core/properties/boolproperty.h>
//#include <inviwo/core/properties/buttonproperty.h>
//#include <inviwo/core/properties/compositeproperty.h>
//#include <inviwo/core/properties/fileproperty.h>
//#include <inviwo/core/properties/minmaxproperty.h>
//#include <inviwo/core/properties/optionproperty.h>
#include <inviwo/core/properties/ordinalproperty.h>
//#include <inviwo/core/properties/stringproperty.h>
//#include <inviwo/core/properties/transferfunctionproperty.h>

namespace inviwo
{
namespace kth
{

/** \class ColorMixing Base Class
    \brief Base class for color mixing and interpolation.
    
    Technically, changes colors in input images.

    @author Tino Weinkauf
*/
class IVW_MODULE_DH2320LAB2_API ColorMixingBase : public Processor
{ 
//Friends
//Types
public:

//Construction / Deconstruction
public:
    ColorMixingBase();
    virtual ~ColorMixingBase() = default;
     
//Methods
public:
    //virtual const ProcessorInfo getProcessorInfo() const override;
    //static const ProcessorInfo processorInfo_;

    ///Converts a float-based color in the range [0, 1] to a uchar based color in the range [0, 255].
    static glm::u8vec3 ToUChar(const vec3& Color)
    {
        return glm::u8vec3( std::max(std::min(255.0 * Color.r, 255.0), 0.0),
                            std::max(std::min(255.0 * Color.g, 255.0), 0.0),
                            std::max(std::min(255.0 * Color.b, 255.0), 0.0)
                          );
    }

protected:
    ///Our main computation function
    virtual void process() override;

    ///Will be called by process() to replace colors in the RAW vector
    virtual void Mix(const size2_t& Resolution, glm::u8vec3* pRaw) = 0;

//Ports
public:
    ImageInport portInImage; //!< input image
    ImageOutport portOutImage; //!< output image

//Properties
public:

//Attributes
private:

};

} // namespace
} // namespace
