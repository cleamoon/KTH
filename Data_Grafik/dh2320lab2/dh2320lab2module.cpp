/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 01, 2018 - 20:34:51
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <dh2320lab2/dh2320lab2module.h>
#include <modules/dh2320lab2/chaikin.h>
#include <modules/dh2320lab2/colormixing.h>
#include <modules/dh2320lab2/colorinterpolation.h>

namespace inviwo
{

using namespace kth;

DH2320Lab2Module::DH2320Lab2Module(InviwoApplication* app) : InviwoModule(app, "DH2320Lab2")
{
    // Add a directory to the search path of the Shadermanager
    // ShaderManager::getPtr()->addShaderSearchPath(getPath(ModulePath::GLSL));

    // Register objects that can be shared with the rest of inviwo here:
    
    // Processors
    registerProcessor<Chaikin>();
    registerProcessor<ColorMixing>();
    registerProcessor<ColorInterpolation>();
    
    // Properties
    // registerProperty<DH2320Lab2Property>();
    
    // Readers and writes
    // registerDataReader(util::make_unique<DH2320Lab2Reader>());
    // registerDataWriter(util::make_unique<DH2320Lab2Writer>());
    
    // Data converters
    // registerRepresentationConverter(util::make_unique<DH2320Lab2Disk2RAMConverter>());

    // Ports
    // registerPort<DH2320Lab2Outport>();
    // registerPort<DH2320Lab2Inport>();

    // PropertyWidgets
    // registerPropertyWidget<DH2320Lab2PropertyWidget, DH2320Lab2Property>("Default");
    
    // Dialogs
    // registerDialog<DH2320Lab2Dialog>(DH2320Lab2Outport);
    
    // Other varius things
    // registerCapabilities(util::make_unique<DH2320Lab2Capabilities>());
    // registerSettings(util::make_unique<DH2320Lab2Settings>());
    // registerMetaData(util::make_unique<DH2320Lab2MetaData>());   
    // registerPortInspector("DH2320Lab2Outport", "path/workspace.inv");
    // registerProcessorWidget(std::string processorClassName, std::unique_ptr<ProcessorWidget> processorWidget);
    // registerDrawer(util::make_unique_ptr<DH2320Lab2Drawer>());  
}

} // namespace
