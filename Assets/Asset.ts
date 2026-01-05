import GameManager from "GameManager";
import { Source } from "love.audio";
import { Font, Image } from "love.graphics";
import FontWithPosition from "./FontWithPosition";

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

  setHovered(hovered: boolean): void {
    this.isHovered = hovered;
  }

  setDisabled(disabled: boolean): void {
    this.isDisabled = disabled;
    this.color = disabled ? [0.5, 0.5, 0.5, 1] : [1, 1, 1, 1];
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
