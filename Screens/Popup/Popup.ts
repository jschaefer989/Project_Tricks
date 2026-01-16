import SlideAnimation from "Assets/Animations/SlideAnimation";
import Asset from "Assets/Asset";
import FontWithPosition, { Fonts, Format } from "Assets/Fonts/FontWithPosition";
import { AssetIds, TextIds } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard, isEmpty } from "Helpers";
import * as push from "Libraries.push";
import { Source } from "love.audio";
import { Image } from "love.graphics";
import DisabledStateCache from "Assets/DisabledStateCache";

export enum PopupSizes {
  MESSAGE_BOX = "MESSAGE_BOX",
  MENU = "MENU",
}

export interface PopupConstructionOptions {
  readonly onClose?: () => void;
  readonly animateIn?: boolean;
}

export default class Popup {
  gameManager: GameManager;
  id: string;
  isActive = true;
  associatedAssetIds: string[] = [];
  associatedTextIds: string[] = [];
  popupSize: PopupSizes;
  private savedMusicVolume: number = 1.0;
  private pausedAnimationIds: string[] = [];
  private disabledStateCache: DisabledStateCache;
  private pausedShaderIds: string[] = [];
  private pausedSources: Source[] = [];
  private pausedTextIds = new Map<string, boolean>();
  private onClose?: () => void;

  constructor(
    gameManager: GameManager,
    id: string,
    popupSize: PopupSizes,
    title: string,
    associatedAssetIds: string[],
    associatedTextIds: string[],
    options?: PopupConstructionOptions
  ) {
    this.gameManager = gameManager;
    this.id = id;
    this.popupSize = popupSize;
    this.associatedAssetIds = associatedAssetIds;
    this.associatedTextIds = associatedTextIds;
    this.disabledStateCache = new DisabledStateCache(this.gameManager);
    this.onClose = options?.onClose;
    this.buildCaches();
    this.disableAllAssets();
    this.disableAllText();
    this.lowerMusicVolume();

    this.pauseAllAnimations();
    this.pauseAllShaders();
    this.gameManager.assetManager.tooltipManager.hideTooltip();
    this.pausedSources = love.audio.pause();

    this.addTitle(title);
    this.buildPopup();
    if (options?.animateIn ?? true) {
      this.startSlideAnimation();
    }
  }

  close() {
    this.restoreMusicVolume();
    this.resumeAllAnimations();
    this.resumeAllShaders();
    this.enableAllAssets();
    this.enableAllText();
    this.playPausedSounds();

    this.removeAssets();
    this.removeTexts();
    this.onClose?.();
  }

  buildPopup(): void {
    const popupAsset = new Asset(
      this.gameManager,
      this.getPopupBackgroundId(),
      this.getPopupBackground(),
      (push.getWidth() - Popup.getPopupWidth(this.popupSize)) / 2,
      Popup.getTopOfPopup(this.popupSize),
      Popup.getPopupWidth(this.popupSize),
      Popup.getPopupHeight(this.popupSize)
    );

    this.gameManager.assetManager.addAsset(
      this.getPopupBackgroundId(),
      popupAsset
    );

    this.associatedAssetIds.push(this.getPopupBackgroundId());
  }

  getPopupBackground(): Image {
    switch (this.popupSize) {
      case PopupSizes.MESSAGE_BOX:
        return this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PopupMessageBox.png"
        );
      case PopupSizes.MENU:
        return this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PopupMenu.png"
        );
    }
  }

  startSlideAnimation() {
    const startY = push.getHeight();
    for (const id of this.associatedAssetIds) {
      const assets = this.gameManager.assetManager.assets.get(id);
      if (isEmpty(assets)) {
        continue;
      }
      for (const a of assets) {
        const finalY = a.y;
        a.y = startY;
        this.gameManager.animationManager.startAnimation(
          a.id,
          new SlideAnimation(
            this.gameManager,
            a.id,
            0.15,
            0,
            finalY - startY,
            [a],
            {
              bounceEffect: true,
            }
          )
        );
      }
    }
    for (const id of this.associatedTextIds) {
      const text = this.gameManager.assetManager.textManager.texts.get(id);
      if (isEmpty(text)) continue;
      const finalY = text.y;
      text.y = startY;
      this.gameManager.animationManager.startAnimation(
        text.id,
        new SlideAnimation(
          this.gameManager,
          text.id,
          0.15,
          0,
          finalY - startY,
          [text],
          {
            bounceEffect: true,
          }
        )
      );
    }
  }

  buildCaches() {
    for (const id of this.gameManager.animationManager.animations.keys()) {
      this.pausedAnimationIds.push(id);
    }
    for (const id of this.gameManager.shaderManager.shaders.keys()) {
      this.pausedShaderIds.push(id);
    }
    for (const [baseId, assets] of this.gameManager.assetManager.assets) {
      if (this.associatedAssetIds.includes(baseId)) continue;
      this.disabledStateCache.cacheState(assets[0]);
    }
    for (const [id, font] of this.gameManager.assetManager.textManager.texts) {
      if (this.associatedTextIds.includes(id)) continue;
      this.pausedTextIds.set(id, font.isDisabled);
    }
  }

  addTitle(title: string): void {
    const titleFont = new FontWithPosition(
      this.getPopupTitleId(),
      Popup.getCenterOfPopup(this.popupSize),
      Popup.getTopOfPopup(this.popupSize) + this.getTitleOffset(),
      title,
      { font: Fonts.FANTASY, size: 16, format: Format.CENTER }
    );
    this.gameManager.assetManager.textManager.addText(
      this.getPopupTitleId(),
      titleFont
    );
    this.associatedTextIds.push(this.getPopupTitleId());
  }

  getTitleOffset(): number {
    switch (this.popupSize) {
      case PopupSizes.MESSAGE_BOX:
        return 13;
      case PopupSizes.MENU:
        return 17;
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
    for (const [id, assets] of this.gameManager.assetManager.assets) {
      if (this.associatedAssetIds.includes(id)) continue;
      for (const asset of assets) {
        asset.setDisabled(true, {
          useDisabledAnimation: false,
          showDisabledColor: true,
        });
      }
    }
  }

  disableAllText() {
    for (const [id, font] of this.gameManager.assetManager.textManager.texts) {
      if (this.associatedTextIds.includes(id)) continue;
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
  }

  resumeAllShaders() {
    for (const id of this.pausedShaderIds) {
      const shader = this.gameManager.shaderManager.shaders.get(id);
      if (!isEmpty(shader)) {
        shader.isPaused = false;
      }
    }
  }

  enableAllAssets() {
    this.disabledStateCache.restore(this.associatedAssetIds);
  }

  enableAllText() {
    for (const [id, isDisabled] of this.pausedTextIds) {
      if (this.associatedTextIds.includes(id)) continue;
      const font = this.gameManager.assetManager.textManager.texts.get(id);
      if (!isEmpty(font)) {
        font.setDisabled(isDisabled);
      }
    }
  }

  playPausedSounds() {
    for (const source of this.pausedSources) {
      try {
        source.play();
      } catch (e) {
        // Source may no longer be valid, skip it
      }
    }
  }

  handleMousePressed(x: number, y: number, button: number): boolean {
    if (!this.isActive) return false;
    const [gameX, gameY] = push.toGame(x, y);
    if (isEmpty(gameX) || isEmpty(gameY)) return false;

    const asset = this.gameManager.assetManager.getAsset(
      this.getPopupBackgroundId(),
      this.getPopupBackgroundId()
    );
    if (isEmpty(asset)) return false;

    if (!asset.inAssetBounds(gameX, gameY)) {
      return true;
    }
    return false;
  }

  handleMouseReleased(x: number, y: number, button: number): boolean {
    if (!this.isActive) return false;
    const [gameX, gameY] = push.toGame(x, y);
    if (isEmpty(gameX) || isEmpty(gameY)) return false;

    const asset = this.gameManager.assetManager.getAsset(
      this.getPopupBackgroundId(),
      this.getPopupBackgroundId()
    );
    if (isEmpty(asset)) return false;

    if (!asset.inAssetBounds(gameX, gameY)) {
      this.gameManager.popupManager.close();
      return true;
    }
    return false;
  }

  drawPopup() {
    const asset = this.gameManager.assetManager.getAsset(
      this.getPopupBackgroundId(),
      this.getPopupBackgroundId()
    );
    asset?.drawAsset();
    for (const id of this.associatedAssetIds) {
      if (id === this.getPopupBackgroundId()) continue;
      const asset = this.gameManager.assetManager.getAssets(id);
      if (isEmpty(asset)) continue;
      for (const a of asset) {
        a.drawAsset();
      }
    }
    for (const id of this.associatedTextIds) {
      const text = this.gameManager.assetManager.textManager.texts.get(id);
      if (isEmpty(text)) continue;
      text.printText();
    }
  }

  removeAssets() {
    this.gameManager.assetManager.removeAssets(this.getPopupBackgroundId());
    for (const id of this.associatedAssetIds) {
      this.gameManager.assetManager.removeAssets(id);
    }
  }

  removeTexts() {
    for (const id of this.associatedTextIds) {
      this.gameManager.assetManager.textManager.hideText(id);
    }
  }

  static getPopupWidth(popupSize: PopupSizes): number {
    switch (popupSize) {
      case PopupSizes.MESSAGE_BOX:
        return 264;
      case PopupSizes.MENU:
        return 400;
      default:
        exhaustiveGuard(popupSize);
    }
  }

  static getPopupHeight(popupSize: PopupSizes): number {
    switch (popupSize) {
      case PopupSizes.MESSAGE_BOX:
        return 264;
      case PopupSizes.MENU:
        return 350;
      default:
        exhaustiveGuard(popupSize);
    }
  }

  static getTopOfPopup(popupSize: PopupSizes): number {
    return (push.getHeight() - Popup.getPopupHeight(popupSize)) / 2 - 5;
  }

  static getCenterOfPopup(popupSize: PopupSizes): number {
    const popupWidth = Popup.getPopupWidth(popupSize);
    return popupWidth / 2 + (push.getWidth() - popupWidth) / 2;
  }

  static getBottomOfPopup(popupSize: PopupSizes): number {
    return Popup.getTopOfPopup(popupSize) + Popup.getPopupHeight(popupSize);
  }

  getPopupBackgroundId(): string {
    return AssetIds.POPUP_BACKGROUND + this.id;
  }

  getPopupTitleId(): string {
    return TextIds.POPUP_TITLE + this.id;
  }
}
