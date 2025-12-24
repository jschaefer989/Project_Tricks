/** @noSelfInFile */

import GameManager from "GameManager"
import { Ranks, Suits, TrumpRanks, AssetIds } from "../Enums"
import { isEmpty } from "Helpers"
import Asset from "Assets/Asset"
import CardAssets from "Assets/CardAssets"

interface CardData {
    id: string
    suit: Suits
    rank: Ranks | TrumpRanks
    power: number
    value: number
    isSelected: boolean
    cost: number
    isTrump: boolean
    name: string
}

export default class Card {
    gameManager: GameManager
    id: string
    suit: Suits
    rank: Ranks | TrumpRanks
    power: number
    value: number
    isSelected: boolean = false
    cost: number
    isTrump: boolean = false
    name: string

    // TODO: I want to make this into a more generic animation handler
    // Animation state for selected card movement
    animDuration: number = 0.15  // seconds
    animElapsed: number = 0
    animOffsetY: number = 0  // Current animation offset
    animTargetOffsetY: number = 0  // Target animation offset (e.g., -20 for up)
    isAnimating: boolean = false
    
    // Store original Y positions for all assets
    originalBaseY: number = 0
    originalSuitY0: number = 0
    originalSuitY1: number = 0
    originalRankY: number = 0

    constructor(gameManager: GameManager, suit: Suits, rank: Ranks | TrumpRanks, power: number, value: number, name: string, isTrump?: boolean) {
        const id = `${suit}_${rank}_${love.math.random(1000)}`
        this.gameManager = gameManager
        this.suit = suit
        this.rank = rank
        this.power = power
        this.value = value
        this.cost = this.getCost()
        this.isTrump = isTrump ?? false
        this.name = name
        this.id = id 
    }

    isEqual(otherCard: Card): boolean {
        return this.id === otherCard.id
    }

    getCost(): number {
        let cost = 0
        cost += this.getBaseCost()
        return cost
    }

    getBaseCost(): number {
        return this.power * 10 + this.value * 5
    }

    save(): CardData {
        return {
            id: this.id,
            suit: this.suit,
            rank: this.rank,
            power: this.power,
            value: this.value,
            isSelected: this.isSelected,
            cost: this.cost,
            isTrump: this.isTrump,
            name: this.name
        }
    }

    static load(gameManager: GameManager, data: CardData): Card {
        const card = new Card(gameManager, data.suit, data.rank, data.power, data.value, data.name, data.isTrump)
        card.id = data.id
        card.isSelected = data.isSelected
        card.cost = data.cost
        return card
    }

    onClick(): void {
        if (this.isSelected) {
            this.isSelected = false
            this.onUnselect()
        } else {
            this.isSelected = true
            this.onSelect()
        }
    }

    onSelect(): void {
        if (isEmpty(this.gameManager.board)) {
            return  
        } 

        this.gameManager.board.playerPower += this.power
        this.gameManager.board.playerValue += this.value
        
        // Trigger animation: move card up by 20 pixels
        this.startAnimation(-20)
    }

    onUnselect(): void {
        if (isEmpty(this.gameManager.board)) {
            return
        }

        this.gameManager.board.playerPower -= this.power
        this.gameManager.board.playerValue -= this.value
        
        // Trigger animation: move card back to original position
        this.startAnimation(20)
    }

    // TODO: I want to make this into a more generic animation handler
    startAnimation(offsetY: number): void {
        if (isEmpty(this.gameManager.board)) {
            return  
        }

        // Store original positions of all assets
        const { baseAsset, suitAssets, rankAsset } = this.gameManager.board.cardAssets.getCardAssets(this)
        const suitAsset0 = suitAssets[0]
        const suitAsset1 = suitAssets[1]
        
        // Only initialize original positions on first animation call or when not animating
        if (!this.isAnimating) {
            if (!isEmpty(baseAsset)) this.originalBaseY = baseAsset.y
            if (!isEmpty(suitAsset0)) this.originalSuitY0 = suitAsset0.y
            if (!isEmpty(suitAsset1)) this.originalSuitY1 = suitAsset1.y
            if (!isEmpty(rankAsset)) this.originalRankY = rankAsset.y
        }
        
        this.animTargetOffsetY = offsetY
        this.animElapsed = 0
        this.isAnimating = true
    }

    updateAnimation(deltaTime: number): void {
        if (!this.isAnimating || isEmpty(this.gameManager.board)) {
            return
        }

        this.animElapsed += deltaTime
        
        if (this.animElapsed >= this.animDuration) {
            // Animation complete
            this.animElapsed = this.animDuration
            this.isAnimating = false
        }

        // Interpolate animation offset
        const progress = this.animElapsed / this.animDuration
        this.animOffsetY = this.animTargetOffsetY * progress
        
        // Update all card assets' Y positions by adding offset to their original positions
        const { baseAsset, suitAssets, rankAsset } = this.gameManager.board.cardAssets.getCardAssets(this)
        const suitAsset0 = suitAssets[0]
        const suitAsset1 = suitAssets[1]
        
        if (!isEmpty(baseAsset)) {
            baseAsset.y = this.originalBaseY + this.animOffsetY
        }
        if (!isEmpty(suitAsset0)) {
            suitAsset0.y = this.originalSuitY0 + this.animOffsetY
        }
        if (!isEmpty(suitAsset1)) {
            suitAsset1.y = this.originalSuitY1 + this.animOffsetY
        }
        if (!isEmpty(rankAsset)) {
            rankAsset.y = this.originalRankY + this.animOffsetY
        }
    }

    static onHover(gameManager: GameManager, asset: Asset): void {
        const tooltipMaxWidth = 200
        const padding = 20
        const bgPadding = 8

        // Extract card ID from asset ID (format: "BASE_CARD_TEMPLATE-{cardId}")
        // TODO: move to its own method somewhere (not CardAssets)
        const cardId = asset.id.split("-")[1]
        const card = gameManager.getCard(cardId)
        const font = love.graphics.getFont()
        
        if (isEmpty(card)  || isEmpty(font)) {
            return
        }

        const screenW = love.graphics.getWidth()
        const defaultX = asset.x + asset.getWidth() + padding
        const placeRight = defaultX + tooltipMaxWidth <= screenW - padding
        const tooltipX = placeRight
            ? defaultX
            : math.max(padding, asset.x - padding - tooltipMaxWidth)
        const tooltipY = asset.y

        const lineHeight = font.getHeight()
        const bgX = tooltipX - bgPadding
        const bgY = tooltipY - bgPadding
        const bgW = tooltipMaxWidth + bgPadding * 2
        const bgH = lineHeight * 4 + bgPadding * 2

        // Draw background
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", bgX, bgY, bgW, bgH)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", bgX, bgY, bgW, bgH)

        // Draw text
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(card.name, tooltipX, tooltipY, tooltipMaxWidth, "left")
        love.graphics.printf(card.suit, tooltipX, tooltipY, tooltipMaxWidth, "right")
        love.graphics.printf("Power: " + card.power, tooltipX, tooltipY + 20, tooltipMaxWidth, "left")
        love.graphics.printf("Value: " + card.value, tooltipX, tooltipY + 40, tooltipMaxWidth, "left")
    }
}
