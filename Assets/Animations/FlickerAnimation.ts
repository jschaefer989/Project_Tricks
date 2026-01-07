import Asset from "Assets/Asset";
import Animation, { AnimationAssets, ConstructionOptions } from "./Animation";

export default class FlickerAnimation extends Animation {
  flickerInterval = 0.1; // Time between flickers
  flickerCount = 0;
  maxFlickers = 6; // Total number of visibility toggles

  constructor(
    animationAssets: AnimationAssets[],
    constructionOptions?: ConstructionOptions
  ) {
    super(animationAssets, constructionOptions);
  }

  updateAnimation(deltaTime: number): void {
    if (!this.isAnimating) {
      return;
    }

    this.animElapsed += deltaTime;

    // Calculate how many flickers have occurred
    const currentFlickers = Math.floor(this.animElapsed / this.flickerInterval);
    
    if (currentFlickers > this.flickerCount) {
      this.flickerCount = currentFlickers;
      // Toggle visibility on each flicker
      for (const asset of this.assets) {
        if (asset instanceof Asset) {
          asset.isHidden = !asset.isHidden;
        }
      }
    }

    if (this.animElapsed >= this.animDuration) {
      // Animation complete - ensure assets are visible
      this.animElapsed = this.animDuration;
      this.isAnimating = false;
      for (const asset of this.assets) {
        if (asset instanceof Asset) {
          asset.isHidden = false;
        }
      }
    }
  }
}
