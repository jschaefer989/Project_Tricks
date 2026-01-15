import { AnimationAssets, AnimationOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import QuadWithPosition from "Assets/QuadWithPosition";
import GameManager from "GameManager";
export default class CutAnimation extends SlideAnimation {
    topQuads: QuadWithPosition[];
    constructor(gameMangager: GameManager, id: string, animDuration: number, offsetX: number, offsetY: number, animationAssets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
}
