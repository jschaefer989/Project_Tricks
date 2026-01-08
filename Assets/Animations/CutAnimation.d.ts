import { AnimationAssets, AnimationOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import QuadWithPosition from "Assets/QuadWithPosition";
export default class CutAnimation extends SlideAnimation {
    topQuads: QuadWithPosition[];
    constructor(animDuration: number, offsetX: number, offsetY: number, animationAssets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
}
