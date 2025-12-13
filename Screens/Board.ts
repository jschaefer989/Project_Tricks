/** @noSelfInFile */

import { CharacterTypes, Suits } from "../Enums"
import Dealer from "../Dealer"
import Draw from "../Draw"
import Enemy, { EnemyData } from "Enemies/Enemy"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "../GameManager"

interface BoardData {
    discardUsed: number
    playerPoints: number
    enemyPoints: number
    enemy: EnemyData
    trumpSuit: Suits
    playerPower: number
    playerValue: number
    enemyPower: number
    enemyValue: number
    showingInitialView: boolean
}

export default class Board {
    gameManager: GameManager
    discardUsed: number
    enemy: Enemy
    dealer: Dealer
    playerPoints: number
    enemyPoints: number
    trumpSuit: Suits
    playerPower: number
    playerValue: number
    enemyPower: number
    enemyValue: number
    showingInitialView: boolean

    constructor(gameManager: GameManager, enemy?: Enemy) {
        this.gameManager = gameManager
        this.discardUsed = 0
        this.enemy = enemy ?? new Enemy()
        this.dealer = new Dealer(gameManager)
        this.playerPoints = 0
        this.enemyPoints = 0
        this.trumpSuit = Suits.ACORNS
        this.playerPower = 0
        this.playerValue = 0
        this.enemyPower = 0
        this.enemyValue = 0
        this.showingInitialView = true
    }

    load(data: BoardData): void {
        this.discardUsed = data.discardUsed
        this.playerPoints = data.playerPoints
        this.enemyPoints = data.enemyPoints
        this.trumpSuit = data.trumpSuit
        this.playerPower = data.playerPower
        this.playerValue = data.playerValue
        this.enemyPower = data.enemyPower
        this.enemyValue = data.enemyValue
        this.showingInitialView = data.showingInitialView ?? true

        this.enemy = new Enemy()
        this.enemy.load(this.gameManager, data.enemy)
    }

    save(): BoardData {
        return {
            discardUsed: this.discardUsed,
            playerPoints: this.playerPoints,
            enemyPoints: this.enemyPoints,
            enemy: this.enemy.save(),
            trumpSuit: this.trumpSuit,
            playerPower: this.playerPower,
            playerValue: this.playerValue,
            enemyPower: this.enemyPower,
            enemyValue: this.enemyValue,
            showingInitialView: this.showingInitialView
        }
    }

    drawBoard(): void {
        if (this.showingInitialView) {
            this.drawInitialView()
        } else {
            this.drawNormalView()
        }
    }

    drawInitialView(): void {
        const btnW = 140
        const btnH = 70
        const lblH = 30
        const padX = 20
        const padY = 20

        const contentW = this.getContentWidth()
        const coords = this.getStartingCoordinates(contentW, btnH, lblH, padY)
        const startX = coords.startX
        let startY = coords.startY

        // Trump suit label at the top
        this.renderTrumpSuitLabel()

        // Enemy deck visualization (left side)
        this.renderEnemyDeck()

        // Enemy row
        this.renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Player row (below enemy) with buttons instead of selectable cards
        startY = startY + lblH + padY + btnH + 200
        this.renderPlayerRowInitial(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Let's Fight button
        this.renderLetsFightButton(startY + lblH + btnH + padY + 50, btnW, btnH)

        // Player info (upper-right)
        Draw.playerInfo(this.gameManager.player, this.gameManager)

        // Player deck visualization (bottom right)
        Draw.playerDeck(this.gameManager.player, { showDiscards: true })
    }

    drawNormalView(): void {
        const btnW = 140
        const btnH = 70
        const lblH = 30
        const padX = 20
        const padY = 20

        const contentW = this.getContentWidth()
        const coords = this.getStartingCoordinates(contentW, btnH, lblH, padY)
        const startX = coords.startX
        let startY = coords.startY

        // Points display (top center)
        this.renderPointsDisplay()

        // Enemy deck visualization (left side)
        this.renderEnemyDeck()

        // Enemy stats panel (left of enemy row)
        this.renderEnemyStats(startX, startY)

        // Enemy row
        this.renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Player row (below enemy)
        startY = startY + lblH + padY + btnH + 200
        this.renderPlayerRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

        // Submit button centered below
        this.renderAttackButton(startY + lblH + btnH + padY + 50, btnW, btnH, padX, padY)

        // Player selected stats panel (right of player row)
        this.renderPlayerSelectedStats(startX, startY, contentW, btnW)

        // Win status display (right of player row)
        this.renderWinStatus(startX, startY)

        // Player info (upper-right)
        Draw.playerInfo(this.gameManager.player, this.gameManager)

        // Player deck visualization (bottom right)
        Draw.playerDeck(this.gameManager.player, { showDiscards: true })

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

    getPlayerCashout(): number {
        let cashout = this.playerValue - this.enemyValue
        if (cashout < 0) cashout = 0
        return cashout
    }

    getEnemyCashout(): number {
        let cashout = this.enemyValue - this.playerValue
        if (cashout < 0) cashout = 0
        return cashout
    }

    renderWinStatus(startX: number, startY: number): void {
        if (this.playerPower > this.enemyPower) {
            const gap = 30
            const panelW = 180
            const selectedStatsW = this.gameManager.player.anySelectedCards() ? 180 : 0
            const selectedStatsGap = this.gameManager.player.anySelectedCards() ? gap : 0
            const x = startX - panelW - gap - selectedStatsW - selectedStatsGap

            suit.layout.reset(x, startY, 10, 10)
            suit.Label("You will slay your foe!", { align: "left" }, ...suit.layout.row(panelW, 40))
            suit.Label("Your cashout: " + this.getPlayerCashout(), { align: "left" }, ...suit.layout.row(panelW, 30))
        }
    }

    renderTrumpSuitLabel(): void {
        const screenW = love.graphics.getWidth()
        const centerX = screenW / 2
        const panelW = 300
        const panelX = Math.floor(centerX - panelW / 2)

        suit.layout.reset(panelX, 20, 10, 10)
        suit.Label("Trump Suit: " + this.trumpSuit, { align: "center" }, ...suit.layout.row(panelW, 40))
    }

    renderPointsDisplay(): void {
        const screenW = love.graphics.getWidth()
        const centerX = screenW / 2
        const panelW = 300
        const panelX = Math.floor(centerX - panelW / 2)

        suit.layout.reset(panelX, 70, 10, 10)
        suit.Label(`${this.enemy.name}: ${this.enemyPoints} | Player: ${this.playerPoints}`, { align: "center" }, ...suit.layout.row(panelW, 30))
    }

    renderEnemyStats(startX: number, startY: number): void {
        const gap = 30
        const panelW = 150
        const x = startX - panelW - gap

        suit.layout.reset(x, startY, 10, 10)
        suit.Label(`${this.enemy.name} Hand`, { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Value: " + this.enemyValue, { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Power: " + this.enemyPower, { align: "center" }, ...suit.layout.row(panelW, 30))
    }

    renderEnemyDeck(): void {
        const enemyDeck = this.enemy.deck

        suit.layout.reset(10, 10, 10, 10)
        suit.Label(`${this.enemy.name} Deck (${enemyDeck.length} cards)`, { align: "left" }, ...suit.layout.row(150, 30))
        suit.layout.row(0, 5)

        // Display each card in the enemy's deck
        for (const card of enemyDeck) {
            const cardText = card.rank + " " + card.suit + " - Val: " + card.value + ", Pow: " + card.power
            suit.Label(cardText, { align: "left" }, ...suit.layout.row(150, 25))
        }
    }

    renderPlayerSelectedStats(startX: number, startY: number, contentW: number, btnW: number): void {
        // Only show when the player has at least one selected card
        if (!this.gameManager.player.anySelectedCards()) return

        const gap = 30
        const panelW = 180
        const x = startX - panelW - gap

        suit.layout.reset(x, startY, 10, 10)
        suit.Label("Selected Hand", { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Value: " + this.playerValue, { align: "center" }, ...suit.layout.row(panelW, 30))
        suit.Label("Power: " + this.playerPower, { align: "center" }, ...suit.layout.row(panelW, 30))
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

    renderPlayerRowInitial(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void {
        const playerHand = this.gameManager.player.hand
        suit.layout.reset(startX, startY, padX, padY)
        suit.Label("Your hand: " + playerHand.length, { align: "left" }, ...suit.layout.row(contentW, lblH))
        suit.layout.row(0, 0)
        for (const card of playerHand) {
            const cardText = card.rank + " " + card.suit + " (Val: " + card.value + ", Pow: " + card.power + ")"
            suit.Button(cardText, {}, ...suit.layout.col(btnW, btnH))
        }
    }

    renderPlayerRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void {
        const playerHand = this.gameManager.player.hand
        suit.layout.reset(startX, startY, padX, padY)
        suit.Label("Your hand: " + playerHand.length, { align: "left" }, ...suit.layout.row(contentW, lblH))
        suit.layout.row(0, 0)
        for (const card of playerHand) {
            Draw.card(card, btnW, btnH, { multiSelect: true } )
        }
    }

    renderLetsFightButton(startY: number, btnW: number, btnH: number): void {
        const screenW = love.graphics.getWidth()
        const buttonW = 200
        const buttonX = Math.floor(screenW / 2 - buttonW / 2)

        suit.layout.reset(buttonX, startY, 20, 20)
        const hit = suit.Button("Let's Fight!", {}, ...suit.layout.row(buttonW, btnH)).hit

        if (hit) {
            this.showingInitialView = false
            this.dealer.startGame()
        }
    }

    renderAttackButton(startY: number, btnW: number, btnH: number, padX: number, padY: number): void {
        // Center the buttons horizontally
        const gap = 20
        const totalW = btnW * 3 + gap * 2

        suit.layout.reset(love.graphics.getWidth() / 2 - totalW / 2, startY, padX, padY)

        const attackHit = suit.Button("Attack", {}, ...suit.layout.col(btnW, btnH)).hit

        // Check if discard button should be enabled
        const discardEnabled = this.discardUsed < this.gameManager.player.discards
        const discardLabel = discardEnabled ? "Discard" : "Discard (used)"
        const discardHit = suit.Button(discardLabel, {}, ...suit.layout.col(btnW, btnH)).hit

        const deselectHit = suit.Button("Deselect All", {}, ...suit.layout.col(btnW, btnH)).hit

        if (attackHit) {
            this.handleAttack()
        }
        if (discardHit && discardEnabled) {
            this.handleDiscard()
        }
        if (deselectHit) {
            this.gameManager.player.unselectCards()
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

    handleAttack(): void {
        if (!this.gameManager.player.anySelectedCards()) return
        if (this.enemy.deck.length === 0) {
            this.endFight()
            return
        }

        if (this.playerPower > this.enemyPower) {
            this.playerPoints = this.playerPoints + this.getPlayerCashout()
        } else {
            this.enemyPoints = this.enemyPoints + this.getEnemyCashout()
        }

        this.clearStats()

        this.gameManager.player.removeSelectedCardsFromHand()
        this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER)

        this.enemy.removeAllCardsFromHand()
        this.gameManager.board?.dealer.dealCards(CharacterTypes.ENEMY)
    }

    handleDiscard(): void {
        if (!this.gameManager.player.anySelectedCards()) return

        this.gameManager.player.discard()

        this.discardUsed = this.discardUsed + 1

        // Refill the player's hand after discarding
        this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER)
    }

    getWinner(): CharacterTypes {
        if (this.playerPoints > this.enemyPoints) {
            return CharacterTypes.PLAYER
        } else {
            return CharacterTypes.ENEMY
        }
    }

    endFight(): void {
        this.clearStats()
        this.gameManager.player.deselectAllCards()
        const winner = this.getWinner()
        if (winner === CharacterTypes.PLAYER) {
            this.enemy.removeAllCardsFromHand()
            this.gameManager.player.addDiscardsToDeck()
            this.gameManager.player.cashout(this.playerPoints)
            this.dealer.getLootCards()
            this.gameManager.switchToWinScreen()
        } else if (winner === CharacterTypes.ENEMY) {
            this.gameManager.switchToLoseScreen()
        }
    }

    clearStats(): void {
        this.playerPower = 0
        this.playerValue = 0
        this.enemyPower = 0
        this.enemyValue = 0
    }
}
