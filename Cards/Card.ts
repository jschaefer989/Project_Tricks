/** @noSelfInFile */

import GameManager from "GameManager"
import { Ranks, Suits, TrumpRanks } from "../Enums"
import { isEmpty } from "Helpers"
import Asset from "Assets/Asset"
import Hoverable from "Hoverable"

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

export default class Card extends Hoverable {
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
    isHovered: boolean = false

    constructor(gameManager: GameManager, suit: Suits, rank: Ranks | TrumpRanks, power: number, value: number, name: string, isTrump?: boolean) {
        const id = `${suit}_${rank}_${love.math.random(1000)}`
        super(id);
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
    }

    onUnselect(): void {
        if (isEmpty(this.gameManager.board)) {
            return  
        } 

        this.gameManager.board.playerPower -= this.power
        this.gameManager.board.playerValue -= this.value
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
        const defaultX = asset.x + asset.width + padding
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
