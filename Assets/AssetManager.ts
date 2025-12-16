import Asset from "./Asset";

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
        for (const asset of this.assets.values()) {
            love.graphics.draw(asset.image, asset.x, asset.y, asset.orientation, asset.scaleX, asset.scaleY, asset.offsetX, asset.offsetY)
        }
    }

    handleMousePressed(x: number, y: number, button: number): void {
        // Implement mouse pressed handling for assets if needed
    }

    handleMouseReleased(x: number, y: number, button: number): void {
        for (const asset of this.assets.values()) {
            if (x >= asset.x && x <= asset.x + asset.width &&
                y >= asset.y && y <= asset.y + asset.height) {
                asset.onClick()
            }
        }
    }
}