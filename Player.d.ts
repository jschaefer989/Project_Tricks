/** @noSelfInFile */
import Card, { CardData } from "Cards/Card";
import { Perks } from "Enums";
import GameManager from "GameManager";
import Perk, { PerkData } from "Perk";
import Character from "./Character";
interface PlayerData {
    name: string;
    money: number;
    experience: number;
    level: number;
    discards: number;
    numberOfLootCards: number;
    hand: CardData[];
    deck: CardData[];
    discardPile: CardData[];
    perks: PerkData[];
}
export default class Player extends Character {
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
    anySelectedCards(): boolean;
    getSelectedCards(): Card[];
    cashout(points: number): void;
    addMoney(amount: number): void;
    hasPerk(perkType: Perks): boolean;
    addPerk(perk: Perk): void;
    gatherExperience(exp: number): boolean;
    getNextLevelExperience(): number;
    levelUp(): void;
    addExperience(exp: number): void;
    unselectCards(): void;
    discard(): number[];
}
export {};
