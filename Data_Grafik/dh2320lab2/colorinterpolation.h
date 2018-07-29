/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 08, 2018 - 08:57:14
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
//#include <inviwo/core/ports/volumeport.h>
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

#include <modules/dh2320lab2/colormixingbase.h>

namespace inviwo
{
namespace kth
{

/** \docpage{org.inviwo.ColorInterpolation, Color Interpolation}
    ![](org.inviwo.ColorInterpolation.png?classIdentifier=org.inviwo.ColorInterpolation)

    Explanation of how to use the processor.
    
    ### Inports
      * __<Inport1>__ <description>.
    
    ### Outports
      * __<Outport1>__ <description>.
    
    ### Properties
      * __<Prop1>__ <description>.
      * __<Prop2>__ <description>
*/


/** \class ColorInterpolation
    \brief VERY_BRIEFLY_DESCRIBE_THE_PROCESSOR
    
    DESCRIBE_THE_PROCESSOR_FROM_A_DEVELOPER_PERSPECTIVE

    @author Tino Weinkauf
*/
class IVW_MODULE_DH2320LAB2_API ColorInterpolation : public ColorMixingBase
{ 
//Friends
//Types
public:

//Construction / Deconstruction
public:
    ColorInterpolation();
    virtual ~ColorInterpolation() = default;
     
//Methods
public:
    virtual const ProcessorInfo getProcessorInfo() const override;
    static const ProcessorInfo processorInfo_;

protected:
    ///Our main computation function
    virtual void Mix(const size2_t& Resolution, glm::u8vec3* pRaw) override;

//Ports
public:

//Properties
public:
    ///The two colors to be interpolated.
    FloatVec4Property propColorA;
    FloatVec4Property propColorB;

//Attributes
private:
    ///Spaces in the image to be replaced by our results
    std::map<unsigned char, std::pair<size2_t, size2_t>> ColorTemplateBBoxes;
};

} // namespace
} // namespace
