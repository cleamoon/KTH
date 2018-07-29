/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 01, 2018 - 20:34:51
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#pragma once

#include <modules/dh2320lab2/dh2320lab2moduledefine.h>
#include <inviwo/core/common/inviwomodule.h>

namespace inviwo
{

class IVW_MODULE_DH2320LAB2_API DH2320Lab2Module : public InviwoModule
{
public:
    DH2320Lab2Module(InviwoApplication* app);
    virtual ~DH2320Lab2Module() = default;
};

} // namespace
