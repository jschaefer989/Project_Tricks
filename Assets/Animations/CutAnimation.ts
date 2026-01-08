import Asset from "Assets/Asset";
import { AnimationAssets, AnimationOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import QuadWithPosition from "Assets/QuadWithPosition";

export default class CutAnimation extends SlideAnimation {
    topQuads: QuadWithPosition[] = []

  constructor(
    animDuration: number,
    offsetX: number,
    offsetY: number,
    animationAssets: AnimationAssets[],
    constructionOptions?: AnimationOptions
  ) {
    super(animDuration, offsetX, offsetY, animationAssets, constructionOptions);

    for (const asset of this.assets) {
        if (!(asset instanceof Asset)) {
            continue;
        }        
        const imageWidth = asset.image.getWidth();
        const spriteHeight = asset.getHeight();
        const topQuad = love.graphics.newQuad(0, 0, imageWidth, spriteHeight / 2, imageWidth, imageWidth)
        const bottomQuad = love.graphics.newQuad(0, spriteHeight / 2, imageWidth, spriteHeight / 2, imageWidth, imageWidth)
        const topQuadWithPosition = new QuadWithPosition(topQuad, 0, 0)
        asset.quads.push(topQuadWithPosition, new QuadWithPosition(bottomQuad, 0, spriteHeight / 2));
        this.topQuads.push(topQuadWithPosition);
    }
  }

  updateAnimation(deltaTime: number): void {
    if (!this.isAnimating) {
      return;
    }
    this.animElapsed += deltaTime;
    if (this.animElapsed >= this.animDuration) {
      this.animElapsed = this.animDuration;
      this.isAnimating = false;
    }

    this.calculateAnimationOffset();

    for (const topQuad of this.topQuads) {
        topQuad.y = this.animOffsetY;
    }
  }
}
