/** @noSelfInFile */

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
}

export default class FontWithPosition {
  size?: number;
  filepath: string;
  x: number;
  y: number;
  text: string;
  format: Format;

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
  }

  printFont(): void {
    const font = !isEmpty(this.size)
      ? love.graphics.newFont(this.filepath, this.size)
      : love.graphics.newFont(this.filepath);
    love.graphics.setFont(font);

    const textW = font.getWidth(this.text);
    const textH = font.getHeight();

    // Drop shadow then main text for readability
    love.graphics.setColor(0, 0, 0, 1);
    love.graphics.print(
      this.text,
      Math.floor(this.x - this.getFormatOffset(textW)) + 1,
      Math.floor(this.y - textH / 2) + 1
    );
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.print(
      this.text,
      Math.floor(this.x - this.getFormatOffset(textW)),
      Math.floor(this.y - textH / 2)
    );
  }

  getFormatOffset(textW: number): number {
    switch (this.format) {
      case Format.LEFT:
        return 0;
      case Format.CENTER:
        return textW / 2;
      case Format.RIGHT:
        return textW;
      default:
        return 0;
    }
  }
}
