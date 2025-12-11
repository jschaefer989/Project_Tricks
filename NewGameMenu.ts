/** @noSelfInFile */

import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"

export default class NewGameMenu {
    gameManager: GameManager
    nameInput: { text: string }

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.nameInput = { text: "Player" }
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 300
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36

        // Display title
        suit.layout.reset(panelX, labelY)
        suit.Label("New Game", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Prompt for character name
        const promptY = labelY + labelHeight + 20
        suit.layout.reset(panelX, promptY)
        suit.Label("Player Name:", { align: "left" }, ...suit.layout.row(panelW, 25))

        // Input field for name
        const inputY = promptY + 30
        const inputW = 280
        const inputH = 40
        suit.layout.reset(panelX, inputY)
        suit.Input(this.nameInput, {}, ...suit.layout.row(inputW, inputH))

        // Start button
        const btnW = 200
        const btnH = 50
        const startBtnY = inputY + inputH + 30
        suit.layout.reset(panelX, startBtnY)
        const startResult = suit.Button("Start Game", {}, ...suit.layout.row(btnW, btnH))
        if (startResult.hit) {
            // Set the player name and start the game
            const playerName = this.nameInput.text.trim()
            if (playerName.length > 0) {
                this.gameManager.player.name = playerName
                this.gameManager.switchToBoard()
            }
        }

        // Back button
        const backBtnY = startBtnY + btnH + 10
        suit.layout.reset(panelX, backBtnY)
        const backResult = suit.Button("Back", {}, ...suit.layout.row(btnW, btnH))
        if (backResult.hit) {
            this.gameManager.switchToMainMenu()
        }
    }
}