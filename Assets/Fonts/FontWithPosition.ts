/** @noSelfInFile */

import { AlignMode, Font } from "love.graphics";
import { exhaustiveGuard, isEmpty } from "Helpers";
import IconAsset from "../IconAsset";

export enum Format {
  LEFT,
  CENTER,
  RIGHT,
}

export enum OutlineThickness {
  NONE = 0,
  THIN = 1,
  THICK = 2,
}

export enum Fonts {
  STANDARD = "Assets/Fonts/Germania.ttf",
  FANTASY = "Assets/Fonts/dpcomic.ttf",
  ELOQUENT = "Assets/Fonts/Bitmgothic.ttf",
}

export enum Highlights {
  HEARTS = "//HEARTS//",
  BELLS = "//BELLS//",
  ACORNS = "//ACORNS//",
  LEAVES = "//LEAVES//",
  EDEL = "//EDEL//",
}

interface ConstructionOptions {
  font?: Fonts;
  size?: number; // Powers of 9 look really crisp
  xLocation?: Format;
  icon?: IconAsset;
  iconFormat?: Omit<Format, Format.CENTER>;
  isDisabled?: boolean;
  outlineThickness?: OutlineThickness;
  color?: [number, number, number, number];
  limit?: number;
  alignMode?: Omit<Format, Format.RIGHT>;
}

export default class FontWithPosition {
  id: string;
  x: number;
  y: number;
  text: string;
  xLocation: Format;
  font: Font;
  icon?: IconAsset;
  iconFormat: Omit<Format, Format.CENTER> = Format.LEFT;
  isDisabled: boolean = false;
  color: [number, number, number, number] = [1, 1, 1, 1];
  outlineThickness: OutlineThickness;
  limit?: number;
  alignMode?: Omit<Format, Format.RIGHT>;

  constructor(
    id: string,
    x: number,
    y: number,
    text: string,
    options?: ConstructionOptions
  ) {
    const size = options?.size ?? 9;
    const font = options?.font ?? Fonts.STANDARD;
    this.font = love.graphics.newFont(font, size);

    this.id = id;
    this.x = x;
    this.y = y;
    this.text = text;

    this.xLocation = options?.xLocation ?? Format.LEFT;
    this.icon = options?.icon;
    this.iconFormat =
      options?.iconFormat ??
      ((this.xLocation === Format.CENTER ? Format.LEFT : this.xLocation) as Omit<
        Format,
        Format.CENTER
      >);
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

  printText(): void {
    love.graphics.setFont(this.font);

    const textW = this.font.getWidth(this.text);
    const textH = this.font.getHeight();
    const baseX = Math.floor(this.x - this.getFormatOffset(textW));
    const baseY = Math.floor(this.y - textH / 2);

    this.printOutline(baseX, baseY);

    // Parse text for highlights and render segments with appropriate colors
    const segments = this.parseHighlights(this.text);
    let currentX = baseX;

    // Handle centering for segments
    if (!isEmpty(this.limit) && this.alignMode === Format.CENTER) {
      const cleanText = this.stripHighlights(this.text);
      const totalWidth = this.font.getWidth(cleanText);
      currentX = baseX + (this.limit - totalWidth) / 2;
    }

    for (const segment of segments) {
      love.graphics.setColor(segment.color);
      love.graphics.print(segment.text, currentX, baseY);
      currentX += this.font.getWidth(segment.text);
    }

    this.renderIcon();
  }

  private parseHighlights(
    text: string
  ): Array<{ text: string; color: [number, number, number, number] }> {
    const segments: Array<{
      text: string;
      color: [number, number, number, number];
    }> = [];
    let remaining = text;
    let currentColor = this.color;

    while (remaining.length > 0) {
      // Check for highlight markers
      let foundHighlight = false;

      for (const highlight of Object.values(Highlights)) {
        if (remaining.startsWith(highlight)) {
          remaining = remaining.substring(highlight.length);
          // Extract next word without regex
          const result = this.extractNextWord(remaining);
          if (result.word.length > 0) {
            segments.push({
              text: result.word,
              color: this.getColorForHighlight(highlight),
            });
            remaining = remaining.substring(result.consumed);
            currentColor = this.color;
            foundHighlight = true;
            break;
          }
        }
      }

      if (!foundHighlight) {
        // Find next highlight marker or end of string
        let nextPos = remaining.length;

        for (const highlight of Object.values(Highlights)) {
          const pos = remaining.indexOf(highlight);
          if (pos !== -1) {
            nextPos = Math.min(nextPos, pos);
          }
        }

        const chunk = remaining.substring(0, nextPos);
        if (chunk.length > 0) {
          segments.push({
            text: chunk,
            color: currentColor,
          });
        }
        remaining = remaining.substring(nextPos);
      }
    }

    return segments.length > 0
      ? segments
      : [{ text: this.text, color: this.color }];
  }

  private extractNextWord(text: string): { word: string; consumed: number } {
    let i = 0;
    // Skip leading whitespace
    while (i < text.length && (text[i] === " " || text[i] === "\t" || text[i] === "\n")) {
      i++;
    }
    
    const wordStart = i;
    // Collect non-whitespace characters
    while (i < text.length && text[i] !== " " && text[i] !== "\t" && text[i] !== "\n") {
      i++;
    }
    
    return {
      word: text.substring(wordStart, i),
      consumed: i
    };
  }

  private textHasHighlights(text: string): boolean {
    for (const highlight of Object.values(Highlights)) {
      if (text.indexOf(highlight) !== -1) {
        return true;
      }
    }
    return false;
  }

  private stripHighlights(text: string): string {
    let result = text;
    for (const highlight of Object.values(Highlights)) {
      result = result.split(highlight).join("");
    }
    return result;
  }

  private printOutline(x: number, y: number): void {
    if (this.outlineThickness === OutlineThickness.NONE) {
      return;
    }

    const offsets =
      this.outlineThickness === OutlineThickness.THICK
        ? [-2, -1, 0, 1, 2]
        : [-1, 0, 1];

    const hasHighlights = this.textHasHighlights(this.text);

    love.graphics.setColor(0, 0, 0, this.color[3]);

    // If using word wrapping/centering and no highlights, use printf
    if (!isEmpty(this.limit) && !hasHighlights) {
      for (const ox of offsets) {
        for (const oy of offsets) {
          if (ox === 0 && oy === 0) {
            continue;
          }
          love.graphics.printf(
            this.text,
            x + ox,
            y + oy,
            this.limit,
            this.alignMode === Format.CENTER ? "center" : "left"
          );
        }
      }
    } else {
      // Render outline for each colored segment
      const segments = this.parseHighlights(this.text);
      let currentX = x;

      // Handle centering for segments
      if (!isEmpty(this.limit) && this.alignMode === Format.CENTER) {
        const cleanText = this.stripHighlights(this.text);
        const totalWidth = this.font.getWidth(cleanText);
        currentX = x + (this.limit - totalWidth) / 2;
      }

      for (const segment of segments) {
        love.graphics.setColor(0, 0, 0, segment.color[3]);
        for (const ox of offsets) {
          for (const oy of offsets) {
            if (ox === 0 && oy === 0) {
              continue;
            }
            love.graphics.print(segment.text, currentX + ox, y + oy);
          }
        }
        currentX += this.font.getWidth(segment.text);
      }
    }
  }

  private getFormatOffset(textW: number): number {
    switch (this.xLocation) {
      case Format.LEFT:
        return 0;
      case Format.CENTER:
        return textW / 2;
      case Format.RIGHT:
        // If there's an icon that will be rendered to the right, account for its width
        const iconWidth =
          this.iconFormat === Format.RIGHT && !isEmpty(this.icon)
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

    // TODO: handle other align modes and formats
    switch (this.iconFormat) {
      case Format.LEFT:
        if (this.alignMode === Format.CENTER) {
          love.graphics.draw(
            this.icon.image,
            this.x +
              this.limit! / 2 -
              this.font.getWidth(this.text) / 2 -
              this.icon!.getWidth() -
              2,
            this.y - this.icon.getHeight() / 2
          );
        } else {
          love.graphics.draw(
            this.icon.image,
            this.x - this.icon.getWidth() - 2,
            this.y - this.icon.getHeight() / 2
          );
        }
        break;
      case Format.RIGHT:
        love.graphics.draw(
          this.icon.image,
          this.x - this.icon.getWidth() + 1,
          this.y - this.icon.getHeight() / 2
        );
        break;
    }
  }

  private getColorForHighlight(marker: Highlights): [number, number, number, number] {
    switch (marker) {
      case Highlights.HEARTS:
        return [1, 0, 0, 1]; // Red color for hearts
      case Highlights.BELLS:
        return [1, 0.84, 0, 1];
      case Highlights.ACORNS:
        return [0.55, 0.27, 0.07, 1];
      case Highlights.LEAVES:
        return [0, 0.5, 0, 1]; // Dark green for leaves
      case Highlights.EDEL:
        return [1, 0.84, 0, 1]; // Gold color for edel
      default:
        exhaustiveGuard(marker);
    }
  }
}
