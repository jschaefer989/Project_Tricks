import Asset from "Assets/Asset";
import { AnimationAssets, ConstructionOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import { Quad } from "love.graphics";
export default class CutAnimation extends SlideAnimation {
    topQuads: Map<Asset, Quad>;
    bottomQuads: Map<Asset, Quad>;
    stationaryAssets: AnimationAssets[];
    constructor(offsetX: number, offsetY: number, animationAssets: AnimationAssets[], stationaryAssets?: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
    drawAnimation(): void;
}
