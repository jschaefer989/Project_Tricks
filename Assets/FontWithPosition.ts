/** @noSelfInFile */

import { AlignMode, Image } from "love.graphics";
import TextManager from "./TextManager";
import { isEmpty } from "Helpers";

export enum Format {
    LEFT, 
    CENTER,
    RIGHT
}

export enum OutlineThickness {
    NONE = 0,
    THIN = 1,
    THICK = 2
}

interface ConstructionOptions {
  filepath?: string;
  size?: number; // Powers of 9 look really crisp
  format?: Format;
  icon?: Image;
  iconFormat?: Omit<Format, Format.CENTER>;
  isDisabled?: boolean;
  outlineThickness?: OutlineThickness;
  color?: [number, number, number, number];
  limit?: number;
  alignMode?: AlignMode;
}

export default class FontWithPosition {
  id: string;
  size?: number;
  filepath: string;
  x: number;
  y: number;
  text: string;
  format: Format;
  icon?: Image
  iconFormat: Omit<Format, Format.CENTER> = Format.LEFT;
  isDisabled: boolean = false;
  color: [number, number, number, number] = [1, 1, 1, 1];
  outlineThickness: OutlineThickness;
  limit?: number;
  alignMode?: AlignMode;

  constructor(
    id: string,
    x: number,
    y: number,
    text: string,
    options?: ConstructionOptions
  ) {
    this.id = id;
    this.size = options?.size;
    this.filepath = options?.filepath ?? TextManager.getDefaultFontFilepath();
    this.x = x;
    this.y = y;
    this.text = text;
    this.format = options?.format ?? Format.LEFT;
    this.icon = options?.icon;
    this.iconFormat = options?.iconFormat ?? (this.format === Format.CENTER ? Format.LEFT : this.format) as Omit<Format, Format.CENTER>;
    this.isDisabled = options?.isDisabled ?? false;
    this.outlineThickness = options?.outlineThickness ?? OutlineThickness.THIN;
    if (this.isDisabled) {
      this.setDisabled(true);
    }
    this.color = options?.color ?? [1, 1, 1, 1];
    this.limit = options?.limit;
    this.alignMode = options?.alignMode;
  }

  setDisabled(disabled: boolean): void {
    this.isDisabled = disabled;
    this.color = disabled ? [0.5, 0.5, 0.5, 1] : [1, 1, 1, 1];
  }

  printFont(): void {
    const font = !isEmpty(this.size)
      ? love.graphics.newFont(this.filepath, this.size)
      : love.graphics.newFont(this.filepath);
    love.graphics.setFont(font);

    const textW = font.getWidth(this.text);
    const textH = font.getHeight();
    const baseX = Math.floor(this.x - this.getFormatOffset(textW));
    const baseY = Math.floor(this.y - textH / 2);

    this.printOutline(baseX, baseY);

    love.graphics.setColor(this.color);
    !isEmpty(this.limit) ? love.graphics.printf(this.text, baseX, baseY, this.limit, this.alignMode ?? "left") : love.graphics.print(this.text, baseX, baseY);
    this.renderIcon();
  }

  private printOutline(x: number, y: number): void {
    if (this.outlineThickness === OutlineThickness.NONE) {
      return;
    }

    love.graphics.setColor(0, 0, 0, this.color[3]);
    const offsets = this.outlineThickness === OutlineThickness.THICK ? [-2, -1, 0, 1, 2] : [-1, 0, 1];
    for (const ox of offsets) {
      for (const oy of offsets) {
        if (ox === 0 && oy === 0) {
          continue;
        }
        love.graphics.print(this.text, x + ox, y + oy);
      }
    }
  }

  private getFormatOffset(textW: number): number {
    switch (this.format) {
      case Format.LEFT:
        return 0;
      case Format.CENTER:
        return textW / 2;
      case Format.RIGHT:
        // If there's an icon that will be rendered to the right, account for its width
        const iconWidth = (this.iconFormat === Format.RIGHT && !isEmpty(this.icon)) 
          ? this.icon.getWidth() 
          : 0;
        return textW + iconWidth;
      default:
        return 0;
    }
  }

  private renderIcon(): void {
    if (isEmpty(this.icon)) {
      return;
    }
    love.graphics.setColor(this.color);
    switch (this.iconFormat) {
      case Format.LEFT:
        love.graphics.draw(this.icon, this.x - this.icon.getWidth() - 1, this.y - (this.icon.getHeight() / 2));
        break;
      case Format.RIGHT:
        love.graphics.draw(this.icon, this.x - this.icon.getWidth() + 1, this.y - (this.icon.getHeight() / 2));
        break;
    }
  }
}
