import GameManager from "GameManager";
import { Source } from "love.audio";
import { Font, Image } from "love.graphics";
import FontWithPosition from "./FontWithPosition";
import { HoverEffects, MousePressEffects } from "Enums";
import { exhaustiveGuard } from "Helpers";

export type AssetCallback = (gameManager: GameManager, asset: Asset) => void;

interface ConstructionOptions {
  readonly onClick?: () => void;
  readonly onHover?: AssetCallback;
  readonly orientation?: number;
  readonly scaleX?: number;
  readonly scaleY?: number;
  readonly offsetX?: number;
  readonly offsetY?: number;
  readonly isDisabled?: boolean;
  readonly clickSound?: Source;
  readonly associatedTexts?: string[];
  readonly hoverEffect?: HoverEffects;
  readonly mousePressEffect?: MousePressEffects;
}

export default class Asset {
  id: string;
  image: Image;
  x: number;
  y: number;
  onClick?: () => void;
  onHover?: AssetCallback;
  orientation: number;
  scaleX: number;
  scaleY: number;
  offsetX: number;
  offsetY: number;
  isDisabled: boolean = false;
  isHovered: boolean = false;
  color: [number, number, number, number] = [1, 1, 1, 1];
  clickSound?: Source;
  associatedTexts?: string[];
  hoverEffect: HoverEffects;
  mousePressEffect: MousePressEffects;

  constructor(
    id: string,
    image: Image,
    x: number,
    y: number,
    constructionOptions?: ConstructionOptions
  ) {
    this.id = id;
    this.image = image;
    this.x = x;
    this.y = y;
    this.onClick = constructionOptions?.onClick;
    this.onHover = constructionOptions?.onHover;
    this.orientation = constructionOptions?.orientation ?? 0;
    this.scaleX = constructionOptions?.scaleX ?? 1;
    this.scaleY = constructionOptions?.scaleY ?? 1;
    this.offsetX = constructionOptions?.offsetX ?? 0;
    this.offsetY = constructionOptions?.offsetY ?? 0;
    this.isDisabled = constructionOptions?.isDisabled ?? false;
    this.clickSound = constructionOptions?.clickSound;
    this.associatedTexts = constructionOptions?.associatedTexts;
    this.hoverEffect = constructionOptions?.hoverEffect ?? HoverEffects.NONE;
    this.mousePressEffect = constructionOptions?.mousePressEffect ?? MousePressEffects.NONE;
  }

  updatePosition(x: number, y: number): void {
    this.x = x;
    this.y = y;
  }

  setHovered(hovered: boolean): void {
    this.isHovered = hovered;
    switch (this.hoverEffect) {
      case HoverEffects.NONE:
        break;
      case HoverEffects.CHANGE_COLOR:
        this.setColor();
        break;
      case HoverEffects.SCALE_UP:
        if (hovered) {
          const imgWidth = this.image.getWidth();
          const imgHeight = this.image.getHeight();
          const oldWidth = imgWidth * this.scaleX;
          const oldHeight = imgHeight * this.scaleY;
          
          this.scaleX *= 1.06;
          this.scaleY *= 1.06;
          
          const newWidth = imgWidth * this.scaleX;
          const newHeight = imgHeight * this.scaleY;
          
          // Adjust offsets to keep the asset centered
          this.offsetX += (newWidth - oldWidth) / 2;
          this.offsetY += (newHeight - oldHeight) / 2;
        } else {
          const imgWidth = this.image.getWidth();
          const imgHeight = this.image.getHeight();
          const oldWidth = imgWidth * this.scaleX;
          const oldHeight = imgHeight * this.scaleY;
          
          this.scaleX /= 1.06;
          this.scaleY /= 1.06;
          
          const newWidth = imgWidth * this.scaleX;
          const newHeight = imgHeight * this.scaleY;
          
          // Adjust offsets to keep the asset centered
          this.offsetX += (newWidth - oldWidth) / 2;
          this.offsetY += (newHeight - oldHeight) / 2;
        }
        break;
      default:
        exhaustiveGuard(this.hoverEffect);
    }
  }

  setDisabled(disabled: boolean): void {
    this.isDisabled = disabled;
    this.setColor();
  }

  setColor(): void {
    if (this.isDisabled) {
      this.color = [0.5, 0.5, 0.5, 1];
    } else if (this.isHovered) {
      this.color = [0.8, 0.8, 1, 1];
    } else {
      this.color = [1, 1, 1, 1];
    }
  }

  getWidth(): number {
    const imgWidth = this.image.getWidth();
    return imgWidth * Math.abs(this.scaleX);
  }

  getHeight(): number {
    const imgHeight = this.image.getHeight();
    return imgHeight * Math.abs(this.scaleY);
  }
}
