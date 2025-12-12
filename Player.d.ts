/** @noSelfInFile */
import Perk from "Perk";
import Card from "Cards/Card";
import Character from "./Character";
import { Perks } from "Enums";
import GameManager from "GameManager";
interface PlayerData {
    name: string;
    money: number;
    experience: number;
    level: number;
    discards: number;
    numberOfLootCards: number;
    hand: Card[];
    deck: Card[];
    discardPile: Card[];
    perks: Perk[];
}
export default class Player extends Character {
    gameManager: GameManager;
    name: string;
    money: number;
    experience: number;
    level: number;
    discards: number;
    numberOfLootCards: number;
    perks: Perk[];
    constructor(gameManager: GameManager);
    load(data: PlayerData): void;
    save(): PlayerData;
    setup(): void;
    removeSelectedCardsFromHand(): void;
    discard(): void;
    anySelectedCards(): boolean;
    cashout(points: number): void;
    deselectAllCards(): void;
    hasPerk(perkType: Perks): boolean;
    addPerk(perk: Perk): void;
    gatherExperience(exp: number): boolean;
    getNextLevelExperience(): number;
    levelUp(): void;
}
export {};
