/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Thursday, October 12, 2017 - 11:10:04
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <dh2320lab1/dh2320lab1module.h>
#include <dh2320lab1/cubeanimator.h>

namespace inviwo
{

DH2320Lab1Module::DH2320Lab1Module(InviwoApplication* app) : InviwoModule(app, "DH2320Lab1")
    
{
	registerProcessor<CubeAnimator>();
}

} // namespace
