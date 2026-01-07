import Animation, { AnimationAssets, ConstructionOptions } from "./Animation";

export default class WobbleAnimation extends Animation {
  wobbleAmount = 10; // Maximum wobble offset in pixels
  originalX: Map<string, number> = new Map<string, number>();

  constructor(
    wobbleAmount: number,
    assets: AnimationAssets[],
    constructionOptions?: ConstructionOptions
  ) {
    super(assets, { onFinish: () => this.updateX(0), ...constructionOptions });
    this.originalX = new Map(assets.map((asset) => [asset.id, asset.x]));
    this.wobbleAmount = wobbleAmount;
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
