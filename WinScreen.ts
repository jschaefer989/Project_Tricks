
import Draw from "./Draw"
import { isEmpty } from "Helpers"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"

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

        const continueBtnY = lootStartY + lootH + 10
        this.renderContinueButton(panelX, continueBtnY, panelW)
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
            Draw.card(this.gameManager, card, btnW, btnH, true)
        }

        const totalHeight = labelH + 8 + btnH
        return totalHeight
    }

    renderContinueButton(panelX: number, panelY: number, panelW: number): void {
        const btnW = 200
        const btnH = 50
        suit.layout.reset(panelX + (panelW - btnW) / 2, panelY)
        const continueResult = suit.Button("Continue", {}, ...suit.layout.row(btnW, btnH))
        if (continueResult && continueResult.hit) {
            this.gameManager.player.addDiscardsToDeck && this.gameManager.player.addDiscardsToDeck()
            if (!isEmpty(this.gameManager.board?.dealer)) {
                 this.gameManager.board.dealer.addLootCardsToPlayer()
            }
            this.gameManager.board = undefined
            this.gameManager.switchToBoard && this.gameManager.switchToBoard()
        }
    }

    addLootCardsToPlayer(): void {
        const lootCards = (this.gameManager.board && this.gameManager.board.dealer && this.gameManager.board.dealer.lootCards) || []
        for (let i = 0; i < lootCards.length; i++) {
            const card = lootCards[i]
            if (card.selected) {
                this.gameManager.player.addToHand && this.gameManager.player.addToHand(card)
            }
        }
    }
}
