/** @noSelfInFile */

import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"
import Save from "Save"

export default class MainMenu {
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

        // Display a game over message (centered)
        suit.layout.reset(panelX, labelY)
        suit.Label("Tricks", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Create a continue button below the title
        const btnW = 200
        const btnH = 50
        const continueBtnY = labelY + labelHeight + 20
        const saveExists = love.filesystem.getInfo("savegame.json")
        if (saveExists) {
            suit.layout.reset(panelX, continueBtnY)
            const continueResult = suit.Button("Continue", {}, ...suit.layout.row(btnW, btnH))
            if (continueResult.hit) {
                Save.load(this.gameManager)
                this.gameManager.switchBasedOnGameState()
            }
        }

        // Create a new game button below the continue button
        const newGameBtnY = saveExists ? continueBtnY + btnH + 10 : continueBtnY
        suit.layout.reset(panelX, newGameBtnY)
        const newGameResult = suit.Button("New Game", {}, ...suit.layout.row(btnW, btnH))
        if (newGameResult.hit) {
            // TODO: need an are you sure prompt here
            this.gameManager.switchToNewGameMenu()
        }

        // Create a quit button below the new game button
        const quitBtnY = newGameBtnY + btnH + 10
        suit.layout.reset(panelX, quitBtnY)
        const quitResult = suit.Button("Quit", {}, ...suit.layout.row(btnW, btnH))
        if (quitResult.hit) {
            love.event.quit()
        }
    }
}
