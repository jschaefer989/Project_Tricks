import Asset from "Assets/Asset";
import Animation, { AnimationAssets, AnimationOptions } from "./Animation";

interface ConstructionOptions extends AnimationOptions {
  readonly glowStrength?: number;
  readonly glowPeriodSeconds?: number; // pulse period
}

export default class GlowAnimation extends Animation {
  private originalColors: Map<string, [number, number, number, number]> = new Map();
  private glowStrength = 2; // blend amount toward the glow color
  private pulsePeriod = 1.5; // seconds per glow pulse (slower pulse)

  constructor(stopCondition: () => boolean, assets: AnimationAssets[], constructionOptions?: ConstructionOptions) {
    super(assets, constructionOptions);
    this.storeOriginalColors(assets);
    this.glowStrength = constructionOptions?.glowStrength ?? this.glowStrength;
    this.pulsePeriod = constructionOptions?.glowPeriodSeconds ?? this.pulsePeriod;
    this.stopAnimationCondition = stopCondition;
  }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {
      this.restoreOriginalColors();
      return;
    }

    this.animElapsed += deltaTime;

    // Pulsing glow using a sine wave; slower via pulsePeriod
    const intensity = 0.5 + 0.5 * Math.sin((this.animElapsed / this.pulsePeriod) * Math.PI * 2);
    const blend = this.glowStrength * intensity; // how strongly we blend toward glowColor
    const glowColor: [number, number, number] = [1, 0.95, 0.6]; // warm gold tint
    const alphaBoost = 0.2 * intensity;

    for (const asset of this.assets) {
      if (asset instanceof Asset) {
        const original = this.originalColors.get(asset.id);
        if (original) {
          const [r, g, b, a] = original;
          // Lerp original color toward glowColor
          asset.color = [
            r * (1 - blend) + glowColor[0] * blend,
            g * (1 - blend) + glowColor[1] * blend,
            b * (1 - blend) + glowColor[2] * blend,
            Math.min(1, a + alphaBoost),
          ];
        }
      }
    }
  }

  private storeOriginalColors(assets: AnimationAssets[]): void {
    for (const asset of assets) {
      if (asset instanceof Asset) {
        this.originalColors.set(asset.id, [...asset.color]);
      }
    }
  }

  private restoreOriginalColors(): void {
    for (const asset of this.assets) {
      if (asset instanceof Asset) {
        const original = this.originalColors.get(asset.id);
        if (original) {
          asset.color = original;
        }
      }
    }
  }
}
