import Animation, { AnimationAssets, AnimationOptions } from "./Animation";

export interface SlideOptions extends AnimationOptions {
  readonly animDuration?: number;
  readonly drawSeparately?: boolean;
}

export default class SlideAnimation extends Animation {
  animOffsetX: number = 0; // Current animation offset
  animOffsetY: number = 0; // Current animation offset
  animTargetOffsetX: number = 0; // Target animation offset
  animTargetOffsetY: number = 0; // Target animation offset (e.g., -20 for up)
  animDuration: number;

  constructor(
    animDuration: number,
    offsetX: number,
    offsetY: number,
    assets: AnimationAssets[],
    constructionOptions?: SlideOptions
  ) {
    super(assets, constructionOptions);
    this.animTargetOffsetX = offsetX;
    this.animTargetOffsetY = offsetY;
    this.animDuration = animDuration;
  }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {
      // finish sending the assets to their target positions
      this.updateX(this.animTargetOffsetX);
      this.updateY(this.animTargetOffsetY);
      return;
    }

    // Interpolate animation offset
    this.calculateAnimationOffset();

    this.updateX(this.animOffsetX);
    this.updateY(this.animOffsetY);
  }

  calculateAnimationOffset(): void {
    const progress = this.animElapsed / this.animDuration;
    this.animOffsetX = this.animTargetOffsetX * progress;
    this.animOffsetY = this.animTargetOffsetY * progress;
  }
}
