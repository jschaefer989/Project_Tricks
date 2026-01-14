import { isEmpty } from "Helpers";
import Asset from "../Asset";
import FontWithPosition from "Assets/Fonts/FontWithPosition";

export interface AnimationOptions {
  readonly animDuration?: number;
  readonly onFinish?: () => void;
  readonly waitForAnimationIds?: string[];
  readonly stopAnimationCondition?: () => boolean;
}

export type AnimationAssets = Asset | FontWithPosition;

export default abstract class Animation {
  animDuration?: number;
  animElapsed = 0;
  isAnimating = false;
  assets: AnimationAssets[];
  originalX: Map<string, number> = new Map<string, number>();
  originalY: Map<string, number> = new Map<string, number>();
  onFinish?: () => void;
  waitForAnimationIds: string[];
  stopAnimationCondition?: () => boolean;

  constructor(
    assets: AnimationAssets[],
    constructionOptions?: AnimationOptions
  ) {
    this.animDuration = constructionOptions?.animDuration;
    this.animElapsed = 0;
    this.isAnimating = true;
    this.assets = assets;
    this.originalX = new Map(assets.map((asset) => [asset.id, asset.x]));
    this.originalY = new Map(assets.map((asset) => [asset.id, asset.y]));
    this.onFinish = constructionOptions?.onFinish;
    this.waitForAnimationIds = constructionOptions?.waitForAnimationIds ?? [];
    this.stopAnimationCondition = constructionOptions?.stopAnimationCondition;
  }

  updateAnimation(deltaTime: number): void {
    if (!this.isAnimating) {
      return;
    }

    if (this.stopAnimationCondition && this.stopAnimationCondition()) {
      this.isAnimating = false;
      return;
    }

    this.animElapsed += deltaTime;
    
    if (!isEmpty(this.animDuration) &&this.animElapsed >= this.animDuration) {
      // Animation complete
      this.animElapsed = this.animDuration;
      this.isAnimating = false;
    }
  }

  get isFinished(): boolean {
    return !this.isAnimating;
  }

  getAssets(): AnimationAssets[] {
    return this.assets;
  }

  updateX(deltaX: number): void {
    this.assets.forEach((asset) => {
      const originalX = this.originalX.get(asset.id);
      if (originalX !== undefined) {
        asset.x = originalX + deltaX;
      }
    });
  }

  updateY(deltaY: number): void {
    this.assets.forEach((asset) => {
      const originalY = this.originalY.get(asset.id);
      if (originalY !== undefined) {
        asset.y = originalY + deltaY;
      }
    });
  }
}
