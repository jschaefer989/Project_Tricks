/** @noSelfInFile */

import { CharacterTypes } from "./Enums"
import Dealer from "./Dealer"
import Draw from "./Draw"
import Enemy, { EnemyData } from "./Enemy"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"

interface BoardData {
    discardUsed?: number
    playerPoints?: number
    enemyPoints?: number
    enemy?: EnemyData
}

export default class Board {
    gameManager: GameManager
    discardUsed: number
    enemy: Enemy
    dealer: Dealer
    playerPoints: number
    enemyPoints: number

    constructor(gameManager: GameManager, enemy?: Enemy) {
        this.gameManager = gameManager
        this.discardUsed = 0
        this.enemy = enemy ?? new Enemy()
        this.dealer = new Dealer(gameManager)
        this.playerPoints = 0
        this.enemyPoints = 0
    }

    load(data: BoardData): void {
        this.discardUsed = data.discardUsed ?? 0
        this.playerPoints = data.playerPoints ?? 0
        this.enemyPoints = data.enemyPoints ?? 0

        this.enemy = new Enemy()
        this.enemy.load(data.enemy)
    }

    save(): BoardData {
        return {
            discardUsed: this.discardUsed,
            playerPoints: this.playerPoints,
            enemyPoints: this.enemyPoints,
            enemy: this.enemy.save()
        }
    }

    drawBoard(): void {
        const btnW = 140
        const btnH = 70
        const lblH = 30
        const padX = 20
        const padY = 20

        const contentW = this.getContentWidth()
        const coords = this.getStartingCoordinates(contentW, btnH, lblH, padY)
        const startX = coords.startX
        let startY = coords.startY

        // Win status display at top
        this.renderWinStatus()

        // Points display (top center)
        this.renderPointsDisplay()

        // Enemy stats panel (left side)
        this.renderEnemyStatsPanel(padX, padY)

        // Enemy deck visualization (left side, below enemy stats)
        this.renderEnemyDeckVisualization()

        // Enemy row
        this.renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Player row (below enemy)
        startY = startY + lblH + padY + btnH + 200
        this.renderPlayerRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Submit button centered below
        this.renderPlayButton(startY + lblH + btnH + padY + 50, btnW, btnH, padX, padY)

        // Player selected stats panel (right side)
        this.renderPlayerSelectedStatsPanel()

        // Player info (upper-right)
        this.renderPlayerInfoPanel(padX, padY)

        // Player deck visualization (bottom right)
        this.renderPlayerDeckVisualization()

        // Discard counter (bottom center)
        this.renderDiscardCounter()
    }

    getStartingCoordinates(contentW: number, btnH: number, groupH: number, padY: number): { startX: number, startY: number } {
        const totalH = groupH * 2 + padY + btnH // two groups plus spacing plus submit button

        const centerX = love.graphics.getWidth() / 2
        const centerY = love.graphics.getHeight() / 2
        return {
            startX: Math.floor(centerX - contentW / 2),
            startY: Math.floor(centerY - totalH / 2 - 200)
        }
    }

    getContentWidth(): number {
        const enemyHand = this.enemy.hand
        const playerHand = this.gameManager.player.hand

        const rowWidth = (count: number): number => {
            if (count <= 0) return 100
            return count * 100 + (count - 1) * 20
        }

        return Math.max(rowWidth(enemyHand.length), rowWidth(playerHand.length), 300)
    }

    getCashout(): number {
        const selectedValue = this.gameManager.player.getCardValue()
        const enemyValue = this.enemy.getCardValue()
        let cashout = selectedValue - enemyValue
        if (cashout < 0) cashout = 0
        return cashout
    }

    renderWinStatus(): void {
        const selectedPower = this.gameManager.player.getCardPower()
        const enemyPower = this.enemy.getCardPower()

        // Display "Winning!" to the right of the selected-stats panel when visible,
        // otherwise center it at the bottom.
        if (selectedPower > enemyPower) {
            const screenW = love.graphics.getWidth()
            const screenH = love.graphics.getHeight()
            const bottomY = screenH - 150
            const selectedPanelW = 200
            const gap = 20
            let x: number

            if (this.gameManager.player.anySelectedCards()) {
                const selectedPanelX = Math.floor(screenW / 2 - selectedPanelW / 2)
                x = selectedPanelX + selectedPanelW + gap
            } else {
                x = Math.floor(screenW / 2 - 75)
            }

            suit.layout.reset(x, bottomY, 10, 10)
            suit.Label("You will slay your foe!", { align: "left" }, ...suit.layout.row(150, 40))
            suit.Label("Your cashout: " + this.getCashout(), { align: "left" }, ...suit.layout.row(150, 30))
        }
    }

    renderPointsDisplay(): void {
        const screenW = love.graphics.getWidth()
        const centerX = screenW / 2
        const panelW = 300
        const panelX = Math.floor(centerX - panelW / 2)

        suit.layout.reset(panelX, 70, 10, 10)
        suit.Label("Enemy: " + this.enemyPoints + " | Player: " + this.playerPoints, { align: "center" }, ...suit.layout.row(panelW, 30))
    }

    renderEnemyStatsPanel(padX: number, padY: number): void {
        const enemyValue = this.enemy.getCardValue()
        const enemyPower = this.enemy.getCardPower()

        suit.layout.reset(padX, padY, 10, 10)
        suit.Label("Enemy Stats", { align: "center" }, ...suit.layout.row(150, 30))
        suit.Label("Value: " + enemyValue, { align: "center" }, ...suit.layout.row(150, 30))
        suit.Label("Power: " + enemyPower, { align: "center" }, ...suit.layout.row(150, 30))
    }

    renderEnemyDeckVisualization(): void {
        const enemyDeck = this.enemy.deck
        const padX = 20
        const panelY = 170 // Position below enemy stats panel

        suit.layout.reset(padX, panelY, 10, 10)
        suit.Label("Enemy Deck (" + enemyDeck.length + " cards)", { align: "left" }, ...suit.layout.row(150, 30))
        suit.layout.row(0, 5)

        // Display each card in the enemy's deck
        for (const card of enemyDeck) {
            const cardText = card.rank + " " + card.suit + " - Val: " + card.value + ", Pow: " + card.power
            suit.Label(cardText, { align: "left" }, ...suit.layout.row(150, 25))
        }
    }

    renderPlayerSelectedStatsPanel(): void {
        // Only show when the player has at least one selected card
        if (!this.gameManager.player.anySelectedCards()) return

        const selectedValue = this.gameManager.player.getCardValue()
        const selectedPower = this.gameManager.player.getCardPower()

        // Center the panel at the bottom-middle of the screen
        const screenW = love.graphics.getWidth()
        const screenH = love.graphics.getHeight()
        const panelW = 200
        const panelX = Math.floor(screenW / 2 - panelW / 2)
        const bottomY = screenH - 150

        suit.layout.reset(panelX, bottomY, 10, 10)
        suit.Label("Selected Stats", { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Value: " + selectedValue, { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Power: " + selectedPower, { align: "center" }, ...suit.layout.row(panelW, 30))
    }

    renderPlayerInfoPanel(padX: number, padY: number): void {
        const name = this.gameManager.player.name || "Player"
        const level = this.gameManager.player.level || 1
        const exp = this.gameManager.player.experience || 0
        const money = this.gameManager.player.money || 0
        const screenW = love.graphics.getWidth()
        const panelW = 200
        const panelX = screenW - panelW - padX

        suit.layout.reset(panelX, padY, 10, 10)
        suit.Label(name, { align: "center" }, ...suit.layout.row(panelW, 24))
        suit.Label("Level: " + level, { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("XP: " + exp, { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("Money: " + money, { align: "left" }, ...suit.layout.row(panelW, 22))
    }

    renderPlayerDeckVisualization(): void {
        const deckSize = this.gameManager.player.deck.length
        const discardSize = this.gameManager.player.discardPile.length

        // Render discard pile and deck visualization in bottom right corner
        const screenW = love.graphics.getWidth()
        const screenH = love.graphics.getHeight()
        const panelX = screenW - 170 // Same right alignment as selected stats
        const panelY = screenH - 200 // Higher up to fit on screen

        suit.layout.reset(panelX, panelY, 10, 10)
        suit.Label("Discard Pile", { align: "center" }, ...suit.layout.row(150, 30))
        suit.Label("Cards: " + discardSize, { align: "center" }, ...suit.layout.row(150, 30))

        suit.layout.row(0, 10)
        suit.Label("Player Deck", { align: "center" }, ...suit.layout.row(150, 30))
        suit.Label("Cards Remaining: " + deckSize, { align: "center" }, ...suit.layout.row(150, 30))
    }

    renderEnemyRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void {
        const enemyHand = this.enemy.hand
        suit.layout.reset(startX, startY, padX, padY)
        suit.Label("Enemy hand: " + enemyHand.length, { align: "left" }, ...suit.layout.row(contentW, lblH))
        suit.layout.row(0, 0)
        for (const card of enemyHand) {
            const labelText = card.rank + " " + card.suit + " (Val: " + card.value + ", Pow: " + card.power + ")"
            suit.Label(labelText, { align: "left" }, ...suit.layout.col(btnW, btnH))
        }
    }

    renderPlayerRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void {
        const playerHand = this.gameManager.player.hand
        suit.layout.reset(startX, startY, padX, padY)
        suit.Label("Your hand: " + playerHand.length, { align: "left" }, ...suit.layout.row(contentW, lblH))
        suit.layout.row(0, 0)
        for (const card of playerHand) {
            Draw.card(this.gameManager,card, btnW, btnH)
        }
    }

    renderPlayButton(startY: number, btnW: number, btnH: number, padX: number, padY: number): void {
        // Center the buttons horizontally
        const gap = 20
        const totalW = btnW * 2 + gap

        suit.layout.reset(love.graphics.getWidth() / 2 - totalW / 2, startY, padX, padY)

        const playHit = suit.Button("Play", {}, ...suit.layout.col(btnW, btnH)).hit

        // Check if discard button should be enabled
        const discardEnabled = this.discardUsed < this.gameManager.player.discards
        const discardLabel = discardEnabled ? "Discard" : "Discard (used)"
        const discardHit = suit.Button(discardLabel, {}, ...suit.layout.col(btnW, btnH)).hit

        if (playHit) {
            this.handlePlay()
        }
        if (discardHit && discardEnabled) {
            this.handleDiscard()
        }
    }

    renderDiscardCounter(): void {
        const screenW = love.graphics.getWidth()
        const screenH = love.graphics.getHeight()
        const panelX = screenW - 170 // Right side, aligned with discard pile
        const panelY = screenH - 240 // Above the discard pile visualization

        suit.layout.reset(panelX, panelY, 10, 10)
        suit.Label("Discards Remaining: " + (this.gameManager.player.discards - this.discardUsed) + "/" + this.gameManager.player.discards, { align: "center" }, ...suit.layout.row(150, 30))
    }

    handlePlay(): void {
        if (!this.gameManager.player.anySelectedCards()) return
        if (this.enemy.deck.length === 0) {
            this.endFight()
            return
        }

        const selectedPower = this.gameManager.player.getCardPower()
        const enemyPower = this.enemy.getCardPower()

        if (selectedPower > enemyPower) {
            this.playerPoints = this.playerPoints + this.getCashout()
        } else {
            this.enemyPoints = this.enemyPoints + this.enemy.getCardValue()
        }

        this.gameManager.player.removeSelectedCardsFromHand()
        Dealer.dealCards(this.gameManager, CharacterTypes.PLAYER)

        this.enemy.removeAllCardsFromHand()
        Dealer.dealCards(this.gameManager,CharacterTypes.ENEMY)
    }

    handleDiscard(): void {
        if (!this.gameManager.player.anySelectedCards()) return

        this.gameManager.player.discard()

        this.discardUsed = this.discardUsed + 1

        // Refill the player's hand after discarding
        Dealer.dealCards(this.gameManager,CharacterTypes.PLAYER)
    }

    getWinner(): CharacterTypes {
        if (this.playerPoints > this.enemyPoints) {
            return CharacterTypes.PLAYER
        } else {
            return CharacterTypes.ENEMY
        }
    }

    endFight(): void {
        this.gameManager.player.deselectAllCards()
        const winner = this.getWinner()
        if (winner === CharacterTypes.PLAYER) {
            this.enemy.removeAllCardsFromHand()
            this.gameManager.player.cashout(this.playerPoints)
            this.gameManager.switchToWinScreen()
        } else if (winner === CharacterTypes.ENEMY) {
            this.gameManager.switchToLoseScreen()
        }
    }
}
