/** @noSelfInFile */
import GameManager from "GameManager";
import { Ranks, Suits, TrumpRanks } from "../Enums";
import Asset from "Assets/Asset";
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
    onClick(): void;
    onSelect(): void;
    onUnselect(): void;
    static onHover(gameManager: GameManager, asset: Asset): void;
}
export {};
