/** @noSelfInFile */

import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"

const panelW = 300
const titleY = 50
const labelHeight = 36
const inputW = 280
const inputH = 40
const btnW = 200
const btnH = 50

export default class NewGameMenu {
    gameManager: GameManager
    nameInput: { text: string; forcefocus?: boolean }

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.nameInput = { text: "Player", forcefocus: true }
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()

        const panelX = (screenW - panelW) / 2

        // Render title
        this.renderDisplayTitle(panelX)

        // Prompt for character name
        const labelY = this.renderPlayerNameLabel(panelX)

        // Input field for name
        const inputY = labelY + 30
        this.renderPlayerNameField(panelX, inputY)

        // Start button
        const startBtnY = this.renderStartButton(panelX, inputY)

        // Back button
        this.renderBackButton(panelX, startBtnY)
    }

    renderDisplayTitle(panelX: number): void {
        suit.layout.reset(panelX, titleY)
        suit.Label("New Game", { align: "center" }, ...suit.layout.row(panelW, labelHeight))
    }

    renderPlayerNameLabel(panelX: number): number {
        const promptY = titleY + labelHeight + 20
        suit.layout.reset(panelX, promptY)
        suit.Label("Player Name:", { align: "left" }, ...suit.layout.row(panelW, 25))
        return promptY
    }

    renderPlayerNameField(panelX: number, inputY: number): void {
        suit.layout.reset(panelX, inputY)
        const inputResult = suit.Input(this.nameInput, {}, ...suit.layout.row(inputW, inputH))
        if (inputResult.submitted) {
            this.handleStartGame()
        }
    }

    renderStartButton(panelX: number, inputY: number): number {
        const startBtnY = inputY + inputH + 30
        suit.layout.reset(panelX, startBtnY)
        const startResult = suit.Button("Start Game", {}, ...suit.layout.row(btnW, btnH))
        if (startResult.hit) {
            // Set the player name and start the game
            this.handleStartGame()
        }
        return startBtnY
    }

    renderBackButton(panelX: number, startBtnY: number): void {
        const backBtnY = startBtnY + btnH + 20
        suit.layout.reset(panelX, backBtnY)
        const backResult = suit.Button("Back", {}, ...suit.layout.row(btnW, btnH))
        if (backResult.hit) {
            this.gameManager.switchToMainMenu()
        }
    }

    handleStartGame(): void { 
        const playerName = this.nameInput.text.trim()
        if (playerName.length > 0) {
            this.gameManager.player.name = playerName
            this.gameManager.map.generateNewMap()
            this.gameManager.switchToMap()
        }
        this.gameManager.player.setup()
    }
}