import { Image } from "love.graphics"

export default class Asset {
    image: Image
    x: number
    y: number
    onClick: () => void
    width: number
    height: number
    orientation: number
    scaleX: number
    scaleY: number
    offsetX: number
    offsetY: number
    disabled: boolean = false

    constructor(image: Image, x: number, y: number, onClick?: () => void, width?: number, height?: number, orientation?: number, scaleX?: number, scaleY?: number, offsetX?: number, offsetY?: number) {
        this.image = image
        this.x = x
        this.y = y
        this.onClick = onClick ?? (() => {})
        this.width = width ?? 0
        this.height = height ?? 0
        this.orientation = orientation ?? 0
        this.scaleX = scaleX ?? 1
        this.scaleY = scaleY ?? 1
        this.offsetX = offsetX ?? 0
        this.offsetY = offsetY ?? 0
    }

    updatePosition(x: number, y: number): void {
        this.x = x
        this.y = y
    }

    updateWidth(width: number): void {
        this.width = width
    }

    updateHeight(height: number): void {
        this.height = height
    }

    updateOrientation(orientation: number): void {
        this.orientation = orientation
    }

    updateScale(scaleX: number, scaleY: number): void {
        this.scaleX = scaleX
        this.scaleY = scaleY
    }

    updateOffset(offsetX: number, offsetY: number): void {
        this.offsetX = offsetX
        this.offsetY = offsetY
    }

    setDisabled(disabled: boolean): void {
        this.disabled = disabled
    }
}