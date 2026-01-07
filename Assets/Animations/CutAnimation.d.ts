import { AnimationAssets, ConstructionOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import QuadWithPosition from "Assets/QuadWithPosition";
export default class CutAnimation extends SlideAnimation {
    topQuads: QuadWithPosition[];
    constructor(offsetX: number, offsetY: number, animationAssets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
}
