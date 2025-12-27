/** @noSelfInFile */
export declare enum Format {
    LEFT = 0,
    CENTER = 1,
    RIGHT = 2
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
    constructor(x: number, y: number, text: string, options?: ConstructionOptions);
    printFont(): void;
    getFormatOffset(textW: number): number;
}
export {};
