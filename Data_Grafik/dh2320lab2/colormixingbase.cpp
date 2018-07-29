/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 08, 2018 - 08:00:14
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <modules/dh2320lab2/colormixing.h>

namespace inviwo
{
namespace kth
{
    
ColorMixingBase::ColorMixingBase()
    :portInImage("InImage", true)
    ,portOutImage("OutImage", false)
{
    addPort(portInImage);
    addPort(portOutImage);
}
    

void ColorMixingBase::process()
{
    //Get input
    auto InImage = portInImage.getData();
    const size2_t Resolution = InImage->getDimensions();
    auto ColorLayer = InImage->getColorLayer();
    if (!ColorLayer || ColorLayer->getDataFormat() != DataVec3UInt8::get()) return;

    //Prepare output
    Image* pOutImage = InImage->clone();
    LayerRAM* pOutLayer = pOutImage->getColorLayer()->getEditableRepresentation<LayerRAM>();
    if (pOutLayer->getDataFormat() != DataVec3UInt8::get()) return;
    glm::u8vec3* pRaw = static_cast<glm::u8vec3*>(pOutLayer->getData());

    //Mix!
    Mix(Resolution, pRaw);

    //Push it out!
    portOutImage.setData(pOutImage);
}

} // namespace
} // namespace

