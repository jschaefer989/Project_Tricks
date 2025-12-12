
import Draw from "./Draw"
import { isEmpty } from "Helpers"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"
import Card from "Card"

/**
 * WinScreen class handles the display of the victory screen
 */
export default class WinScreen {
    gameManager: GameManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 240
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36
        this.renderVictoryLabel()

        const panelY = labelY + labelHeight
        const panelH = this.renderPlayerInfoPanel(panelX, panelY, panelW)

        const lootStartY = panelY + panelH + 10
        const lootH = this.renderLootCards(panelX, lootStartY, panelW)
    }

    renderVictoryLabel(): void {
        suit.layout.reset((love.graphics.getWidth() - 240) / 2, 50)
        suit.Label("Victory!", { align: "center" }, ...suit.layout.row(240, 36))
    }

    /**
     * 
     * @param x 
     * @param y 
     * @param panelW 
     * @returns 
     */
    renderPlayerInfoPanel(x: number, y: number, panelW: number): number {
        const name = this.gameManager.player.name ?? "Player"
        const level = this.gameManager.player.level ?? 1
        const exp = this.gameManager.player.experience ?? 0
        const money = this.gameManager.player.money ?? 0
        suit.layout.reset(x, y)
        suit.Label(name, { align: "center" }, ...suit.layout.row(panelW, 24))
        suit.Label("Level: " + level, { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("XP: " + exp, { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("Money: " + money, { align: "left" }, ...suit.layout.row(panelW, 22))

        const totalHeight = 24 + 22 * 3
        return totalHeight
    }

    renderLootCards(panelX: number, startY: number, panelW: number): number {
        const labelH = 24
        suit.layout.reset(panelX, startY)
        suit.Label("Loot:", { align: "center" }, ...suit.layout.row(panelW, labelH))
        const lootCards = (this.gameManager.board && this.gameManager.board.dealer && this.gameManager.board.dealer.lootCards) || []
        const padding = 8
        const maxBtnW = 120
        const count = Math.max(1, lootCards.length)
        let btnW = Math.floor((panelW - padding * (count - 1)) / count)
        btnW = Math.max(40, Math.min(btnW, maxBtnW))
        const btnH = Math.floor(btnW * 1.4)

        const cardsY = startY + labelH + 8
        for (let i = 0; i < lootCards.length; i++) {
            const card = lootCards[i]
            const x = panelX + i * (btnW + padding)
            suit.layout.reset(x, cardsY)
            Draw.card(card, btnW, btnH, { onClick: () => this.handleLootCardSelection(card) } )
        }

        const totalHeight = labelH + 8 + btnH
        return totalHeight
    }

    handleLootCardSelection(card: Card): void {
        // TODO: handle perk to pick multiple cards
        // if (hasPerk)
        // {
        // this.gameManager.board?.dealer.addLootCardsToPlayer()
        // }
        //else {
        this.gameManager.player.addDiscardsToDeck()
        this.gameManager.player.addToDeck(card)
        this.gameManager.board = undefined
        this.gameManager.map?.advanceToNextTier()
        this.gameManager.switchToMap()
    }

    addLootCardsToPlayer(): void {
        const lootCards = this.gameManager.board?.dealer.lootCards
        if (isEmpty(lootCards)) {
            return
        }

        for (const card of lootCards) {
            if (card.selected) {
                this.gameManager.player.addToDeck(card)
            }
        }
    }
}
