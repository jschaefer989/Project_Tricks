/** @noSelfInFile */

import Draw from "Draw"
import { Perks } from "Enums"
import GameManager from "GameManager"
import * as suit from "Libraries.suit-master.suit"
import Perk from "Perk"

export default class LevelUpScreen {
    gameManager: GameManager
    perks: Perk[]

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.perks = []
    }

    drawScreen(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 400
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36

        // Display title
        suit.layout.reset(panelX, labelY)
        suit.Label("Level Up!", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Draw perk buttons
        const btnW = 300
        const btnH = 50
        const perkStartY = labelY + labelHeight + 30
        const perkX = (screenW - btnW) / 2
        const perkPadding = 15

        let currentY = perkStartY
        for (const perk of this.perks) {
            suit.layout.reset(perkX, currentY)
            const perkResult = suit.Button(perk.getPerkName(), {}, ...suit.layout.row(btnW, btnH))
            if (perkResult.hit) {
                this.selectPerk(perk)
            }
            currentY += btnH + perkPadding
        }

        Draw.playerInfo(this.gameManager.player, this.gameManager)
        Draw.playerDeck(this.gameManager.player)
    }

    selectPerk(perk: Perk): void {
        this.gameManager.player.addPerk(perk)
        this.gameManager.map.advanceToNextTier()
        this.gameManager.switchToMap()
    }

    getBaseLevelRequirement(perk: Perks): number {
        switch (perk) {
            case Perks.EXTRA_CARD:
                return 2
            case Perks.EXTRA_DISCARD:
                return 2
            case Perks.INCREASED_LOOT:
                return 2
        }
    }

    setup(): void {
        this.addAvailablePerks()
    }

    addAvailablePerks(): void {
        for (const perk of Object.values(Perks)) {
            if (this.gameManager.player.level < this.getBaseLevelRequirement(perk)) {
                continue
            }
            if (this.gameManager.player.hasPerk(perk)) {
                continue
            }
            this.perks.push(new Perk(this.gameManager, perk))
        }
    }
}