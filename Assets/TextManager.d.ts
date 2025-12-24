import FontWithPosition from "./FontWithPosition";
import { Font } from "love.graphics";
export default class FontManager {
    texts: Map<string, FontWithPosition>;
    constructor();
    drawText(): void;
    addText(id: string, font: FontWithPosition): void;
    getText(id: string): FontWithPosition | undefined;
    hideAsset(id: string): void;
    static getDefaultFontFilepath(): string;
    static setDefaultFont(): Font;
}
