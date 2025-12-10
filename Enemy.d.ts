/** @noSelfInFile */
import Card from "Card";
import Character from "./Character";
export interface EnemyData {
    hand: Card[];
    deck: Card[];
    discardPile: Card[];
}
export default class Enemy extends Character {
    numberOfHeldCards: number;
    numberOfCardsInDeck: number;
    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number);
    save(): EnemyData;
    getCardPower(): number;
    getCardValue(): number;
    removeAllCardsFromHand(): void;
}
