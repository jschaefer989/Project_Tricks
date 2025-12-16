import Card from "../Cards/Card"
import Asset from "./Asset"
import { Suits, AssetIds } from "Enums"
import { exhaustiveGuard } from "Helpers"
import GameManager from "GameManager"
import * as push from "Libraries.push"

const padding = 20

interface CardOptions {
    multiSelect?: boolean
    /**
     * Overrides the onSelect/onUnselect behavior for the card, which generally assumes that the card is rendered on the board
     * @param card 
     * @returns 
     */
    onClick?: (card: Card) => void
    displayCost?: boolean
}

export default class CardAssets {
    gameManager: GameManager    
    baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png")
    baseW = this.baseCard.getWidth()
    baseH = this.baseCard.getHeight()

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    addAsset(card: Card, cardX: number, cardY: number, options?: CardOptions): void {
        const assetId = `${AssetIds.BASE_CARD_TEMPLATE}-${card.id}`
        this.gameManager.assetManager.addAsset(assetId, new Asset(this.baseCard, cardX, cardY, card.onClick, this.baseW, this.baseH))
        this.addSuitAsset(card, cardX, cardY, this.baseW, this.baseH)
    }

    addSuitAsset(card: Card, x: number, y: number, width: number, height: number): void {
        const suitImagePath = this.getSuitAssetPath(card.suit)
        this.gameManager.assetManager.addAsset(this.getSuitAssetId(card.suit, card, 0), new Asset(love.graphics.newImage(suitImagePath), x + 10, y + 10, card.onClick, width, height))
        const flippedX = x + width - 10
        const flippedY = y + height - 10
        this.gameManager.assetManager.addAsset(this.getSuitAssetId(card.suit, card, 1), new Asset(love.graphics.newImage(suitImagePath), flippedX, flippedY, card.onClick, width, height, 0, -1, -1))
    }

    getSuitAssetPath(suit: Suits): string {
        switch (suit) {
            case Suits.HEARTS:
                return "Assets/Images/HeartSuit.png"
            case Suits.BELLS:
                return "Assets/Images/BellSuit.png"
            case Suits.ACORNS:
                return "Assets/Images/AcornSuit.png"
            case Suits.LEAVES:
                return "Assets/Images/LeafSuit.png"
            default: 
                exhaustiveGuard(suit)
        }
    }

    getSuitAssetId(suit: Suits, card: Card, orientation: number): string {
        switch (suit) {
            case Suits.HEARTS:
                return  `${AssetIds.HEART_SUIT}-${card.id}-${orientation}`
            case Suits.BELLS:
                return  `${AssetIds.BELL_SUIT}-${card.id}-${orientation}`
            case Suits.ACORNS:
                return  `${AssetIds.ACORN_SUIT}-${card.id}-${orientation}`
            case Suits.LEAVES:
                return  `${AssetIds.LEAF_SUIT}-${card.id}-${orientation}`
            default: 
                exhaustiveGuard(suit)
        }
    }    

    hideCardAssets(card: Card): void {
        this.gameManager.assetManager.assets.delete(`${AssetIds.BASE_CARD_TEMPLATE}-${card.id}`)
        this.gameManager.assetManager.assets.delete(this.getSuitAssetId(card.suit, card, 0))
        this.gameManager.assetManager.assets.delete(this.getSuitAssetId(card.suit, card, 1))
    }

    centerCards(): void {
        const playerHand = this.gameManager.player.hand
        const cardCount = playerHand.length
        const screenW = push.getWidth()
        const totalW = cardCount * this.baseW + Math.max(0, cardCount - 1) * padding
        const startX = Math.floor((screenW - totalW) / 2)
        const cardY = this.getCardPosition()

        for (let i = 0; i < playerHand.length; i++) {
            const card = playerHand[i]
            const x = startX + i * (this.baseW + padding)

            this.addAsset(card, x, cardY)
        }
    }

    updateCardPosition(card: Card, x: number, y: number): void {
        const assetManager = this.gameManager.assetManager
        assetManager.getAsset(`${AssetIds.BASE_CARD_TEMPLATE}-${card.id}`)?.updatePosition(x, y)
        assetManager.getAsset(this.getSuitAssetId(card.suit, card, 0))?.updatePosition(x + 10, y + 10)
        assetManager.getAsset(this.getSuitAssetId(card.suit, card, 1))?.updatePosition(x + this.baseW - 10, y + this.baseH - 10)

    }

    getCardPosition(): number {
        const screenH = push.getHeight()
        return (screenH / 2) + (this.baseH / 2) 
    }

    // TODO: this logic is duplicated in the baord, so consolidate
    appendAsset(card: Card): void {
        const playerHand = this.gameManager.player.hand
        const cardCount = playerHand.length
        const screenW = push.getWidth()
        const totalW = cardCount * this.baseW + Math.max(0, cardCount - 1) * padding
        const startX = Math.floor((screenW - totalW) / 2)
        const cardY = this.getCardPosition()
        const x = startX + (cardCount - 1) * (this.baseW + padding)

        this.addAsset(card, x, cardY)
    }
}