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
            focus = 0.9, // od 0 do 1
            coneTheta = 0.8, // od 0 do 1, 0.8 = cos(30)
        }) {
        super({color, intensity, attenuation, ambientColor, ambientIntensity});
        this.focus = focus;
        this.coneTheta = coneTheta;
        this.direction = direction;
    }
}