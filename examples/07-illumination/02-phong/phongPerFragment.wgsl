struct VertexInput {
    @location(0) position: vec3f,
    @location(1) texcoords: vec2f,
    @location(2) normal: vec3f,
}

struct VertexOutput {
    @builtin(position) clipPosition: vec4f,
    @location(0) position: vec3f,
    @location(1) texcoords: vec2f,
    @location(2) normal: vec3f,
}

struct FragmentInput {
    @location(0) position: vec3f,
    @location(1) texcoords: vec2f,
    @location(2) normal: vec3f,
}

struct FragmentOutput {
    @location(0) color: vec4f,
}

struct CameraUniforms {
    viewMatrix: mat4x4f,
    projectionMatrix: mat4x4f,
    position: vec3f,
}

struct LightUniforms {
    color: vec3f,
    position: vec3f,
    attenuation: vec3f,

    ambientColor: vec3f,
    ambientIntensity: f32,

    direction: vec3f,
    f: f32,
    coneTheta: f32,
}

struct ModelUniforms {
    modelMatrix: mat4x4f,
    normalMatrix: mat3x3f,
}

struct MaterialUniforms {
    baseFactor: vec4f,
    diffuse: f32,
    specular: f32,
    shininess: f32,
}

@group(0) @binding(0) var<uniform> camera: CameraUniforms;
@group(1) @binding(0) var<uniform> light: LightUniforms;
@group(2) @binding(0) var<uniform> model: ModelUniforms;
@group(3) @binding(0) var<uniform> material: MaterialUniforms;
@group(3) @binding(1) var baseTexture: texture_2d<f32>;
@group(3) @binding(2) var baseSampler: sampler;

@vertex
fn vertex(input: VertexInput) -> VertexOutput {
    var output: VertexOutput;
    output.clipPosition = camera.projectionMatrix * camera.viewMatrix * model.modelMatrix * vec4(input.position, 1);
    output.position = (model.modelMatrix * vec4(input.position, 1)).xyz;
    output.texcoords = input.texcoords;
    output.normal = model.normalMatrix * input.normal;
    return output;
}

@fragment
fn fragment(input: FragmentInput) -> FragmentOutput {
    var output: FragmentOutput;

    let surfacePosition = input.position;
    let d = distance(surfacePosition, light.position);
    let Ad = 1 / dot(light.attenuation, vec3(1, d, d * d)); // attenuation

    let N = normalize(input.normal);
    let L = normalize(light.position - surfacePosition);
    let V = normalize(camera.position - surfacePosition);
    let H = normalize(L + V);
    let normalizedDirection = normalize(light.direction);

    var Af: f32 = 0.0;

    let distanceFormLight = dot((-1 * L), normalizedDirection);
    let coneLimit = cos(radians(light.coneTheta));

    if (distanceFormLight > coneLimit) {
        Af = pow(distanceFormLight, light.f);
    }

    let Iambient = light.ambientColor * light.ambientIntensity; // ambient light

    let Idiffuse = material.diffuse * light.color * max(dot(N, L), 0.0); // Lambert

    let Ispecular =  material.specular * light.color * pow(max(dot(N, H), 0.0), material.shininess); // blinnPhong

    let I = Ad * Af * (Idiffuse + Ispecular) + Iambient;

    let baseColor = textureSample(baseTexture, baseSampler, input.texcoords) * material.baseFactor;
    let finalColor = baseColor.rgb * I;

    output.color = pow(vec4(finalColor, 1), vec4(1 / 2.2));

    return output;
}
