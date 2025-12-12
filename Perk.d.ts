/** @noSelfInFile */
import { Perks } from "Enums";
import GameManager from "GameManager";
export default class Perk {
    gameManager: GameManager;
    perkType: Perks;
    constructor(gameManager: GameManager, perkType: Perks);
    getPerkName(): string;
}
