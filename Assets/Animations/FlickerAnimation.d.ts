import Animation, { AnimationAssets, ConstructionOptions } from "./Animation";
export default class FlickerAnimation extends Animation {
    flickerInterval: number;
    flickerCount: number;
    maxFlickers: number;
    constructor(animationAssets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
}
