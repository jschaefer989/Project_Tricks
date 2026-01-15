import GameManager from "GameManager";
import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
export interface SlideOptions extends AnimationOptions {
    readonly animDuration?: number;
    readonly bounceEffect?: boolean;
}
export default class SlideAnimation extends Animation {
    animOffsetX: number;
    animOffsetY: number;
    animTargetOffsetX: number;
    animTargetOffsetY: number;
    animDuration: number;
    bounceEffect: boolean;
    constructor(gameManager: GameManager, id: string, animDuration: number, offsetX: number, offsetY: number, assets: AnimationAssets[], constructionOptions?: SlideOptions);
    updateAnimation(deltaTime: number): void;
    calculateAnimationOffset(): void;
    applyBounceEffect(): void;
    getOvershootAmount(target: number): number;
}
