/** @noSelfInFile */
import GameManager from "GameManager";
import { Ranks, Suits, TrumpRanks } from "../Enums";
export default class Card {
    gameManager: GameManager;
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
    onSelect(): void;
    onUnselect(): void;
}
