/** @noSelfInFile */
import { Image } from "love.graphics";
export declare enum Format {
    LEFT = 0,
    CENTER = 1,
    RIGHT = 2
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
    icon?: Image;
    iconFormat: Omit<Format, Format.CENTER>;
    constructor(x: number, y: number, text: string, options?: ConstructionOptions);
    printFont(): void;
    private getFormatOffset;
    private renderIcon;
}
export {};
