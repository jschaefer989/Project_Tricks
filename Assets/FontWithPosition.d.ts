/** @noSelfInFile */
import { AlignMode, Image } from "love.graphics";
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
interface ConstructionOptions {
    filepath?: string;
    size?: number;
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
    icon?: Image;
    iconFormat: Omit<Format, Format.CENTER>;
    isDisabled: boolean;
    color: [number, number, number, number];
    outlineThickness: OutlineThickness;
    limit?: number;
    alignMode?: AlignMode;
    constructor(id: string, x: number, y: number, text: string, options?: ConstructionOptions);
    setDisabled(disabled: boolean): void;
    printFont(): void;
    private printOutline;
    private getFormatOffset;
    private renderIcon;
}
export {};
