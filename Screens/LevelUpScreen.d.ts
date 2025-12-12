/** @noSelfInFile */
import { Perks } from "Enums";
import GameManager from "GameManager";
import Perk from "Perk";
export default class LevelUpScreen {
    gameManager: GameManager;
    perks: Perk[];
    constructor(gameManager: GameManager);
    drawScreen(): void;
    selectPerk(perk: Perk): void;
    getBaseLevelRequirement(perk: Perks): number;
    setup(): void;
    addAvailablePerks(): void;
}
