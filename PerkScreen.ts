/** @noSelfInFile */

import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"

export default class PerkScreen {
    gameManager: GameManager

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 400
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36

        // Display title
        suit.layout.reset(panelX, labelY)
        suit.Label("Perks", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Display perks
        const perkStartY = labelY + labelHeight + 30
        const perkHeight = 30
        const perkPadding = 10

        let currentY = perkStartY
        
        if (this.gameManager.player.perks.length === 0) {
            suit.layout.reset(panelX, currentY)
            suit.Label("No perks yet", { align: "center" }, ...suit.layout.row(panelW, perkHeight))
        } else {
            for (const perk of this.gameManager.player.perks) {
                suit.layout.reset(panelX, currentY)
                suit.Label("• " + perk.getPerkName(), { align: "left" }, ...suit.layout.row(panelW, perkHeight))
                currentY += perkHeight + perkPadding
            }
        }

        // Back button
        const backBtnY = currentY + 30
        const btnW = 200
        const btnH = 50
        const backBtnX = (screenW - btnW) / 2
        
        suit.layout.reset(backBtnX, backBtnY)
        const backResult = suit.Button("Back", {}, ...suit.layout.row(btnW, btnH))
        if (backResult.hit) {
            this.gameManager.switchBasedOnGameState()
        }
    }
}