import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
import GameManager from "GameManager";
export default class FlickerAnimation extends Animation {
    flickerInterval: number;
    flickerCount: number;
    maxFlickers: number;
    constructor(gameManager: GameManager, id: string, animationAssets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
}
