import GameManager from "GameManager";
import { Image } from "love.graphics";

export type AssetCallback = (gameManager: GameManager, asset: Asset) => void;

interface ConstructionOptions {
  readonly onClick?: () => void;
  readonly onHover?: AssetCallback;
  readonly orientation?: number;
  readonly scaleX?: number;
  readonly scaleY?: number;
  readonly offsetX?: number;
  readonly offsetY?: number;
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
  }

  updatePosition(x: number, y: number): void {
    this.x = x;
    this.y = y;
  }

  updateOrientation(orientation: number): void {
    this.orientation = orientation;
  }

  updateScale(scaleX: number, scaleY: number): void {
    this.scaleX = scaleX;
    this.scaleY = scaleY;
  }

  updateOffset(offsetX: number, offsetY: number): void {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
  }

  setDisabled(disabled: boolean): void {
    this.isDisabled = disabled;
  }

  setHovered(hovered: boolean): void {
    this.isHovered = hovered;
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
