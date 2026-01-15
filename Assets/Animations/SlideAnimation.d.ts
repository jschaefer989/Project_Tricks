import GameManager from "GameManager";
import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
export interface SlideOptions extends AnimationOptions {
    readonly animDuration?: number;
}
export default class SlideAnimation extends Animation {
    animOffsetX: number;
    animOffsetY: number;
    animTargetOffsetX: number;
    animTargetOffsetY: number;
    animDuration: number;
    constructor(gameManager: GameManager, id: string, animDuration: number, offsetX: number, offsetY: number, assets: AnimationAssets[], constructionOptions?: SlideOptions);
    updateAnimation(deltaTime: number): void;
    calculateAnimationOffset(): void;
}
