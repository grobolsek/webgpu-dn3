import {Light} from "./Light.js";

export class ReflectorLight extends Light {
    constructor(
        {
            color = [255, 255, 255],
            intensity = 1,
            attenuation = [0.001, 0, 0.3],
            ambientColor = [1, 1, 1],
            ambientIntensity = 0.05,

            direction = [0, 0, -1],
            f = 2.0,
            coneTheta = 10,
        }) {
        super({color, intensity, attenuation, ambientColor, ambientIntensity});
        this.f = f;
        this.coneTheta = coneTheta;
        this.direction = direction;
    }
}