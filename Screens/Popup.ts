import Asset from "Assets/Asset";
import { DisabledStateCache } from "Assets/AssetManager";
import FontWithPosition from "Assets/Fonts/FontWithPosition";
import { AssetIds } from "Enums";
import GameManager from "GameManager";
import { isEmpty } from "Helpers";
import * as push from "Libraries.push";
import { Source } from "love.audio";

type PopupAssets = Asset | FontWithPosition;

export default class Popup {
  gameManager: GameManager;
  isOpen = false;
  associatedAssets: PopupAssets[] = [];
  private savedMusicVolume: number = 1.0;
  private pausedAnimationIds: string[] = [];
  private pausedAssetIds = new Map<string, DisabledStateCache>();
  private pausedShaderIds: string[] = [];
  private pausedSources: Source[] = [];
  private pausedTextIds = new Map<string, boolean>();
  private popupBackground = love.graphics.newImage("Assets/Images/Popup.png");

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  open(associatedAssets: PopupAssets[]) {
    this.associatedAssets = associatedAssets;
    this.buildCaches();
    this.pauseAllAnimations();
    this.pauseAllShaders();
    this.disableAllAssets();
    this.lowerMusicVolume();
    this.disableAllText();
    this.gameManager.assetManager.tooltipManager.hideTooltip();
    this.pausedSources = love.audio.pause();

    const popupWidth = 400;
    const popupHeight = 350;
    this.gameManager.assetManager.addAsset(
      AssetIds.POPUP_BACKGROUND,
      new Asset(
        this.gameManager,
        AssetIds.POPUP_BACKGROUND,
        this.popupBackground,
        (push.getWidth() - popupWidth) / 2,
        (push.getHeight() - popupHeight) / 2,
        popupWidth,
        popupHeight
      )
    );
    this.isOpen = true;
  }

  close() {
    this.restoreMusicVolume();
    this.resumeAllAnimations();
    this.resumeAllShaders();
    this.enableAllAssets();
    this.enableAllText();
    this.playPausedSounds();

    this.gameManager.assetManager.removeAssets(AssetIds.POPUP_BACKGROUND);
    this.isOpen = false;
  }

  buildCaches() {
    for (const id of this.gameManager.animationManager.animations.keys()) {
      this.pausedAnimationIds.push(id);
    }
    for (const id of this.gameManager.shaderManager.shaders.keys()) {
      this.pausedShaderIds.push(id);
    }
    for (const [baseId, assets] of this.gameManager.assetManager.assets) {
      this.pausedAssetIds.set(baseId, {
        isDisabled: assets[0].isDisabled,
        useDisabledAnimation: assets[0].useDisabledAnimation,
      });
    }
    for (const [id, font] of this.gameManager.assetManager.textManager.texts) {
      this.pausedTextIds.set(id, font.isDisabled);
    }
  }

  pauseAllAnimations() {
    for (const animation of this.gameManager.animationManager.animations.values()) {
      animation.isPaused = true;
    }
  }

  pauseAllShaders() {
    for (const shader of this.gameManager.shaderManager.shaders.values()) {
      shader.isPaused = true;
    }
  }

  disableAllAssets() {
    for (const assets of this.gameManager.assetManager.assets.values()) {
      for (const asset of assets) {
        asset.setDisabled(true, {
          useDisabledAnimation: false,
          showDisabledColor: true,
        });
      }
    }
  }

  disableAllText() {
    for (const font of this.gameManager.assetManager.textManager.texts.values()) {
      font.setDisabled(true);
    }
  }

  lowerMusicVolume() {
    this.savedMusicVolume = love.audio.getVolume();
    love.audio.setVolume(this.savedMusicVolume * 0.3);
  }

  restoreMusicVolume() {
    love.audio.setVolume(this.savedMusicVolume);
  }

  resumeAllAnimations() {
    for (const id of this.pausedAnimationIds) {
      const animation = this.gameManager.animationManager.animations.get(id);
      if (!isEmpty(animation)) {
        animation.isPaused = false;
      }
    }
    this.pausedAnimationIds = [];
  }

  resumeAllShaders() {
    for (const id of this.pausedShaderIds) {
      const shader = this.gameManager.shaderManager.shaders.get(id);
      if (!isEmpty(shader)) {
        shader.isPaused = false;
      }
    }
    this.pausedShaderIds = [];
  }

  enableAllAssets() {
    for (const [baseId, disabledState] of this.pausedAssetIds) {
      const assets = this.gameManager.assetManager.getAssets(baseId);
      if (!isEmpty(assets)) {
        for (const asset of assets) {
          asset.setDisabled(disabledState.isDisabled, {
            useDisabledAnimation: disabledState.useDisabledAnimation,
          });
        }
      }
    }
    this.pausedAssetIds.clear();
  }

  enableAllText() {
    for (const [id, isDisabled] of this.pausedTextIds) {
      const font = this.gameManager.assetManager.textManager.texts.get(id);
      if (!isEmpty(font)) {
        font.setDisabled(isDisabled);
      }
    }
    this.pausedTextIds.clear();
  }

  playPausedSounds() {
    for (const source of this.pausedSources) {
      try {
        source.play();
      } catch (e) {
        // Source may no longer be valid, skip it
      }
    }
    this.pausedSources = [];
  }

  drawPopup() {
    if (!this.gameManager.popup.isOpen) return;
    const asset = this.gameManager.assetManager.getAsset(
      AssetIds.POPUP_BACKGROUND,
      AssetIds.POPUP_BACKGROUND
    );
    asset?.drawAsset();
    for (const asset of this.associatedAssets) {
      if (asset instanceof Asset) {
        asset.drawAsset();
      } else if (asset instanceof FontWithPosition) {
        asset.printText();
      }
    }
  }

  handleMousePressed(x: number, y: number, button: number): boolean {
    if (!this.gameManager.popup.isOpen) return false;

    const [gameX, gameY] = push.toGame(x, y);
    if (isEmpty(gameX) || isEmpty(gameY)) return false;

    const asset = this.gameManager.assetManager.getAsset(
      AssetIds.POPUP_BACKGROUND,
      AssetIds.POPUP_BACKGROUND
    );
    if (isEmpty(asset)) return false;

    if (!asset.inAssetBounds(gameX, gameY)) {
      return true;
    }
    return false;
  }

  handleMouseReleased(x: number, y: number, button: number): boolean {
    if (!this.gameManager.popup.isOpen) return false;

    const [gameX, gameY] = push.toGame(x, y);
    if (isEmpty(gameX) || isEmpty(gameY)) return false;

    const asset = this.gameManager.assetManager.getAsset(
      AssetIds.POPUP_BACKGROUND,
      AssetIds.POPUP_BACKGROUND
    );
    if (isEmpty(asset)) return false;

    if (!asset.inAssetBounds(gameX, gameY)) {
      this.close();
      return true;
    }
    return false;
  }
}
