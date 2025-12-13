/** @noSelfInFile */
import GameManager from "GameManager";
import { Ranks, Suits, TrumpRanks } from "../Enums";
interface CardData {
    id: string;
    suit: Suits;
    rank: Ranks | TrumpRanks;
    power: number;
    value: number;
    isSelected: boolean;
    cost: number;
    isTrump: boolean;
    name: string;
}
export default class Card {
    gameManager: GameManager;
    id: string;
    suit: Suits;
    rank: Ranks | TrumpRanks;
    power: number;
    value: number;
    isSelected: boolean;
    cost: number;
    isTrump: boolean;
    name: string;
    constructor(gameManager: GameManager, suit: Suits, rank: Ranks | TrumpRanks, power: number, value: number, name: string, isTrump?: boolean);
    isEqual(otherCard: Card): boolean;
    getCost(): number;
    getBaseCost(): number;
    save(): CardData;
    static load(gameManager: GameManager, data: CardData): Card;
    onSelect(): void;
    onUnselect(): void;
}
export {};
