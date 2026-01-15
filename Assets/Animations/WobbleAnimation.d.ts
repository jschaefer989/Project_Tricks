import GameManager from "GameManager";
import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
export default class WobbleAnimation extends Animation {
    wobbleAmount: number;
    originalX: Map<string, number>;
    animDuration: number;
    constructor(gameManager: GameManager, id: string, animDuration: number, wobbleAmount: number, assets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
}
