/** @noSelfInFile */
import Card from "Card";
import Character from "./Character";
import { EnemyTypes } from "Enums";
export interface EnemyData {
    hand: Card[];
    deck: Card[];
    discardPile: Card[];
    level: number;
    numberOfHeldCards: number;
    numberOfCardsInDeck: number;
    enemyType: EnemyTypes;
}
export default class Enemy extends Character {
    numberOfHeldCards: number;
    numberOfCardsInDeck: number;
    level: number;
    enemyType: EnemyTypes;
    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number, level?: number, enemyType?: EnemyTypes);
    load(data?: EnemyData): void;
    save(): EnemyData;
    getCardPower(): number;
    getCardValue(): number;
    removeAllCardsFromHand(): void;
    getEnemyName(): string;
}
