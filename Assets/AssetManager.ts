import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";
import GameManager from "GameManager";
import FontManager from "Assets/FontManager";

export default class AssetManager {
    gameManager: GameManager
    assets: Map<string, Asset>
    fontManager: FontManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.assets = new Map<string, Asset>()
        this.fontManager = new FontManager()
    }

    addAsset(id: string, asset: Asset): void {
        this.assets.set(id, asset)
    }

    getAsset(id: string): Asset | undefined {
        return this.assets.get(id)
    }

    hideAsset(id: string): void {
        this.assets.delete(id)
    }

    drawAssets(): void {
        // Draw all assets
        for (const asset of this.assets.values()) {
            love.graphics.draw(asset.image, asset.x, asset.y, asset.orientation, asset.scaleX, asset.scaleY, asset.offsetX, asset.offsetY)
        }

        this.fontManager.drawText()

        // Draw hover content above assets
        this.drawHoverables()
    }

    private drawHoverables(): void {
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
        // const [gameX, gameY] = push.toGame(x, y)

        // if (isEmpty(gameX) || isEmpty(gameY)) {
        //     return
        // }

        // for (const asset of this.assets.values()) {
        //     if (gameX >= asset.x && gameX <= asset.x + asset.getWidth() &&
        //         gameY >= asset.y && gameY <= asset.y + asset.getHeight()) {
        //         asset.onClick()
        //     }
        // }
    }

    handleMouseReleased(x: number, y: number, button: number): void {
        const [gameX, gameY] = push.toGame(x, y)

        if (isEmpty(gameX) || isEmpty(gameY)) {
            return
        }

        for (const asset of this.assets.values()) {
            if (gameX >= asset.x && gameX <= asset.x + asset.getWidth() &&
                gameY >= asset.y && gameY <= asset.y + asset.getHeight()) {
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
            
            if (gameX >= asset.x && gameX <= asset.x + asset.getWidth() &&
                gameY >= asset.y && gameY <= asset.y + asset.getHeight()) {
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