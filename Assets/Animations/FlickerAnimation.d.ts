import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
export default class FlickerAnimation extends Animation {
    flickerInterval: number;
    flickerCount: number;
    maxFlickers: number;
    constructor(animationAssets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
}
