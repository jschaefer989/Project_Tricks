/** @noSelfInFile */

import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"
import Save from "Save"

const panelW = 240
const labelY = 50
const btnW = 200
const btnH = 50
const labelHeight = 36

export default class PauseMenu {
    gameManager: GameManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()

        const panelX = (screenW - panelW) / 2
        this.renderDisplayTitle(panelX)

        // Create a continue button below the label
        const continueBtnY = this.renderContinueButton(panelX)

        // Create a save button below the continue button
        const saveBtnY = this.renderSaveButton(panelX, continueBtnY)

        // Create a quit button below the save button
        this.renderQuitButton(panelX, saveBtnY)
    }

    renderDisplayTitle(panelX: number): void {
        suit.layout.reset(panelX, labelY)
        suit.Label("Paused", { align: "center" }, ...suit.layout.row(panelW, labelHeight))
    }

    renderContinueButton(panelX: number): number {
        const continueBtnY = labelY + labelHeight + 20
        suit.layout.reset(panelX, continueBtnY)
        const continueResult = suit.Button("Continue", {}, ...suit.layout.row(btnW, btnH))
        if (continueResult.hit) {
            this.gameManager.switchBasedOnGameState()
        }
        return continueBtnY
    }    

    renderSaveButton(panelX: number, continueBtnY: number): number {
        const saveBtnY = continueBtnY + btnH + 10
        suit.layout.reset(panelX, saveBtnY)
        const saveResult = suit.Button("Save", {}, ...suit.layout.row(btnW, btnH))
        if (saveResult.hit) {
            Save.save(this.gameManager)
        }
        return saveBtnY
    }

    renderQuitButton(panelX: number, saveBtnY: number): void {
        const quitBtnY = saveBtnY + btnH + 10
        suit.layout.reset(panelX, quitBtnY)
        const quitResult = suit.Button("Quit", {}, ...suit.layout.row(btnW, btnH))
        if (quitResult.hit) {
            love.event.quit()
        }
    }
}
