import * as push from "Libraries.push";
import Asset from "./Asset";
import { isEmpty } from "Helpers";

export default class AssetManager {
    assets: Map<string, Asset>

    constructor() {
        this.assets = new Map<string, Asset>()
    }

    addAsset(id: string, asset: Asset): void {
        this.assets.set(id, asset)
    }

    getAsset(id: string): Asset | undefined {
        return this.assets.get(id)
    }

    drawAssets(): void {
        //for (const asset of this.assets.values()) {
        let index = 1
        this.assets.forEach((asset, key) => {
            love.graphics.draw(asset.image, asset.x, asset.y, asset.orientation, asset.scaleX, asset.scaleY, asset.offsetX, asset.offsetY)
            index++
        })
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
}