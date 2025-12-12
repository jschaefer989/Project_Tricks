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
    experience: number;
}
export default class Enemy extends Character {
    numberOfHeldCards: number;
    numberOfCardsInDeck: number;
    level: number;
    enemyType: EnemyTypes;
    experience: number;
    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number, level?: number, enemyType?: EnemyTypes, experience?: number);
    load(data?: EnemyData): void;
    save(): EnemyData;
    getCardPower(): number;
    getCardValue(): number;
    removeAllCardsFromHand(): void;
    getEnemyName(): string;
    getExpeierenceReward(): number;
}
