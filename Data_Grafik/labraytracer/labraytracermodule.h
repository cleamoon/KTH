/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Friday, October 13, 2017 - 14:02:53
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <labraytracer/labraytracermoduledefine.h>
#include <inviwo/core/common/inviwomodule.h>

namespace inviwo
{

class IVW_MODULE_LABRAYTRACER_API LabRaytracerModule : public InviwoModule
{
public:
    LabRaytracerModule(InviwoApplication* app);
    virtual ~LabRaytracerModule() = default;
};

} // namespace
