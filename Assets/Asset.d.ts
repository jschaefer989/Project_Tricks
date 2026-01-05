import GameManager from "GameManager";
import { Source } from "love.audio";
import { Image } from "love.graphics";
export type AssetCallback = (gameManager: GameManager, asset: Asset) => void;
interface ConstructionOptions {
    readonly onClick?: () => void;
    readonly onHover?: AssetCallback;
    readonly orientation?: number;
    readonly scaleX?: number;
    readonly scaleY?: number;
    readonly offsetX?: number;
    readonly offsetY?: number;
    readonly isDisabled?: boolean;
    readonly clickSound?: Source;
    readonly associatedTexts?: string[];
}
export default class Asset {
    id: string;
    image: Image;
    x: number;
    y: number;
    onClick?: () => void;
    onHover?: AssetCallback;
    orientation: number;
    scaleX: number;
    scaleY: number;
    offsetX: number;
    offsetY: number;
    isDisabled: boolean;
    isHovered: boolean;
    color: [number, number, number, number];
    clickSound?: Source;
    associatedTexts?: string[];
    constructor(id: string, image: Image, x: number, y: number, constructionOptions?: ConstructionOptions);
    updatePosition(x: number, y: number): void;
    updateOrientation(orientation: number): void;
    updateScale(scaleX: number, scaleY: number): void;
    updateOffset(offsetX: number, offsetY: number): void;
    setHovered(hovered: boolean): void;
    setDisabled(disabled: boolean): void;
    getWidth(): number;
    getHeight(): number;
}
export {};
