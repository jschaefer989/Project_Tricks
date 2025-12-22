import GameManager from "GameManager"
import Hoverable from "Hoverable"
import { Image } from "love.graphics"

export type AssetCallback = (gameManager: GameManager, asset: Asset) => void

export default class Asset {
    id: string
    image: Image
    x: number
    y: number
    onClick: () => void
    onHover?: AssetCallback
    orientation: number
    scaleX: number
    scaleY: number
    offsetX: number
    offsetY: number
    isDisabled: boolean = false
    hoverable?: Hoverable

    constructor(id: string, image: Image, x: number, y: number, onClick?: () => void, onHover?: AssetCallback, orientation?: number, scaleX?: number, scaleY?: number, offsetX?: number, offsetY?: number) {
        this.id = id
        this.image = image
        this.x = x
        this.y = y
        this.onClick = onClick ?? (() => {})
        this.onHover = onHover
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
        this.isDisabled = disabled
    }
    
    setHoverable(hoverable: Hoverable): void {
        this.hoverable = hoverable
    }

    getWidth(): number {
        const imgWidth = this.image.getWidth()
        return imgWidth * Math.abs(this.scaleX)        
    }

    getHeight(): number {
        const imgHeight = this.image.getHeight()
        return imgHeight * Math.abs(this.scaleY) 
    }
}