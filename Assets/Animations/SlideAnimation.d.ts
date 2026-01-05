import Animation, { AnimationAssets } from "./Animation";
interface ConstructionOptions {
    readonly animDuration?: number;
}
export default class SlideAnimation extends Animation {
    animOffsetX: number;
    animOffsetY: number;
    animTargetOffsetX: number;
    animTargetOffsetY: number;
    constructor(offsetX: number, offsetY: number, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
    get isFinished(): boolean;
}
export {};
