// PauseMenu.ts - TypeScript-to-Lua conversion of PauseMenu.lua

import GameManager from "GameManager"
import * as GameStateManager from "Libraries.GameStateManager-main.gamestateManager"
import * as suit from "Libraries.suit-master.suit"
import Save from "Save"

/** @noSelfInFile */

export default class PauseMenu {
    gameManager: GameManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    drawScreen(): void {
        // Display the victory message (centered)
        const screenW = love.graphics.getWidth()
        const panelW = 240
        const labelY = 50

        // Render player info panel centered under the Victory label
        const panelX = (screenW - panelW) / 2
        const labelHeight = 36
        // Use layout row for the Victory label
        suit.layout.reset(panelX, labelY)
        suit.Label("Paused", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        const panelY = labelY + labelHeight

        // Create a continue button below the label
        const btnW = 200
        const btnH = 50
        const continueBtnY = panelY + 20
        suit.layout.reset(panelX, continueBtnY)
        const continueResult = suit.Button("Continue", {}, ...suit.layout.row(btnW, btnH))
        if (continueResult.hit) {
            GameStateManager.revertState()
        }

        // Create a save button below the continue button
        const saveBtnY = continueBtnY + btnH + 10
        suit.layout.reset(panelX, saveBtnY)
        const saveResult = suit.Button("Save", {}, ...suit.layout.row(btnW, btnH))
        if (saveResult.hit) {
            Save.save(this.gameManager)
        }

        // Create a quit button below the save button
        const quitBtnY = saveBtnY + btnH + 10
        suit.layout.reset(panelX, quitBtnY)
        const quitResult = suit.Button("Quit", {}, ...suit.layout.row(btnW, btnH))
        if (quitResult.hit) {
            love.event.quit()
        }
    }
}
