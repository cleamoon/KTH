/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 01, 2018 - 20:35:30
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
#include <inviwo/core/ports/meshport.h>
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

namespace inviwo
{
namespace kth
{

/** \docpage{org.inviwo.Chaikin, Chaikin}
    ![](org.inviwo.Chaikin.png?classIdentifier=org.inviwo.Chaikin)

    Explanation of how to use the processor.
    
    ### Inports
      * __<Inport1>__ <description>.
    
    ### Outports
      * __<Outport1>__ <description>.
    
    ### Properties
      * __<Prop1>__ <description>.
      * __<Prop2>__ <description>
*/


/** \class Chaikin
    \brief VERY_BRIEFLY_DESCRIBE_THE_PROCESSOR
    
    DESCRIBE_THE_PROCESSOR_FROM_A_DEVELOPER_PERSPECTIVE

    @author Tino Weinkauf
*/
class IVW_MODULE_DH2320LAB2_API Chaikin : public Processor
{ 
//Friends
//Types
public:

//Construction / Deconstruction
public:
    Chaikin();
    virtual ~Chaikin() = default;
     
//Methods
public:
    virtual const ProcessorInfo getProcessorInfo() const override;
    static const ProcessorInfo processorInfo_;

protected:
    ///Our main computation function
    virtual void process() override;

    ///Applies Chaikin's Corner Cutting algorithm
    void CornerCutting(const std::vector<vec3>& ControlPolygon, const size_t MinNumDesiredPoints, std::vector<vec3>& Curve);

//Ports
public:
    ///Line input
    MeshMultiInport portInLines;

    ///Line output
    MeshOutport portOutLines;

//Properties
public:
    IntProperty propMinNumDesiredPoints;

//Attributes
private:

};

} // namespace
} // namespace
