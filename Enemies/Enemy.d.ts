/** @noSelfInFile */
import Character from "../Character";
import { EnemyTypes } from "Enums";
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
    gameManager?: GameManager;
    numberOfHeldCards: number;
    numberOfCardsInDeck: number;
    level: number;
    enemyType: EnemyTypes;
    experience: number;
    name: string;
    constructor(level?: number, enemyType?: EnemyTypes, experience?: number, name?: string, numberOfHeldCards?: number, numberOfCardsInDeck?: number);
    load(gameManager: GameManager, data?: EnemyData): void;
    save(): EnemyData;
}
export {};
