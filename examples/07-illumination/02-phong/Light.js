export class Light {

    constructor({
        color = [255, 255, 255],
        intensity = 1,
        attenuation = [0.001, 0, 0.3],
        ambientColor = [1, 1, 1],
        ambientIntensity = 0.05,

    } = {}) {
        this.color = color;
        this.intensity = intensity;
        this.attenuation = attenuation;
        this.ambientColor = ambientColor;
        this.ambientIntensity = ambientIntensity;
    }

}
