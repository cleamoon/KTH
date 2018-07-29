/*********************************************************************
 *  Author  : Himangshu Saikia
 *  Init    : Friday, October 13, 2017 - 16:05:29
 *
 *  Project : KTH Inviwo Modules
 *
 *  License : Follows the Inviwo BSD license model
 *********************************************************************
 */

#include <labraytracer/raytracer.h>
#include <labraytracer/util.h>
#include <labraytracer/triangle.h>
#include <labraytracer/sphere.h>
#include <labraytracer/plane.h>
#include <labraytracer/constantmaterial.h>
#include <labraytracer/phongmaterial.h>
#include <inviwo/core/datastructures/image/layerram.h>

namespace inviwo {

// The Class Identifier has to be globally unique. Use a reverse DNS naming scheme
const ProcessorInfo Raytracer::processorInfo_
{
    "org.inviwo.Raytracer",  // Class identifier
    "Raytracer",             // Display name
    "DH2230",                // Category
    CodeState::Experimental, // Code state
    Tags::None,              // Tags
};

const ProcessorInfo Raytracer::getProcessorInfo() const {
    return processorInfo_;
}


Raytracer::Raytracer()
    : Processor()
    , image_("image")
    , sceneGeometry_("sg")
    , camera_("camera", "Camera")
    , imageSize_("imSize", "Image Size", ivec2(100, 100), ivec2(10, 10), ivec2(1000, 1000),
        ivec2(1, 1))
    , colorLight_("light", "Light", 
        vec4(0.2, 0.2, 0.2, 1.0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    , ambientLight_("ambientlight", "Ambient Light",
        vec4(0.8, 0.65, 0.6, 1.0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    , diffuseLight_("diffuseLight", "Diffuse Light",
        vec4(0.8, 0.65, 0.6, 1.0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    , specularLight_("specularLight", "Specular Light",
        vec4(0.8, 0.65, 0.6, 1.0), vec4(0), vec4(1), vec4(.1f), InvalidationLevel::InvalidOutput, PropertySemantics::Color)
    , render_("render", "Render")
    , task_("task", "Task") 
    {

    addPort(image_);
    addPort(sceneGeometry_);

    task_.addOption("task1", "Task 1", 0);
    task_.addOption("task2", "Task 2", 1);
    task_.addOption("task3", "Bonus Task", 2);
    addProperty(task_);

    addProperty(imageSize_);

    addProperty(colorLight_);

    addProperty(ambientLight_);
    addProperty(diffuseLight_);
    addProperty(specularLight_);

    addProperty(camera_);

    camera_.setLookFrom(vec3(5, 0, 5));
    camera_.setLookTo(vec3(0, 0, 0));
    camera_.setLookUp(vec3(0, 0, 1));

    render_.onChange(this, &Raytracer::render);
    addProperty(render_);

    task_.onChange([&]()
    {
        if (task_.get() == 0) {
            colorLight_.setVisible(true);
            ambientLight_.setVisible(false);
            diffuseLight_.setVisible(false);
            specularLight_.setVisible(false);
        } else {
            colorLight_.setVisible(false);
            ambientLight_.setVisible(true);
            diffuseLight_.setVisible(true);
            specularLight_.setVisible(true);
        }
    });
}


void Raytracer::process() {
    if (&camera_.get()) {
        camera_.getPropertyByIdentifier("cameraType")->setReadOnly(true);
        camera_.getPropertyByIdentifier("aspectRatio")->setReadOnly(true);
    } else {
        return;
    }

    cam_ = dynamic_cast<PerspectiveCamera*>(&camera_.get());

    //make scene

    scene_.clear();

    scene_.init(imageSize_.get());

    scene_.setCameraProperties(cam_->getLookFrom(), cam_->getLookTo(), cam_->getLookUp(),
                               cam_->getFovy());

    if (task_.get() == 0) {
        task1();
    }
    else if (task_.get() == 2)
    {
        bonusTask();
    }
    else {
        task2();
    }

    auto mesh = std::make_shared<BasicMesh>();
    std::vector<BasicMesh::Vertex> vertices;

    scene_.drawCameraGeometry(mesh, vertices);
    scene_.drawAxesGeometry(mesh, vertices);
    scene_.drawRenderablesGeometry(mesh, vertices);

    mesh->addVertices(vertices);
    sceneGeometry_.setData(mesh);
}

std::string printPoint(const vec3& pt) {
    std::stringstream ss;
    ss << "(" << pt.x << "," << pt.y << "," << pt.z << ")";
    return ss.str();
}


void Raytracer::render() {
    auto outImage = std::make_shared<Image>();

    auto outLayer = outImage->getColorLayer();

    outLayer->setDimensions(imageSize_.get());

    outLayer->setDataFormat(DataVec4Float32::get());

    auto lr = outLayer->getEditableRepresentation<LayerRAM>();

    scene_.render(lr);

    image_.setData(outImage);
}

void Raytracer::task1() {
    std::shared_ptr<Light> light1 = std::make_shared<Light>(vec3(5, 2, 6), colorLight_, colorLight_, colorLight_);
    scene_.addLight(light1);

    vec3 a(2, 1, 0);
    vec3 b(1, 2, 0);
    vec3 c(1, 0, 2);

    std::shared_ptr<Triangle> triangle = std::make_shared<Triangle>(a, b, c);

    std::shared_ptr<Sphere> sphere1 = std::make_shared<Sphere>(vec3(-5, -2, 1), 1);
    std::shared_ptr<Sphere> sphere2 = std::make_shared<Sphere>(vec3(0, 1, 1), 1.5);
    std::shared_ptr<Sphere> sphere3 = std::make_shared<Sphere>(vec3(-2, 0, 2), 1);

    std::shared_ptr<PlaneX> plane = std::make_shared<PlaneX>();

    std::shared_ptr<Material> materialTriangle = std::make_shared<ConstantMaterial
    >(vec3(0.8, 0.0, 0.1));
    std::shared_ptr<Material> materialSpheres = std::make_shared<ConstantMaterial
    >(vec3(1.0, 0.4, 0.1));
    std::shared_ptr<Material> materialPlane = std::make_shared<ConstantMaterial
    >(vec3(0.0, 0.2, 0.7));

    triangle->setMaterial(materialTriangle);
    sphere1->setMaterial(materialSpheres);
    sphere2->setMaterial(materialSpheres);
    sphere3->setMaterial(materialSpheres);
    plane->setMaterial(materialPlane);

    scene_.addRenderable(triangle);
    scene_.addRenderable(sphere1);
    scene_.addRenderable(sphere2);
    scene_.addRenderable(sphere3);
    scene_.addRenderable(plane);
}

void Raytracer::task2() {
    std::shared_ptr<Material> material1 = std::make_shared<PhongMaterial>(vec3(1.0, 0.4, 0.1), 0.8,
        1000.0, vec3(1.0, 0.4, 0.1), vec3(1.0, 0.4, 0.1), vec3(1.0, 0.4, 0.1));
    std::shared_ptr<Material> material2 = std::make_shared<PhongMaterial>(vec3(0.0, 0.0, 0.0), 0.2,
        1000.0, vec3(0.0, 0.0, 0.0), vec3(0.2, 0.2, 0.2), vec3(1.0, 1.0, 1.0));
    std::shared_ptr<Material> material3 = std::make_shared<PhongMaterial>(vec3(0.2, 0.3, 0.8), 0.1,
        10.0, vec3(0.2, 0.3, 0.8), vec3(0.2, 0.3, 0.8), vec3(0.2, 0.3, 0.8));
    std::shared_ptr<Material> material4 = std::make_shared<PhongMaterial>(vec3(0.5, 0.0, 0.0), 0.2,
        50.0, vec3(0.5, 0.0, 0.0), vec3(0.5, 0.0, 0.0), vec3(0.5, 0.0, 0.0));
    std::shared_ptr<Material> material5 = std::make_shared<PhongMaterial>(vec3(0.5, 0.5, 0.5), 0.1,
        100.0, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5));

    std::shared_ptr<Sphere> sphere1 = std::make_shared<Sphere>(vec3(1.1, 1.1, 1.1));
    std::shared_ptr<Sphere> sphere2 = std::make_shared<Sphere>(vec3(-1.1, 1.1, 1.1));
    std::shared_ptr<Sphere> sphere3 = std::make_shared<Sphere>(vec3(0.0, -1.1, 1.1));
    std::shared_ptr<Sphere> sphere4 = std::make_shared<Sphere>(vec3(0.0, 0.0, 2.0));

    vec3 RedShift(200, 170, 150);
    RedShift = Util::normalize(RedShift);
    vec3 BlueShift(130, 160, 200);
    BlueShift = Util::normalize(BlueShift);

    std::shared_ptr<Light> light1 = std::make_shared<Light>(vec3(5.0, 2.0, 6.0), ambientLight_, diffuseLight_.get() * RedShift, specularLight_);
    std::shared_ptr<Light> light2 = std::make_shared<Light>(vec3(5.0, -7.0, 3.0), ambientLight_, diffuseLight_.get() * RedShift, specularLight_);
    std::shared_ptr<Light> light3 = std::make_shared<Light>(vec3(-10.0, 4.0, 5.0), ambientLight_, diffuseLight_.get() * BlueShift, specularLight_);

    std::shared_ptr<PlaneX> plane = std::make_shared<PlaneX>();

    sphere1->setMaterial(material1);
    sphere2->setMaterial(material2);
    sphere3->setMaterial(material3);
    sphere4->setMaterial(material4);
    plane->setMaterial(material5);

    scene_.addRenderable(sphere1);
    scene_.addRenderable(sphere2);
    scene_.addRenderable(sphere3);
    scene_.addRenderable(sphere4);
    scene_.addRenderable(plane);

    scene_.addLight(light1);
    scene_.addLight(light2);
    scene_.addLight(light3);
}

void Raytracer::bonusTask()
{
    std::shared_ptr<Material> material1 = std::make_shared<PhongMaterial>(vec3(1.0, 0.4, 0.1), 0.8,
        1000.0, vec3(1.0, 0.4, 0.1), vec3(1.0, 0.4, 0.1), vec3(1.0, 0.4, 0.1));
    std::shared_ptr<Material> material2 = std::make_shared<PhongMaterial>(vec3(0.0, 0.8, 0.8), 0.2,
        1000.0, vec3(0.0, 0.8, 0.8), vec3(0.0, 0.8, 0.8), vec3(0.0, 0.8, 0.8));
    std::shared_ptr<Material> material3 = std::make_shared<PhongMaterial>(vec3(0.2, 0.3, 0.8), 0.1,
        10.0, vec3(0.2, 0.3, 0.8), vec3(0.2, 0.3, 0.8), vec3(0.2, 0.3, 0.8));
    std::shared_ptr<Material> material4 = std::make_shared<PhongMaterial>(vec3(0.5, 0.0, 0.0), 0.2,
        50.0, vec3(0.5, 0.0, 0.0), vec3(0.5, 0.0, 0.0), vec3(0.5, 0.0, 0.0));
    std::shared_ptr<Material> material5 = std::make_shared<PhongMaterial>(vec3(0.5, 0.5, 0.5), 0.1,
        100.0, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5));

    std::shared_ptr<Sphere> sphere1 = std::make_shared<Sphere>(vec3(0.0, 0.0, 2), 2);
    std::shared_ptr<Sphere> sphere5 = std::make_shared<Sphere>(vec3(2, 1.0, 1), 0.7);

    // TODO:
    // These three spheres should subtract volume.
    std::shared_ptr<Sphere> sphere2 = std::make_shared<Sphere>(vec3(0.0, 0.0, 2), 1);
    std::shared_ptr<Sphere> sphere3 = std::make_shared<Sphere>(vec3(2.2, 0, 3), 2);
    std::shared_ptr<Sphere> sphere4 = std::make_shared<Sphere>(vec3(1, 1.5, 2), 1);

    vec3 RedShift(200, 170, 150);
    RedShift = Util::normalize(RedShift);

    std::shared_ptr<Light> light1 = std::make_shared<Light>(vec3(5.0, 2.0, 6.0),
        ambientLight_, diffuseLight_.get() * RedShift, specularLight_);
    std::shared_ptr<Light> light2 = std::make_shared<Light>(vec3(5.0, -7.0, 3.0),
        ambientLight_, diffuseLight_.get() * RedShift, specularLight_);

    std::shared_ptr<PlaneX> plane = std::make_shared<PlaneX>();

    sphere1->setMaterial(material1);
    sphere2->setMaterial(material2);
    sphere3->setMaterial(material3);
    sphere4->setMaterial(material4);
    sphere5->setMaterial(material1);
    plane->setMaterial(material5);

    scene_.addRenderable(sphere1);
    scene_.addRenderable(sphere2);
    scene_.addRenderable(sphere3);
    scene_.addRenderable(sphere4);
    scene_.addRenderable(sphere5);
    scene_.addRenderable(plane);

    scene_.addLight(light1);
    scene_.addLight(light2);
}

} // namespace
