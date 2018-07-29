/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Wednesday, February 07, 2018 - 22:56:32
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
//#include <inviwo/core/ports/meshport.h>
//#include <inviwo/core/properties/boolcompositeproperty.h>
//#include <inviwo/core/properties/boolproperty.h>
//#include <inviwo/core/properties/buttonproperty.h>
//#include <inviwo/core/properties/compositeproperty.h>
//#include <inviwo/core/properties/fileproperty.h>
//#include <inviwo/core/properties/minmaxproperty.h>
#include <inviwo/core/properties/optionproperty.h>
#include <inviwo/core/properties/ordinalproperty.h>
//#include <inviwo/core/properties/stringproperty.h>
//#include <inviwo/core/properties/transferfunctionproperty.h>

#include <modules/dh2320lab2/colormixingbase.h>

namespace inviwo
{
namespace kth
{

/** \docpage{org.inviwo.ColorMixing, Color Mixing}
    ![](org.inviwo.ColorMixing.png?classIdentifier=org.inviwo.ColorMixing)

    Explanation of how to use the processor.
    
    ### Inports
      * __<Inport1>__ <description>.
    
    ### Outports
      * __<Outport1>__ <description>.
    
    ### Properties
      * __<Prop1>__ <description>.
      * __<Prop2>__ <description>
*/


/** \class ColorMixing
    \brief VERY_BRIEFLY_DESCRIBE_THE_PROCESSOR
    
    DESCRIBE_THE_PROCESSOR_FROM_A_DEVELOPER_PERSPECTIVE

    @author Tino Weinkauf
*/
class IVW_MODULE_DH2320LAB2_API ColorMixing : public ColorMixingBase
{ 
//Friends
//Types
public:

//Construction / Deconstruction
public:
    ColorMixing();
    virtual ~ColorMixing() = default;
     
//Methods
public:
    virtual const ProcessorInfo getProcessorInfo() const override;
    static const ProcessorInfo processorInfo_;

protected:
    ///Our main computation function
    virtual void Mix(const size2_t& Resolution, glm::u8vec3* pRaw) override;

    ///Mixes the two given colors using additive color mixing
    vec3 AdditiveColorMixing(const vec3& Color1, const vec3& Color2);

    ///Mixes the two given colors using subtractive color mixing
    vec3 SubtractiveColorMixing(const vec3& Color1, const vec3& Color2);

//Ports
public:

//Properties
public:
    OptionPropertyInt propMixingMode; //!< additive or subtractive

    FloatVec4Property propColorA;
    FloatVec4Property propColorB;
    FloatVec4Property propColorC;

//Attributes
private:

};

} // namespace
} // namespace
