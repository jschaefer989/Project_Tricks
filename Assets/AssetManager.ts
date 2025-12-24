import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";
import GameManager from "GameManager";
import FontManager from "Assets/TextManager";

export default class AssetManager {
    gameManager: GameManager
    assets: Map<string, Asset[]>
    fontManager: FontManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.assets = new Map<string, Asset[]>()
        this.fontManager = new FontManager()
    }

    addAsset(id: string, asset: Asset): void {
        if (this.assets.has(id)) {
            const assets = this.assets.get(id)
            assets?.push(asset)
            return
        }
        this.assets.set(id, [asset])
    }

    getAssets(baseId: string): Asset[] | undefined {
        return this.assets.get(baseId)
    }

    getAsset(baseId: string, assetId: string): Asset | undefined {
         return this.getAssets(baseId)?.find(asset => asset.id === assetId)
    }

    hideAsset(id: string): void {
        this.assets.delete(id)
    }

    drawAssets(): void {
        // Draw all assets
        for (const assets of this.assets.values()) {
            for (const asset of assets) {
                love.graphics.draw(asset.image, asset.x, asset.y, asset.orientation, asset.scaleX, asset.scaleY, asset.offsetX, asset.offsetY)
            }
        }

        // Draw text above assets
        this.fontManager.drawText()

        // Draw hover content above assets and text
        this.drawHoverables()
    }

    private drawHoverables(): void {
        for (const assets of this.assets.values()) {
            const asset = assets[0]  // Assume hoverable is the same for all assets with the same ID
            if (asset.isHovered) {
                asset.onHover?.(this.gameManager, asset)
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

        for (const assets of this.assets.values()) {
            const asset = assets[0]  // Assume click area is the same for all assets with the same ID
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
        
        for (const assets of this.assets.values()) {
            const asset = assets[0]  // Assume hoverable is the same for all assets with the same ID
            
            if (gameX >= asset.x && gameX <= asset.x + asset.getWidth() &&
                gameY >= asset.y && gameY <= asset.y + asset.getHeight()) {
                asset.setHovered(true)
            } else {
                asset.setHovered(false)
            }
        }
    }
}