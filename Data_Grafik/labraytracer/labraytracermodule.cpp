/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Friday, October 13, 2017 - 14:02:53
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/labraytracermodule.h>
#include <labraytracer/raytracer.h>

namespace inviwo {

LabRaytracerModule::LabRaytracerModule(InviwoApplication* app) : InviwoModule(app, "LabRaytracer") {
    registerProcessor<Raytracer>();
}

} // namespace
