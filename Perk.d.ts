/** @noSelfInFile */
import { Perks } from "Enums";
import GameManager from "GameManager";
export interface PerkData {
    perkType: Perks;
}
export default class Perk {
    gameManager: GameManager;
    perkType: Perks;
    constructor(gameManager: GameManager, perkType: Perks);
    save(): PerkData;
    static load(gameManager: GameManager, data: PerkData): Perk;
    getPerkName(): string;
}
