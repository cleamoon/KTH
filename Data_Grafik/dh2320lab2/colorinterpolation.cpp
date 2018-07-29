/*********************************************************************
 *  Author  : Tino Weinkauf
 *  Init    : Thursday, February 08, 2018 - 08:57:14
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <modules/dh2320lab2/colorinterpolation.h>

#include <modules/dh2320lab2/colorspace/src/ColorSpace.h>
#include <modules/dh2320lab2/colorspace/src/Comparison.h>


namespace
{
    /*  Interpolates between two colors in RGB color space.

        ColorA shall be obtained when t = 0;
        ColorB shall be obtained when t = 1;

        RGB colors are encoded as three floating-point values in the interval [0, 255]:

        ColorA.r refers to the red component of the color.
        ColorA.g refers to the green component of the color.
        ColorA.b refers to the blue component of the color.

        The interpolation parameter t is in the range [0, 1].
    */
    ColorSpace::Rgb InterpolateInRGB(const ColorSpace::Rgb& ColorA, const ColorSpace::Rgb& ColorB,
                                     const float t)
    {
        ColorSpace::Rgb InterpolatedColor;

        InterpolatedColor.r = ColorA.r;
        InterpolatedColor.g = t * ColorB.g;
        InterpolatedColor.b = ColorA.b;

        return InterpolatedColor;
    }


    /*  Interpolates between two colors in CMYK color space.

        ColorA shall be obtained when t = 0;
        ColorB shall be obtained when t = 1;

        CMYK colors are encoded as four floating-point values in the interval [0, 1]:

        ColorA.c refers to the cyan component of the color.
        ColorA.m refers to the magenta component of the color.
        ColorA.y refers to the yellow component of the color.
        ColorA.k refers to the black component of the color.

        The interpolation parameter t is in the range [0, 1].
    */
    ColorSpace::Cmyk InterpolateInCMYK(const ColorSpace::Cmyk& ColorA, const ColorSpace::Cmyk& ColorB,
                                       const float t)
    {
        ColorSpace::Cmyk InterpolatedColor;

        InterpolatedColor.c = (1-t) * ColorA.c;
        InterpolatedColor.m = (1-t) * ColorA.m;
        InterpolatedColor.y = t * ColorB.y;
        InterpolatedColor.k = t * ColorB.k;

        return InterpolatedColor;
    }


    /*  Interpolates between two colors in HSV color space.

        ColorA shall be obtained when t = 0;
        ColorB shall be obtained when t = 1;

        HSV colors are encoded as three floating-point values:

        ColorA.h refers to the hue component of the color in the interval [0, 360].
        ColorA.s refers to the magenta component of the color in the interval [0, 1].
        ColorA.v refers to the yellow component of the color in the interval [0, 1].

        The interpolation parameter t is in the range [0, 1].
    */
    ColorSpace::Hsv InterpolateInHSV(const ColorSpace::Hsv& ColorA, const ColorSpace::Hsv& ColorB,
                                     const float t)
    {
        ColorSpace::Hsv InterpolatedColor;

        InterpolatedColor.h = 5 * t * ColorB.h;
        InterpolatedColor.s = ColorA.s + ColorB.s;
        InterpolatedColor.v = ColorA.v + ColorB.v;

        return InterpolatedColor;
    }


    /*  Changes the Value and Saturation of a HSV color.

        The minimum Value shall be obtained when tValue = 0;
        The maximum Value shall be obtained when tValue = 1;

        The minimum Saturation shall be obtained when tSaturation = 0;
        The maximum Saturation shall be obtained when tSaturation = 1;

        HSV colors are encoded as three floating-point values:

        ColorA.h refers to the hue component of the color in the interval [0, 360].
        ColorA.s refers to the magenta component of the color in the interval [0, 1].
        ColorA.v refers to the yellow component of the color in the interval [0, 1].

        The interpolation parameters tValue and tSaturation are in the range [0, 1].
    */
    ColorSpace::Hsv ChangeValueAndSaturation(const ColorSpace::Hsv& Color, const float tValue, const float tSaturation)
    {
        ColorSpace::Hsv ChangedColor;

        ChangedColor.h = 220.0;
        ChangedColor.s = 1.0;
        ChangedColor.v = 0.9;

        return ChangedColor;
    }


    /*  Changes the Hue and Saturation of a HSV color.

        The minimum Hue shall be obtained when tHue = 0;
        The maximum Hue shall be obtained when tHue = 1;

        The minimum Saturation shall be obtained when tSaturation = 0;
        The maximum Saturation shall be obtained when tSaturation = 1;

        HSV colors are encoded as three floating-point values:

        ColorA.h refers to the hue component of the color in the interval [0, 360].
        ColorA.s refers to the magenta component of the color in the interval [0, 1].
        ColorA.v refers to the yellow component of the color in the interval [0, 1].

        The interpolation parameters tHue and tSaturation are in the range [0, 1].
    */
    ColorSpace::Hsv ChangeHueAndSaturation(const ColorSpace::Hsv& Color, const float tHue, const float tSaturation)
    {
        ColorSpace::Hsv ChangedColor;

        ChangedColor.h = 180.0;
        ChangedColor.s = 1.0;
        ChangedColor.v = 0.5;

        return ChangedColor;
    }
}


namespace inviwo
{
namespace kth
{

// The Class Identifier has to be globally unique. Use a reverse DNS naming scheme
const ProcessorInfo ColorInterpolation::processorInfo_
{
    "org.inviwo.ColorInterpolation",      // Class identifier
    "Color Interpolation",                // Display name
    "DH2320",              // Category
    CodeState::Experimental,  // Code state
    Tags::None,               // Tags
};

const ProcessorInfo ColorInterpolation::getProcessorInfo() const
{
    return processorInfo_;
}

    
ColorInterpolation::ColorInterpolation()
    :propColorA("ColorA", "Color A", vec4(0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    ,propColorB("ColorB", "Color B", vec4(0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
{
    addProperty(propColorA);
    addProperty(propColorB);
}
    
namespace
{
    glm::u8vec3 ToOutputColor(ColorSpace::IColorSpace& Color)
    {
        ColorSpace::Rgb RGB;
        Color.ToRgb(&RGB);
        return glm::u8vec3(RGB.r, RGB.g, RGB.b);
    }
}


void ColorInterpolation::Mix(const size2_t& Resolution, glm::u8vec3* pRaw)
{
    //Find color template spaces
    if (portInImage.isChanged())
    {
        ColorTemplateBBoxes.clear();
        for(size_t j(0),Idx(0);j<Resolution.y;j++)
        {
            for(size_t i(0);i<Resolution.x;i++,Idx++)
            {
                if (pRaw[Idx].r > 110 && pRaw[Idx].g == 0 && pRaw[Idx].b == 0)
                {
                    auto itTemplateBBox = ColorTemplateBBoxes.find(pRaw[Idx].r);
                    if (itTemplateBBox != ColorTemplateBBoxes.end())
                    {
                        auto& BBox = itTemplateBBox->second;
                        //Existing color template found; expand the bbox.
                        BBox.first.x  = std::min(BBox.first.x,  (size_t) i);
                        BBox.first.y  = std::min(BBox.first.y,  (size_t) j);
                        BBox.second.x = std::max(BBox.second.x, (size_t) i);
                        BBox.second.y = std::max(BBox.second.y, (size_t) j);
                    }
                    else
                    {
                        //New color template found; init the bbox.
                        ColorTemplateBBoxes[pRaw[Idx].r] = std::make_pair(size2_t(i,j), size2_t(i,j));
                    }
                }
            }
        }

        //for(auto& huhu : ColorTemplateBBoxes)
        //{
        //    LogInfo((int)huhu.first << ": " << huhu.second.first << " - " << huhu.second.second);
        //}
    }

    //Get the primary colors
    const vec3 ColorA(propColorA.get().r, propColorA.get().g, propColorA.get().b);
    const vec3 ColorB(propColorB.get().r, propColorB.get().g, propColorB.get().b);

    //Some helper colors
    ColorSpace::Hsv Black(0, 0, 0), White(0, 0, 1);

    for(size_t j(0),Idx(0);j<Resolution.y;j++)
    {
        for(size_t i(0);i<Resolution.x;i++,Idx++)
        {
            if (pRaw[Idx].r > 110 && pRaw[Idx].g == 0 && pRaw[Idx].b == 0)
            {
                if (pRaw[Idx].r > 210)
                {
                    //Primary color swatches
                    pRaw[Idx] = (pRaw[Idx].r == 255) ? ToUChar(ColorA) : ToUChar(ColorB);
                }
                else
                {
                    //Primary colors in RGB
                    ColorSpace::Rgb rgbColorA(ColorA.r * 255.0, ColorA.g * 255.0, ColorA.b * 255.0);
                    ColorSpace::Rgb rgbColorB(ColorB.r * 255.0, ColorB.g * 255.0, ColorB.b * 255.0);

                    //Interpolation boxes
                    // - get the bbox
                    auto itTemplateBBox = ColorTemplateBBoxes.find(pRaw[Idx].r);
                    ivwAssert(itTemplateBBox != ColorTemplateBBoxes.end(), "Check this.");
                    size2_t& BBoxMin = itTemplateBBox->second.first;
                    size2_t& BBoxMax = itTemplateBBox->second.second;
                    // - get the interpolation values in x-direction and y-direction.
                    // -  - they run in the interval [0, 1].
                    vec2 t = vec2(size2_t(i, j) - BBoxMin) / vec2(BBoxMax - BBoxMin);

                    switch(pRaw[Idx].r)
                    {
                        case 200:
                        {
                            ColorSpace::Rgb rgbInterpol = InterpolateInRGB(rgbColorA, rgbColorB, t.x);
                            pRaw[Idx] = ToOutputColor(rgbInterpol);
                            break;
                        }

                        case 180:
                        {
                            ColorSpace::Cmyk cmykColorA, cmykColorB;
                            rgbColorA.To<ColorSpace::Cmyk>(&cmykColorA);
                            rgbColorB.To<ColorSpace::Cmyk>(&cmykColorB);
                            ColorSpace::Cmyk cmykInterpol = InterpolateInCMYK(cmykColorA, cmykColorB, t.x);
                            pRaw[Idx] = ToOutputColor(cmykInterpol);
                            break;
                        }

                        case 160:
                        {
                            ColorSpace::Hsv hsvColorA, hsvColorB;
                            rgbColorA.To<ColorSpace::Hsv>(&hsvColorA);
                            rgbColorB.To<ColorSpace::Hsv>(&hsvColorB);
                            ColorSpace::Hsv hsvInterpol = InterpolateInHSV(hsvColorA, hsvColorB, t.x);
                            pRaw[Idx] = ToOutputColor(hsvInterpol);
                            break;
                        }

                        case 140:
                        {
                            ColorSpace::Hsv hsvColorA;
                            rgbColorA.To<ColorSpace::Hsv>(&hsvColorA);
                            ColorSpace::Hsv hsvInterpol = ChangeValueAndSaturation(hsvColorA, t.x, t.y);
                            if (pow(hsvColorA.v - hsvInterpol.v, 2) + pow(hsvColorA.s - hsvInterpol.s, 2) > 0.0025)
                            {
                                pRaw[Idx] = ToOutputColor(hsvInterpol);
                            }
                            else
                            {
                                const double DistanceToBlackWhite = ColorSpace::Cie2000Comparison::Compare(&hsvColorA, &Black) - ColorSpace::Cie2000Comparison::Compare(&hsvColorA, &White);
                                pRaw[Idx] = (DistanceToBlackWhite > 0) ? ToOutputColor(Black) : ToOutputColor(White);
                            }
                            break;
                        }

                        case 120:
                        {
                            ColorSpace::Hsv hsvColorB;
                            rgbColorB.To<ColorSpace::Hsv>(&hsvColorB);
                            ColorSpace::Hsv hsvInterpol = ChangeHueAndSaturation(hsvColorB, 1.0 - t.x, t.y);
                            if (pow(hsvColorB.h/360 - hsvInterpol.h/360, 2) + pow(hsvColorB.s - hsvInterpol.s, 2) > 0.0025)
                            {
                                pRaw[Idx] = ToOutputColor(hsvInterpol);
                            }
                            else
                            {
                                const double DistanceToBlackWhite = ColorSpace::Cie2000Comparison::Compare(&hsvColorB, &Black) - ColorSpace::Cie2000Comparison::Compare(&hsvColorB, &White);
                                pRaw[Idx] = (DistanceToBlackWhite > 0) ? ToOutputColor(Black) : ToOutputColor(White);
                            }
                            break;
                        }
                    }
                }
            }
        }
    }
}

} // namespace
} // namespace

