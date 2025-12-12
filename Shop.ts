/** @noSelfInFile */

import Card from "Card"
import Dealer from "Dealer"
import Draw from "Draw"
import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"

interface ShopData {
    cardsForSale?: Card[]
}

export default class Shop {
    gameManager: GameManager
    cardsForSale: Card[]

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.cardsForSale = []
    }

    load(data: ShopData): void {
        this.cardsForSale = data.cardsForSale ?? []
    }

    save(): ShopData {
        return {
            cardsForSale: this.cardsForSale
        }
    }

    drawShop(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 400
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36

        // Display shop title
        suit.layout.reset(panelX, labelY)
        suit.Label("Shop", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Draw the 3 cards for sale
        const btnW = 300
        const btnH = 50
        const cardStartY = labelY + labelHeight + 30
        const cardX = (screenW - btnW) / 2
        const cardPadding = 15

        // Position and draw each card with padding
        let currentY = cardStartY
        for (const card of this.cardsForSale) {
            suit.layout.reset(cardX, currentY)
            Draw.card(card, btnW, btnH, { onClick: () => this.buyCard(card), displayCost: true })
            currentY += btnH + cardPadding
        }

        // Leave shop button
        const leaveBtnY = currentY + 20
        suit.layout.reset(cardX, leaveBtnY)
        const leaveResult = suit.Button("Leave Shop", {}, ...suit.layout.row(btnW, btnH))
        if (leaveResult.hit) {
            this.gameManager.map?.advanceToNextTier()
            this.gameManager.switchToMap()
        }

        // Player info (upper-right)
        Draw.playerInfo(this.gameManager.player, this.gameManager)

        // Player deck visualization (bottom right)
        Draw.playerDeck(this.gameManager.player)
        
    }

    setup(): void {
        this.generateCardsForSale()
    }

    generateCardsForSale(): void {
        // TODO: will want to weigh this based on player level / progress later
        this.cardsForSale = []
        // TODO: hardcoded to 3 cards for now
        for (let i = 0; i < 3; i++) {
            this.cardsForSale.push(Dealer.getRandomCard())
        }
    }

    canAfford(card: Card): boolean {        
        return this.gameManager.player.money >= card.cost
    }

    buyCard(card: Card): void {
        if (!this.canAfford(card)) {
            return
        }

        this.gameManager.player.money -= card.cost
        this.gameManager.player.deck.push(card)
        this.removeCardFromSale(card)
    }

    removeCardFromSale(card: Card): void {
        this.cardsForSale = this.cardsForSale.filter(c => !c.isEqual(card))
    }
}