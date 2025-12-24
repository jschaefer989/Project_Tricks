import GameManager from "GameManager";
import { Image } from "love.graphics";
export type AssetCallback = (gameManager: GameManager, asset: Asset) => void;
export default class Asset {
    id: string;
    image: Image;
    x: number;
    y: number;
    onClick: () => void;
    onHover?: AssetCallback;
    orientation: number;
    scaleX: number;
    scaleY: number;
    offsetX: number;
    offsetY: number;
    isDisabled: boolean;
    isHovered: boolean;
    constructor(id: string, image: Image, x: number, y: number, onClick?: () => void, onHover?: AssetCallback, orientation?: number, scaleX?: number, scaleY?: number, offsetX?: number, offsetY?: number);
    updatePosition(x: number, y: number): void;
    updateOrientation(orientation: number): void;
    updateScale(scaleX: number, scaleY: number): void;
    updateOffset(offsetX: number, offsetY: number): void;
    setDisabled(disabled: boolean): void;
    setHovered(hovered: boolean): void;
    getWidth(): number;
    getHeight(): number;
}
