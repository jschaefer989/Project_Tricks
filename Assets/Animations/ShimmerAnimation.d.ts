import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
interface ConstructionOptions extends AnimationOptions {
    readonly shimmerSpeed?: number;
}
export default class ShimmerAnimation extends Animation {
    private shimmerSpeed;
    private shimmerShader;
    private shimmerPhase;
    constructor(stopCondition: () => boolean, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
}
export {};
