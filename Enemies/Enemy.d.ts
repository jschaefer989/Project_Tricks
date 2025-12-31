/** @noSelfInFile */
import { CardData } from "Cards/Card";
import Character from "../Character";
import { EnemyTypes } from "Enums";
import GameManager from "GameManager";
export interface EnemyData {
    hand: CardData[];
    deck: CardData[];
    discardPile: CardData[];
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
    name: string;
    constructor(gameManager: GameManager, level?: number, enemyType?: EnemyTypes, experience?: number, name?: string, numberOfHeldCards?: number, numberOfCardsInDeck?: number);
    load(gameManager: GameManager, data?: EnemyData): void;
    save(): EnemyData;
}
