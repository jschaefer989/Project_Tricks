import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";
import GameManager from "GameManager";
import TextManager from "Assets/TextManager";
import WobbleAnimation from "./Animations/WobbleAnimation";

export default class AssetManager {
  gameManager: GameManager;
  assets: Map<string, Asset[]>;
  textManager: TextManager;
  disabledSound = love.audio.newSource("Assets/Sounds/Disabled.wav", "static");

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
    this.assets = new Map<string, Asset[]>();
    this.textManager = new TextManager();
  }

  addAsset(id: string, asset: Asset): void {
    if (this.assets.has(id)) {
      const assets = this.assets.get(id);
      assets?.push(asset);
      return;
    }
    this.assets.set(id, [asset]);
  }

  getAssets(baseId: string): Asset[] | undefined {
    return this.assets.get(baseId);
  }

  getAsset(baseId: string, assetId: string): Asset | undefined {
    return this.getAssets(baseId)?.find((asset) => asset.id === assetId);
  }

  hideAsset(id: string): void {
    this.assets.delete(id);
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

  drawAssets(): void {
    // Draw all assets
    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      for (const asset of assets) {
        love.graphics.setColor(asset.color);
        love.graphics.draw(
          asset.image,
          asset.x,
          asset.y,
          asset.orientation,
          asset.scaleX,
          asset.scaleY,
          asset.offsetX,
          asset.offsetY
        );
        love.graphics.setColor(1, 1, 1, 1);
      }
    }

    // Draw text above assets
    this.textManager.drawText();

    // Draw hover content above assets and text
    this.drawHoverables();
  }

  private drawHoverables(): void {
    for (const assets of this.assets.values()) {
      if (isEmpty(assets) || assets.length === 0) {
        continue;
      }
      const asset = assets[0]; // Assume hoverable is the same for all assets with the same ID
      if (asset.isHovered) {
        asset.onHover?.(this.gameManager, asset);
      }
    }
  }

  handleMousePressed(x: number, y: number, button: number): void {
    // const [gameX, gameY] = push.toGame(x, y)
    // if (isEmpty(gameX) || isEmpty(gameY)) {
    //     return
    // }
    // for (const asset of this.assets.values()) {
    //     if (gameX >= asset.x && gameX <= asset.x + asset.getWidth() &&
    //         gameY >= asset.y && gameY <= asset.y + asset.getHeight()) {
    //         asset.onClick()
    //     }
    // }
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
    }
  }

  handleDisabledAssetClick(assets: Asset[]): void {
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
          new WobbleAnimation(10, [assetToWobble], { animDuration: 0.5 })
        );
      }

      if (!isEmpty(assetToWobble.associatedTexts)) {
        for (const textId of assetToWobble.associatedTexts) {
          const textAsset = this.textManager.getText(textId);
          if (isEmpty(textAsset)) {
            continue;
          }
          const wobbleTextId = `wobble-${textId}`;
          if (!this.gameManager.animationManager.animations.has(wobbleTextId)) {
            this.gameManager.animationManager.animations.set(
              wobbleTextId,
              new WobbleAnimation(10, [textAsset], { animDuration: 0.5 })
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
        }
      } else if (asset.isHovered) {
        for (const a of assets) {
          a.setHovered(false);
        }
      }
    }
  }
}
