/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Friday, October 13, 2017 - 16:05:29
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwo.h>
#include <inviwo/core/processors/processor.h>
#include <inviwo/core/ports/meshport.h>
#include <inviwo/core/ports/imageport.h>
#include <inviwo/core/properties/cameraproperty.h>
#include <inviwo/core/properties/ordinalproperty.h>
#include <inviwo/core/properties/buttonproperty.h>
#include <inviwo/core/properties/optionproperty.h>
//#include <inviwo/core/properties/boolcompositeproperty.h>
//#include <inviwo/core/properties/boolproperty.h>
//#include <inviwo/core/properties/compositeproperty.h>
//#include <inviwo/core/properties/fileproperty.h>
//#include <inviwo/core/properties/minmaxproperty.h>
//#include <inviwo/core/properties/stringproperty.h>
//#include <inviwo/core/properties/transferfunctionproperty.h>

#include <labraytracer/light.h>
#include <labraytracer/renderable.h>
#include <labraytracer/scene.h>

namespace inviwo {

/** \docpage{org.inviwo.Raytracer, Raytracer}
    ![](org.inviwo.Raytracer.png?classIdentifier=org.inviwo.Raytracer)

    CPU Raytracer. The rendering has to be explicitly triggered with the Render button.
    
    ### Outports
      * __<imageOutport>__ Rendered image.
      * __<meshOutport>__ Geometry of the scene with wireframes for the camera and the 
            objects of the scene 
    
    ### Properties
      * __<Render Button>__ Button triggering raytracing.
      * __<Image Size>__ Size of the rendering image (one Ray per pixel)
*/


/** \class Raytracer
    \brief A CPU Raytracer
    
    A CPU Raytracer

    @author Himangshu Saikia
*/
class IVW_MODULE_LABRAYTRACER_API Raytracer : public Processor {
    //Friends
    //Types
public:

    //Construction / Deconstruction
public:
    Raytracer();
    virtual ~Raytracer() = default;

    //Methods
public:
    virtual const ProcessorInfo getProcessorInfo() const override;
    static const ProcessorInfo processorInfo_;

protected:
    ///Our main computation function
    virtual void process() override;
    void render();
    void task1();
    void task2();
    void bonusTask();
    //Ports
public:
    MeshOutport sceneGeometry_;
    ImageOutport image_;
    //Properties
public:
    CameraProperty camera_;
    IntVec2Property imageSize_;
    ButtonProperty render_;
    OptionPropertyInt task_;
    FloatVec3Property colorLight_;
    FloatVec3Property diffuseLight_;
    FloatVec3Property ambientLight_;
    FloatVec3Property specularLight_;
    //Attributes
private:
    PerspectiveCamera* cam_;
    Scene scene_;
};

} // namespace
