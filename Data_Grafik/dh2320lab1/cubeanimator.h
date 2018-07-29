/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Thursday, October 12, 2017 - 11:11:30
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <dh2320lab1/dh2320lab1moduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <inviwo/core/processors/processor.h>
#include <inviwo/core/ports/meshport.h>
#include <inviwo/core/properties/ordinalproperty.h>

namespace inviwo
{

/** \docpage{org.inviwo.CubeAnimator, Cube Animator}
    ![](org.inviwo.CubeAnimator.png?classIdentifier=org.inviwo.CubeAnimator)

    Processor that enables a special kind of transformation of a mesh (in our task: a die): 
    A rotation with a swirley motion on top of the circle, when the properties of the
    processor are animated with a Property Animator.
    
    ### Inports
      * __meshIn__ Input mesh.
    
    ### Outports
      * __<Outport1>__ Output mesh.
    
    ### Properties
      * __radius__ Radius of the circle on which the mesh travels.
      * .... more properties that you will add 
*/


/** \class CubeAnimator
    \brief Special transformation of a mesh

    @author Himangshu Saikia
*/
class IVW_MODULE_DH2320LAB1_API CubeAnimator : public Processor
{ 
//Friends
//Types
public:

//Construction / Deconstruction
public:
    CubeAnimator();
    virtual ~CubeAnimator() = default;

//Methods
public:
    virtual const ProcessorInfo getProcessorInfo() const override;
    static const ProcessorInfo processorInfo_;

protected:
    ///Our main computation function
    virtual void process() override;

//Ports
public:
    MeshInport meshIn_;
    MeshOutport meshOut_;

//Properties
public:
    FloatProperty radius_;


//Attributes
private:

};

} // namespace
