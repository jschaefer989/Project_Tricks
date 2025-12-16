import { Image } from "love.graphics";
export default class Asset {
    image: Image;
    x: number;
    y: number;
    onClick: () => void;
    width: number;
    height: number;
    orientation: number;
    scaleX: number;
    scaleY: number;
    offsetX: number;
    offsetY: number;
    disabled: boolean;
    constructor(image: Image, x: number, y: number, onClick?: () => void, width?: number, height?: number, orientation?: number, scaleX?: number, scaleY?: number, offsetX?: number, offsetY?: number);
    updatePosition(x: number, y: number): void;
    updateWidth(width: number): void;
    updateHeight(height: number): void;
    updateOrientation(orientation: number): void;
    updateScale(scaleX: number, scaleY: number): void;
    updateOffset(offsetX: number, offsetY: number): void;
    setDisabled(disabled: boolean): void;
}
