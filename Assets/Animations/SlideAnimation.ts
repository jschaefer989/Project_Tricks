import Asset from "Assets/Asset";
import Animation, { AnimationAssets } from "./Animation";

interface ConstructionOptions {
  readonly animDuration?: number;
  readonly drawSeparately?: boolean;
}

export default class SlideAnimation extends Animation {
  animOffsetX: number = 0; // Current animation offset
  animOffsetY: number = 0; // Current animation offset
  animTargetOffsetX: number = 0; // Target animation offset
  animTargetOffsetY: number = 0; // Target animation offset (e.g., -20 for up)
  drawSeparately: boolean = false;

  constructor(
    offsetX: number,
    offsetY: number,
    assets: AnimationAssets[],
    constructionOptions?: ConstructionOptions
  ) {
    super(assets, constructionOptions);
    this.animTargetOffsetX = offsetX;
    this.animTargetOffsetY = offsetY;
    this.drawSeparately = constructionOptions?.drawSeparately ?? false;
  }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {
      return;
    }

    // Interpolate animation offset
    this.calculateAnimationOffset();

    if (!this.drawSeparately) {
      this.updateX(this.animOffsetX);
      this.updateY(this.animOffsetY);
    }
  }

  calculateAnimationOffset(): void {
    const progress = this.animElapsed / this.animDuration;
    this.animOffsetX = this.animTargetOffsetX * progress;
    this.animOffsetY = this.animTargetOffsetY * progress;
  }

  drawAnimation(): void {
    if (!this.drawSeparately) {
      return;
    }
    for (const asset of this.assets) {
      if (asset instanceof Asset) {
        love.graphics.draw(
          asset.image,
          asset.x + this.animOffsetX,
          asset.y + this.animOffsetY
        );
      }
    }
  }
}
