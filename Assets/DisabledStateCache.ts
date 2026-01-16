import GameManager from "GameManager";
import Asset from "./Asset";
import { isEmpty } from "Helpers";

interface Cache {
  isDisabled: boolean;
  useDisabledAnimation: boolean;
  color: [number, number, number, number];
  showDisabledColor: boolean;
}

export default class DisabledStateCache {
    gameManager: GameManager;
  private cache = new Map<string, Cache>();

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  cacheState(asset: Asset): void {
    this.cache.set(asset.id, {
      isDisabled: asset.isDisabled,
      useDisabledAnimation: asset.useDisabledAnimation,
      color: asset.color,
      showDisabledColor: asset.showDisabledColor,
    });
  }

  restore(idsToSkip?: string[]): void {
    for (const [baseId, disabledState] of this.cache) {
          if (idsToSkip?.includes(baseId)) continue;
          const assets = this.gameManager.assetManager.assets.get(baseId);
          if (!isEmpty(assets)) {
            for (const asset of assets) {
              // Restore the color directly first
              asset.color = disabledState.color;
              // Then set disabled state without applying color changes
              asset.setDisabled(disabledState.isDisabled, {
                useDisabledAnimation: disabledState.useDisabledAnimation,
                showDisabledColor: disabledState.showDisabledColor,
              });
            }
          }
        }
        this.cache.clear();
  }
}
