/** @noSelfInFile */
interface ConstructionOptions {
    filepath?: string;
    size?: number;
}
export default class FontWithPosition {
    size?: number;
    filepath: string;
    x: number;
    y: number;
    text: string;
    constructor(x: number, y: number, text: string, options?: ConstructionOptions);
    printFont(): void;
}
export {};
