import Asset from "Assets/Asset";
import { AnimationAssets, ConstructionOptions } from "./Animation";
import SlideAnimation from "./SlideAnimation";
import { Quad } from "love.graphics";
import FontWithPosition from "Assets/FontWithPosition";

export default class CutAnimation extends SlideAnimation {
    topQuads: Map<Asset, Quad> = new Map<Asset, Quad>();
    bottomQuads: Map<Asset, Quad> = new Map<Asset, Quad>();
    stationaryAssets: AnimationAssets[] = [];

  constructor(
    offsetX: number,
    offsetY: number,
    animationAssets: AnimationAssets[],
    stationaryAssets?: AnimationAssets[],
    constructionOptions?: ConstructionOptions
  ) {
    super(offsetX, offsetY, animationAssets, constructionOptions);

    if (stationaryAssets) {
      this.stationaryAssets = stationaryAssets;
    }

    for (const asset of this.assets) {
        if (!(asset instanceof Asset)) {
            continue;
        }        
        const imageWidth = asset.image.getWidth();
        const spriteHeight = asset.getHeight();
        this.topQuads.set(asset, love.graphics.newQuad(0, 0, imageWidth, spriteHeight / 2, imageWidth, imageWidth));
        this.bottomQuads.set(asset, love.graphics.newQuad(0, spriteHeight / 2, imageWidth, spriteHeight / 2, imageWidth, imageWidth));
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
  }

  drawAnimation(): void {
    for (const [asset, topQuad] of this.topQuads) {
        love.graphics.draw(asset.image, topQuad, asset.x, asset.y + this.animOffsetY)
    }
    for (const [asset, bottomQuad] of this.bottomQuads) {
        love.graphics.draw(asset.image, bottomQuad, asset.x, asset.y + asset.getHeight() / 2)
    }
    for (const asset of this.stationaryAssets) {
        if (asset instanceof Asset) {
            asset.drawAsset();
        }
        if (asset instanceof FontWithPosition) {
            asset.printText();
        }
    }
  }
}
