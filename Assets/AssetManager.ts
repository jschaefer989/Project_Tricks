import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";
import GameManager from "GameManager";
import TextManager from "Assets/Fonts/TextManager";
import WobbleAnimation from "./Animations/WobbleAnimation";
import TooltipManager from "./TooltipManager";

export default class AssetManager {
  gameManager: GameManager;
  assets: Map<string, Asset[]> = new Map<string, Asset[]>();
  tooltipManager: TooltipManager;
  textManager = new TextManager();
  disabledSound = love.audio.newSource("Assets/Sounds/Disabled.wav", "static");
  buttonClickSound = love.audio.newSource("Assets/Sounds/ButtonClick.mp3", "static");

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
    this.tooltipManager = new TooltipManager(gameManager);
  }

  addAsset(id: string, asset: Asset): void {
    if (this.assets.has(id)) {
      const assets = this.assets.get(id);
      assets?.push(asset);
    } else {
      this.assets.set(id, [asset]);
    }
  }

  getAssets(baseId: string): Asset[] | undefined {
    return this.assets.get(baseId);
  }

  getAsset(baseId: string, assetId: string): Asset | undefined {
    return this.getAssets(baseId)?.find((asset) => asset.id === assetId);
  }

  removeAssets(id: string): void {
    this.assets.delete(id);
  }

  removeAsset(baseId: string, assetId: string): void {
    const assets = this.getAssets(baseId);
    if (!isEmpty(assets)) {
      const index = assets.findIndex((asset) => asset.id === assetId);
      if (index !== -1) {
        assets.splice(index, 1);
      }
    }
  }

  disableAsset(baseId: string): void {
    const assets = this.getAssets(baseId);
    if (!isEmpty(assets)) {
      for (const asset of assets) {
        asset.setDisabled(true);
      }
    }
  }

  enableAsset(baseId: string): void {
    const assets = this.getAssets(baseId);
    if (!isEmpty(assets)) {
      for (const asset of assets) {
        asset.setDisabled(false);
      }
    }
  }

  hasAssets(baseId: string): boolean {
    return this.assets.has(baseId);
  }

  hasAsset(baseId: string, assetId: string): boolean {
    const assets = this.getAssets(baseId);
    if (isEmpty(assets)) {
      return false;
    }
    return assets.some((asset) => asset.id === assetId);
  }

  drawAssets(): void {
    // Draw all assets
    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      for (const asset of assets) {
        asset.drawAsset();
      }
    }

    // Draw text above assets
    this.textManager.drawText();

    // Draw hover content above assets and text
    this.tooltipManager.drawTooltips();
  }

  handleMousePressed(x: number, y: number, button: number): void {
    const [gameX, gameY] = push.toGame(x, y);
    if (isEmpty(gameX) || isEmpty(gameY)) {
      return;
    }
    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      const asset = assets[0]; // Assume click area is the same for all assets with the same ID

      if (asset.isHidden) {
        continue;
      }

      if (
        gameX >= asset.x &&
        gameX <= asset.x + asset.getWidth() &&
        gameY >= asset.y &&
        gameY <= asset.y + asset.getHeight()
      ) {
        for (const a of assets) {
          a.setMousePressed(true);
        }
      }
    }
  }

  handleMouseReleased(x: number, y: number, button: number): void {
    const [gameX, gameY] = push.toGame(x, y);

    if (isEmpty(gameX) || isEmpty(gameY)) {
      return;
    }

    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      const asset = assets[0]; // Assume click area is the same for all assets with the same ID

      if (asset.isHidden) {
        continue;
      }

      if (
        gameX >= asset.x &&
        gameX <= asset.x + asset.getWidth() &&
        gameY >= asset.y &&
        gameY <= asset.y + asset.getHeight()
      ) {
        if (asset.isDisabled) {
          this.handleDisabledAssetClick(assets);
        } else {
          this.handleAssetClick(asset);
        }
      }
      for (const a of assets) {
        a.setMousePressed(false);
      }
    }
  }

  handleDisabledAssetClick(assets: Asset[]): void {
    if (!assets[0].useDisabledAnimation) {
      return;
    }

    if (this.gameManager.animationManager.hasWobbleAnimation()) {
      return;
    }

    if (!this.disabledSound.isPlaying()) {
      this.disabledSound.play();
    }
    this.triggerWobbleAnimation(assets);
  }

  triggerWobbleAnimation(assets: Asset[]): void {
    for (const assetToWobble of assets) {
      const wobbleId = `wobble-${assetToWobble.id}`;
      if (!this.gameManager.animationManager.animations.has(wobbleId)) {
        this.gameManager.animationManager.animations.set(
          wobbleId,
          new WobbleAnimation(0.5, 10, [assetToWobble])
        );
      }

      if (!isEmpty(assetToWobble.associatedTexts)) {
        for (const text of assetToWobble.associatedTexts) {
          const wobbleTextId = `wobble-${text}`;
          if (!this.gameManager.animationManager.animations.has(wobbleTextId)) {
            this.gameManager.animationManager.animations.set(
              wobbleTextId,
              new WobbleAnimation(0.5, 10, [text])
            );
          }
        }
      }
    }
  }

  handleAssetClick(asset: Asset): void {
    asset.onClick?.();
    if (!asset.clickSound?.isPlaying()) {
      asset.clickSound?.play();
    }
  }

  handleMouseHover(): void {
    const [x, y] = love.mouse.getPosition();
    const [gameX, gameY] = push.toGame(x, y);

    if (isEmpty(gameX) || isEmpty(gameY)) {
      return;
    }

    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      const asset = assets[0]; // Assume hoverable is the same for all assets with the same ID

      if (asset.isDisabled || asset.isHidden) {
        continue;
      }

      if (
        gameX >= asset.x &&
        gameX <= asset.x + asset.getWidth() &&
        gameY >= asset.y &&
        gameY <= asset.y + asset.getHeight()
      ) {
        if (!asset.isHovered) {
          for (const a of assets) {
            a.setHovered(true);
          }
          asset.onHover?.(asset);
        }
      } else if (asset.isHovered) {
        for (const a of assets) {
          a.setHovered(false);
        }
        asset.onUnhover?.(asset);
      }
    }
  }
}
