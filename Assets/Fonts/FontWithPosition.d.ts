/** @noSelfInFile */
import { Font } from "love.graphics";
import IconAsset from "../IconAsset";
export declare enum Format {
    LEFT = 0,
    CENTER = 1,
    RIGHT = 2
}
export declare enum OutlineThickness {
    NONE = 0,
    THIN = 1,
    THICK = 2
}
export declare enum Fonts {
    STANDARD = "Assets/Fonts/Germania.ttf",
    FANTASY = "Assets/Fonts/dpcomic.ttf",
    ELOQUENT = "Assets/Fonts/Bitmgothic.ttf"
}
export declare enum Highlights {
    HEARTS = "//HEARTS//",
    BELLS = "//BELLS//",
    ACORNS = "//ACORNS//",
    LEAVES = "//LEAVES//",
    EDEL = "//EDEL//"
}
interface ConstructionOptions {
    font?: Fonts;
    size?: number;
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
    iconFormat: Omit<Format, Format.CENTER>;
    isDisabled: boolean;
    color: [number, number, number, number];
    outlineThickness: OutlineThickness;
    limit?: number;
    alignMode?: Omit<Format, Format.RIGHT>;
    constructor(id: string, x: number, y: number, text: string, options?: ConstructionOptions);
    setDisabled(disabled: boolean): void;
    printText(): void;
    private parseHighlights;
    private extractNextWord;
    private textHasHighlights;
    private stripHighlights;
    private printOutline;
    private getFormatOffset;
    private renderIcon;
    private getColorForHighlight;
}
export {};
