import Animation, { AnimationAssets, AnimationOptions } from "./Animation";

export default class WobbleAnimation extends Animation {
  wobbleAmount = 10; // Maximum wobble offset in pixels
  originalX: Map<string, number> = new Map<string, number>();
  animDuration: number;

  constructor(
    animDuration: number,
    wobbleAmount: number,
    assets: AnimationAssets[],
    constructionOptions?: AnimationOptions
  ) {
    super(assets, { onFinish: () => this.updateX(0), ...constructionOptions });
    this.originalX = new Map(assets.map((asset) => [asset.id, asset.x]));
    this.wobbleAmount = wobbleAmount;
    this.animDuration = animDuration;
  }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {
      return;
    }

    // Create a wobble effect using a damped sine wave
    // Frequency increases for multiple wobbles, amplitude decreases over time
    const progress = this.animElapsed / this.animDuration;
    const frequency = 8; // Number of wobbles
    const damping = 1 - progress; // Decrease amplitude over time
    const offset =
      Math.sin(progress * frequency * Math.PI * 2) *
      this.wobbleAmount *
      damping;

    this.updateX(offset);
  }
}
