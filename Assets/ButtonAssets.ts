import Asset from "./Asset"
import { AssetIds } from "Enums"
import GameManager from "GameManager"

export default class ButtonAssets {
    gameManager: GameManager    
    letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png")
    baseW = this.letsFightButton.getWidth()
    baseH = this.letsFightButton.getHeight()

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    addAsset(buttonX: number, buttonY: number, onClick: () => void): void {
        const assetId = `${AssetIds.LETS_FIGHT_BUTTON}`
        this.gameManager.assetManager.addAsset(assetId, new Asset(this.letsFightButton, buttonX, buttonY, onClick, this.baseW, this.baseH))
    }

    getAsset(assetId: AssetIds): Asset | undefined {
        return this.gameManager.assetManager.getAsset(assetId)
    }

    hideButton(buttonId: AssetIds): void {
        this.gameManager.assetManager.assets.delete(buttonId)
    }
}
