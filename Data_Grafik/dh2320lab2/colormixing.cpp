/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Wednesday, February 07, 2018 - 22:56:32
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

// The Class Identifier has to be globally unique. Use a reverse DNS naming scheme
const ProcessorInfo ColorMixing::processorInfo_
{
    "org.inviwo.ColorMixing",      // Class identifier
    "Color Mixing",                // Display name
    "DH2320",              // Category
    CodeState::Experimental,  // Code state
    Tags::None,               // Tags
};

const ProcessorInfo ColorMixing::getProcessorInfo() const
{
    return processorInfo_;
}

    
ColorMixing::ColorMixing()
    :propMixingMode("MixingMode", "Mode")
    ,propColorA("ColorA", "Color A", vec4(0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    ,propColorB("ColorB", "Color B", vec4(0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    ,propColorC("ColorC", "Color C", vec4(0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
{
    propMixingMode.addOption("AdditiveColorMixing", "Additive Color Mixing", 0);
    propMixingMode.addOption("SubtractiveColorMixing", "Subtractive Color Mixing", 1);
    addProperty(propMixingMode);

    addProperty(propColorA);
    addProperty(propColorB);
    addProperty(propColorC);
}
    

/*  Mixes the two given colors using additive color mixing.

    A color is encoded as three floating-point values in the interval [0, 1]:

    Color1.r refers to the red component of the color.
    Color1.g refers to the green component of the color.
    Color1.b refers to the blue component of the color.
*/
vec3 ColorMixing::AdditiveColorMixing(const vec3& Color1, const vec3& Color2)
{
    vec3 MixedColor;
    vec3 Black(0,0,0);
    vec3 White(1,1,1);

    MixedColor = White - Color1;

    return MixedColor;
}


/*  Mixes the two given colors using subtractive color mixing.

    A color is encoded as three floating-point values in the interval [0, 1]:

    Color1.r refers to the red component of the color.
    Color1.g refers to the green component of the color.
    Color1.b refers to the blue component of the color.
*/
vec3 ColorMixing::SubtractiveColorMixing(const vec3& Color1, const vec3& Color2)
{
    vec3 MixedColor;
    vec3 Black(0,0,0);
    vec3 White(1,1,1);

    MixedColor = Black + Color2;

    return MixedColor;
}


void ColorMixing::Mix(const size2_t& Resolution, glm::u8vec3* pRaw)
{
    //Get the primary colors
    const vec3 ColorA(propColorA.get().r, propColorA.get().g, propColorA.get().b);
    const vec3 ColorB(propColorB.get().r, propColorB.get().g, propColorB.get().b);
    const vec3 ColorC(propColorC.get().r, propColorC.get().g, propColorC.get().b);

    //Mix!
    const vec3 ColorAB  = propMixingMode.get() == 0 ? AdditiveColorMixing(ColorA, ColorB) : SubtractiveColorMixing(ColorA, ColorB);
    const vec3 ColorBC  = propMixingMode.get() == 0 ? AdditiveColorMixing(ColorB, ColorC) : SubtractiveColorMixing(ColorB, ColorC);
    const vec3 ColorAC  = propMixingMode.get() == 0 ? AdditiveColorMixing(ColorA, ColorC) : SubtractiveColorMixing(ColorA, ColorC);
    const vec3 ColorABC = propMixingMode.get() == 0 ? AdditiveColorMixing(ColorAB, ColorC): SubtractiveColorMixing(ColorAB, ColorC);

    //Replace colors
    for(size_t i(0);i<Resolution.x;i++)
    {
        for(size_t j(0);j<Resolution.y;j++)
        {
            const size_t Idx = (j * Resolution.x + i);
            if (pRaw[Idx].g == 0 && pRaw[Idx].b == 0)
            {
                switch (pRaw[Idx].r)
                {
                    case 255:
                        pRaw[Idx] = ToUChar(ColorA);
                        break;

                    case 200:
                        pRaw[Idx] = ToUChar(ColorB);
                        break;

                    case 220:
                        pRaw[Idx] = ToUChar(ColorC);
                        break;

                    case 180:
                        pRaw[Idx] = ToUChar(ColorAB);
                        break;

                    case 160:
                        pRaw[Idx] = ToUChar(ColorBC);
                        break;

                    case 140:
                        pRaw[Idx] = ToUChar(ColorAC);
                        break;

                    case 120:
                        pRaw[Idx] = ToUChar(ColorABC);
                        break;

                    default:
                        break;
                }
            }
        }
    }
}

} // namespace
} // namespace

