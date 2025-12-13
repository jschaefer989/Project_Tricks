/** @noSelfInFile */

import { Perks } from "Enums"
import GameManager from "GameManager"
import { exhaustiveGuard } from "Helpers"

export interface PerkData {
    perkType: Perks
}

export default class Perk {
    gameManager: GameManager
    perkType: Perks

    constructor(gameManager: GameManager, perkType: Perks) {
        this.gameManager = gameManager
        this.perkType = perkType
    }

    save(): PerkData {
        return {
            perkType: this.perkType
        }
    }

    static load(gameManager: GameManager, data: PerkData): Perk {
        return new Perk(gameManager, data.perkType)
    }

    getPerkName(): string {
        switch (this.perkType) {
            case Perks.EXTRA_CARD:
                return "Extra Card"
            case Perks.EXTRA_DISCARD:
                return "Extra Discard"
            case Perks.INCREASED_LOOT:
                return "Increased Loot"
            default:
                exhaustiveGuard(this.perkType)
        }
    }
}
