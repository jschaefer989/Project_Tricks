import GameManager from "GameManager";
import Animation, { AnimationAssets, AnimationOptions } from "./Animation";

export interface SlideOptions extends AnimationOptions {
  readonly animDuration?: number;
  readonly bounceEffect?: boolean;
}

export default class SlideAnimation extends Animation {
  animOffsetX: number = 0; // Current animation offset
  animOffsetY: number = 0; // Current animation offset
  animTargetOffsetX: number = 0; // Target animation offset
  animTargetOffsetY: number = 0; // Target animation offset (e.g., -20 for up)
  animDuration: number;
  bounceEffect: boolean;

  constructor(
    gameManager: GameManager,
    id: string,
    animDuration: number,
    offsetX: number,
    offsetY: number,
    assets: AnimationAssets[],
    constructionOptions?: SlideOptions
  ) {
    super(gameManager, id, assets, constructionOptions);
    this.bounceEffect = constructionOptions?.bounceEffect ?? false;
    this.animTargetOffsetX = offsetX + this.getOvershootAmount(offsetX);
    this.animTargetOffsetY = offsetY + this.getOvershootAmount(offsetY);
    this.animDuration = animDuration;
  }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {
      // finish sending the assets to their target positions
      this.updateX(this.animTargetOffsetX);
      this.updateY(this.animTargetOffsetY);
      this.applyBounceEffect();
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

  applyBounceEffect(): void {
    if (!this.bounceEffect) return;

    // Bounce back from overshoot to actual target
    const bounceAmplitudeX = -this.getOvershootAmount(this.animTargetOffsetX);
    const bounceAmplitudeY = -this.getOvershootAmount(this.animTargetOffsetY);

    this.gameManager.animationManager.startAnimation(
      this.id + "_bounce",
      new SlideAnimation(
        this.gameManager,
        this.id + "_bounce",
        0.1,
        bounceAmplitudeX,
        bounceAmplitudeY,
        this.getAssets()
      )
    );
  }

  getOvershootAmount(target: number): number {
    if (!this.bounceEffect) return 0;
    return target * 0.1; // Overshoot by 10%
  }
}
