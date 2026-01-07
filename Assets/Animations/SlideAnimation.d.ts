import Animation, { AnimationAssets } from "./Animation";
interface ConstructionOptions {
    readonly animDuration?: number;
    readonly drawSeparately?: boolean;
}
export default class SlideAnimation extends Animation {
    animOffsetX: number;
    animOffsetY: number;
    animTargetOffsetX: number;
    animTargetOffsetY: number;
    drawSeparately: boolean;
    constructor(offsetX: number, offsetY: number, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
    calculateAnimationOffset(): void;
    drawAnimation(): void;
}
export {};
