/** @noSelfInFile */
import Perk, { PerkData } from "Perk";
import Character from "./Character";
import { Perks } from "Enums";
import GameManager from "GameManager";
interface CardData {
    id: string;
    suit: any;
    rank: any;
    power: number;
    value: number;
    isSelected: boolean;
    cost: number;
    isTrump: boolean;
    name: string;
}
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
    hasPerk(perkType: Perks): boolean;
    addPerk(perk: Perk): void;
    gatherExperience(exp: number): boolean;
    getNextLevelExperience(): number;
    levelUp(): void;
    unselectCards(): void;
}
export {};
