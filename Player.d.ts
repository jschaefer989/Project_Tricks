/** @noSelfInFile */
import Card from "./Card";
import Character from "./Character";
interface PlayerData {
    name?: string;
    money?: number;
    experience?: number;
    level?: number;
    discards?: number;
    numberOfLootCards?: number;
    hand?: Card[];
    deck?: Card[];
    discardPile?: Card[];
}
export default class Player extends Character {
    name: string;
    money: number;
    experience: number;
    level: number;
    discards: number;
    numberOfLootCards: number;
    constructor();
    load(data: PlayerData): void;
    save(): PlayerData;
    getCardPower(): number;
    getCardValue(): number;
    removeSelectedCardsFromHand(): void;
    discard(): void;
    anySelectedCards(): boolean;
    cashout(points: number): void;
    deselectAllCards(): void;
}
export {};
