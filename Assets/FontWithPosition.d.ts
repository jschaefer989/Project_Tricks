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
    isDisabled?: boolean;
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
    isDisabled: boolean;
    color: [number, number, number, number];
    constructor(x: number, y: number, text: string, options?: ConstructionOptions);
    setDisabled(disabled: boolean): void;
    printFont(): void;
    private getFormatOffset;
    private renderIcon;
}
export {};
