/** @noSelfInFile */

import { Image } from "love.graphics";
import TextManager from "./TextManager";
import { isEmpty } from "Helpers";

export enum Format {
    LEFT, 
    CENTER,
    RIGHT
}

interface ConstructionOptions {
  filepath?: string;
  size?: number;
  format?: Format;
  icon?: Image;
  iconFormat?: Omit<Format, Format.CENTER>;
}

export default class FontWithPosition {
  size?: number;
  filepath: string;
  x: number;
  y: number;
  text: string;
  format: Format;
  icon?: Image
  iconFormat: Omit<Format, Format.CENTER> = Format.LEFT;

  constructor(
    x: number,
    y: number,
    text: string,
    options?: ConstructionOptions
  ) {
    this.size = options?.size;
    this.filepath = options?.filepath ?? TextManager.getDefaultFontFilepath();
    this.x = x;
    this.y = y;
    this.text = text;
    this.format = options?.format ?? Format.LEFT;
    this.icon = options?.icon;
    this.iconFormat = options?.iconFormat ?? (this.format === Format.CENTER ? Format.LEFT : this.format) as Omit<Format, Format.CENTER>;
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

    // Thicker outline for readability on light backgrounds
    love.graphics.setColor(0, 0, 0, 1);
    const offsets = [-2, -1, 0, 1, 2];
    for (const ox of offsets) {
      for (const oy of offsets) {
        if (ox === 0 && oy === 0) {
          continue;
        }
        love.graphics.print(this.text, baseX + ox, baseY + oy);
      }
    }

    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.print(this.text, baseX, baseY);
    this.renderIcon();
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
          ? this.icon.getWidth() + 5 
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
    switch (this.iconFormat) {
      case Format.LEFT:
        love.graphics.draw(this.icon, this.x - this.icon.getWidth() - 5, this.y - (this.icon.getHeight() / 2) + 2);
        break;
      case Format.RIGHT:
        love.graphics.draw(this.icon, this.x - this.icon.getWidth(), this.y - (this.icon.getHeight() / 2) + 2);
        break;
    }
  }
}
