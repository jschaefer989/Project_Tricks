import { HoverEffects, MousePressEffects } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard, isEmpty } from "Helpers";
import { Source } from "love.audio";
import { Image } from "love.graphics";
import ShimmerShader from "Shaders/ShimmerShader";
import WobbleAnimation from "./Animations/WobbleAnimation";
import FontWithPosition from "./Fonts/FontWithPosition";
import QuadWithPosition from "./QuadWithPosition";

export type AssetCallback = (asset: Asset) => void;

export const disabledColor: [number, number, number, number] = [0.5, 0.5, 0.5, 1];
export const normalColor: [number, number, number, number] = [1, 1, 1, 1];

export interface ConstructionOptions {
  readonly onClick?: () => void;
  readonly onHover?: AssetCallback;
  readonly onUnhover?: AssetCallback;
  readonly orientation?: number;
  readonly scaleX?: number;
  readonly scaleY?: number;
  readonly offsetX?: number;
  readonly offsetY?: number;
  readonly quads?: QuadWithPosition[];
  readonly isDisabled?: boolean;
  readonly useDisabledAnimation?: boolean;
  readonly clickSound?: Source;
  readonly hoverSound?: Source;
  readonly associatedTexts?: FontWithPosition[];
  readonly hoverEffect?: HoverEffects[];
  readonly mousePressEffect?: MousePressEffects[];
  readonly alwaysEnabled?: boolean; // Only used in disableAllClickableAssets
  readonly showDisabledColor?: boolean;
}

export default class Asset {
  gameManager: GameManager;
  id: string;
  image: Image;
  x: number;
  y: number;
  width: number;
  height: number;
  onClick?: () => void;
  onHover?: AssetCallback;
  onUnhover?: AssetCallback;
  orientation: number;
  scaleX: number;
  scaleY: number;
  offsetX: number;
  offsetY: number;
  quads: QuadWithPosition[] = [];
  isDisabled = false;
  useDisabledAnimation = true;
  isHovered = false;
  isPressed = false;
  color: [number, number, number, number] = [1, 1, 1, 1];
  clickSound?: Source;
  hoverSound?: Source;
  associatedTexts?: FontWithPosition[];
  hoverEffect: HoverEffects[];
  mousePressEffect: MousePressEffects[];
  isHidden = false;
  alwaysEnabled = false; // Only used in disableAllClickableAssets
  showDisabledColor = true;

  constructor(
    gameManager: GameManager,
    id: string,
    image: Image,
    x: number,
    y: number,
    width: number,
    height: number,
    constructionOptions?: ConstructionOptions
  ) {
    this.gameManager = gameManager;
    this.id = id;
    this.image = image;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.onClick = constructionOptions?.onClick;
    this.onHover = constructionOptions?.onHover;
    this.onUnhover = constructionOptions?.onUnhover;
    this.orientation = constructionOptions?.orientation ?? 0;
    this.scaleX = constructionOptions?.scaleX ?? 1;
    this.scaleY = constructionOptions?.scaleY ?? 1;
    this.offsetX = constructionOptions?.offsetX ?? 0;
    this.offsetY = constructionOptions?.offsetY ?? 0;
    this.quads = constructionOptions?.quads ?? [];
    this.isDisabled = constructionOptions?.isDisabled ?? false;
    this.useDisabledAnimation =
      constructionOptions?.useDisabledAnimation ?? true;
    this.clickSound = constructionOptions?.clickSound;
    this.hoverSound = constructionOptions?.hoverSound;
    this.associatedTexts = constructionOptions?.associatedTexts;
    this.hoverEffect = constructionOptions?.hoverEffect ?? [HoverEffects.NONE];
    this.mousePressEffect = constructionOptions?.mousePressEffect ?? [
      MousePressEffects.NONE,
    ];
    this.alwaysEnabled = constructionOptions?.alwaysEnabled ?? false;
    this.showDisabledColor = constructionOptions?.showDisabledColor ?? true;
  }

  drawAsset(): void {
    if (this.isHidden) {
      return;
    }

    love.graphics.setColor(this.color);
    this.gameManager.shaderManager.applyShaders(this);

    if (this.quads.length > 0) {
      for (const quad of this.quads) {
        love.graphics.draw(
          this.image,
          quad.quad,
          this.x + quad.x,
          this.y + quad.y,
          this.orientation,
          this.scaleX,
          this.scaleY,
          this.offsetX,
          this.offsetY
        );
      }
    } else {
      love.graphics.draw(
        this.image,
        this.x,
        this.y,
        this.orientation,
        this.scaleX,
        this.scaleY,
        this.offsetX,
        this.offsetY
      );
    }

    this.gameManager.shaderManager.removeShaders();
    love.graphics.setColor(1, 1, 1, 1);
  }

  updatePosition(x: number, y: number): void {
    this.x = x;
    this.y = y;
  }

  setHovered(hovered: boolean): void {
    this.isHovered = hovered;
    this.handleHoverEffects(hovered);
  }

  private handleHoverEffects(hovered: boolean): void {
    for (const effect of this.hoverEffect) {
      switch (effect) {
        case HoverEffects.NONE:
          break;
        case HoverEffects.CHANGE_COLOR:
          this.setColor();
          break;
        case HoverEffects.SCALE_UP:
          // Warning, this can cause pixel distortion
          this.scaleUp(hovered);
          break;
        case HoverEffects.SHIFT_UP:
          this.shiftUp(hovered);
          break;
        case HoverEffects.SHIMMER:
          this.shimmer(hovered);
          break;
        case HoverEffects.WOBBLE:
          this.wobble(hovered);
          break;
        default:
          exhaustiveGuard(effect);
      }
    }
  }

  setMousePressed(pressed: boolean): void {
    const wasPressed = this.isPressed;
    this.isPressed = pressed;
    this.handleMousePressEffects(pressed, wasPressed);
  }

  private handleMousePressEffects(pressed: boolean, wasPressed: boolean): void {
    for (const effect of this.mousePressEffect) {
      switch (effect) {
        case MousePressEffects.NONE:
          break;
        case MousePressEffects.DARKEN:
          this.setColor();
          break;
        case MousePressEffects.SCALE_DOWN:
          // Warning, this can cause pixel distortion
          this.scaleDown(pressed);
          break;
        case MousePressEffects.SHIFT_DOWN:
          this.shiftDown(pressed, wasPressed);
          break;
        default:
          exhaustiveGuard(effect);
      }
    }
  }

  setDisabled(disabled: boolean, options?: DisabledAssetOptions): void {
    this.isDisabled = disabled;    
    this.useDisabledAnimation = options?.useDisabledAnimation ?? true;

    if (disabled) {
      if (!this.showDisabledColor && !options?.showDisabledColor) {
        return;
      }

      this.color = disabledColor;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.setDisabled(true);
        }
      }
    } else {
      this.color = normalColor;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.setDisabled(false);
        }
      }
    }

    this.color = options?.color ?? this.color;
  }

  setColor(): void {
    if (this.isDisabled) {
      this.color = disabledColor;
    } else if (this.isPressed) {
      this.color = [0.7, 0.6, 0.4, 1];
    } else if (this.isHovered) {
      this.color = [1, 0.9, 0.7, 1];
    } else {
      this.color = normalColor;
    }
  }

  getWidth(): number {
    return this.width;
  }

  getHeight(): number {
    return this.height;
  }

  private scaleDown(pressed: boolean): void {
    if (pressed) {
      this.scaleX *= 0.95;
      this.scaleY *= 0.95;
    } else {
      this.scaleX /= 0.95;
      this.scaleY /= 0.95;
    }
  }

  private scaleUp(hovered: boolean): void {
    if (hovered) {
      const imgWidth = this.getWidth();
      const imgHeight = this.getHeight();
      const oldWidth = imgWidth * this.scaleX;
      const oldHeight = imgHeight * this.scaleY;

      this.scaleX *= 1.05;
      this.scaleY *= 1.05;

      const newWidth = imgWidth * this.scaleX;
      const newHeight = imgHeight * this.scaleY;

      // Adjust offsets to keep the asset centered
      this.offsetX += (newWidth - oldWidth) / 2;
      this.offsetY += (newHeight - oldHeight) / 2;
    } else {
      const imgWidth = this.getWidth();
      const imgHeight = this.getHeight();
      const oldWidth = imgWidth * this.scaleX;
      const oldHeight = imgHeight * this.scaleY;

      this.scaleX /= 1.05;
      this.scaleY /= 1.05;

      const newWidth = imgWidth * this.scaleX;
      const newHeight = imgHeight * this.scaleY;

      // Adjust offsets to keep the asset centered
      this.offsetX += (newWidth - oldWidth) / 2;
      this.offsetY += (newHeight - oldHeight) / 2;
    }
  }

  private shiftDown(pressed: boolean, wasPressed: boolean): void {
    if (pressed) {
      this.offsetY -= 3;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.y += 3;
        }
      }
    } else if (wasPressed) {
      this.offsetY += 3;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.y -= 3;
        }
      }
    }
  }

  private shiftUp(hovered: boolean): void {
    if (hovered) {
      this.offsetY += 3;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.y -= 3;
        }
      }
    } else if (!hovered) {
      this.offsetY -= 3;
      if (!isEmpty(this.associatedTexts)) {
        for (const text of this.associatedTexts) {
          text.y += 3;
        }
      }
    }
  }

  private shimmer(hovered: boolean): void {
    if (!hovered) return;
    
    this.gameManager.shaderManager.addShader(
      this.id,
      new ShimmerShader(this.gameManager, () => !this.isHovered, [this])
    );
  }

  private wobble(hovered: boolean): void {
    if (!hovered) return;
    
    if (!this.gameManager.animationManager.animations.has(this.id)) {
      this.gameManager.animationManager.startAnimation(
        this.id,
        new WobbleAnimation(this.gameManager, this.id, 0.2, 2, [this])
      );
    }
  }

  inAssetBounds(gameX: number, gameY: number): boolean {
    return (
      gameX >= this.x &&
      gameX <= this.x + this.getWidth() &&
      gameY >= this.y &&
      gameY <= this.y + this.getHeight()
    );
  }
}

interface DisabledAssetOptions {
  readonly useDisabledAnimation?: boolean;
  readonly color?: [number, number, number, number];
  readonly showDisabledColor?: boolean;
}
