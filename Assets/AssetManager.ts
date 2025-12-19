import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";
import GameManager from "GameManager";
import Hoverable from "Hoverable";

export default class AssetManager {
    gameManager: GameManager
    assets: Map<string, Asset>

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.assets = new Map<string, Asset>()
    }

    addAsset(id: string, asset: Asset): void {
        this.assets.set(id, asset)
    }

    getAsset(id: string): Asset | undefined {
        return this.assets.get(id)
    }

    drawAssets(): void {
        this.drawCards()
        this.drawHoverables()
    }

    drawCards(): void {
        for (const asset of this.assets.values()) {
            love.graphics.draw(asset.image, asset.x, asset.y, asset.orientation, asset.scaleX, asset.scaleY, asset.offsetX, asset.offsetY)
        }
    }

    drawHoverables(): void {
        const drawnHoverables = new Set<string>()
        for (const asset of this.assets.values()) {
            if (!isEmpty(asset.hoverable) && asset.hoverable.isHovered) {
                const hoverableId = asset.hoverable.id
                if (!drawnHoverables.has(hoverableId)) {
                    drawnHoverables.add(hoverableId)
                    asset.onHover?.(this.gameManager, asset)
                }
            }
        }
    }

    handleMousePressed(x: number, y: number, button: number): void {
        const gameX = push.toGame(x, y)[0]
        const gameY = push.toGame(x, y)[1]

        if (isEmpty(gameX) || isEmpty(gameY)) {
            return
        }

        for (const asset of this.assets.values()) {
            if (gameX >= asset.x && gameX <= asset.x + asset.width &&
                gameY >= asset.y && gameY <= asset.y + asset.height) {
                asset.onClick()
            }
        }
    }

    handleMouseReleased(x: number, y: number, button: number): void {
        const [gameX, gameY] = push.toGame(x, y)

        if (isEmpty(gameX) || isEmpty(gameY)) {
            return
        }

        for (const asset of this.assets.values()) {
            if (gameX >= asset.x && gameX <= asset.x + asset.width &&
                gameY >= asset.y && gameY <= asset.y + asset.height) {
                asset.onClick()
            }
        }
    }

    handleMouseHover(): void {
        const [x, y] = love.mouse.getPosition()
        const [gameX, gameY] = push.toGame(x, y)

        if (isEmpty(gameX) || isEmpty(gameY)) {
            return
        }

        // Track which hoverables are being hovered
        const hoveredHoverables = new Set<string>()
        
        for (const asset of this.assets.values()) {
            if (isEmpty(asset.hoverable)) {
                continue;
            }
            
            // Use actual image dimensions for collision detection
            const imgWidth = asset.image.getWidth()
            const imgHeight = asset.image.getHeight()
            const scaledWidth = imgWidth * Math.abs(asset.scaleX)
            const scaledHeight = imgHeight * Math.abs(asset.scaleY)
            
            if (gameX >= asset.x && gameX <= asset.x + scaledWidth &&
                gameY >= asset.y && gameY <= asset.y + scaledHeight) {
                hoveredHoverables.add(asset.hoverable.id)
            }
        }
        
        // Set isHovered based on whether the hoverable was hit by any asset
        for (const asset of this.assets.values()) {
            if (!isEmpty(asset.hoverable)) {
                asset.hoverable.isHovered = hoveredHoverables.has(asset.hoverable.id)
            }
        }
    }
}