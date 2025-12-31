/** @noSelfInFile */
import { Suits, Ranks, CharacterTypes, EdelRanks } from "./Enums";
import Card from "Cards/Card";
import GameManager from "./GameManager";
export default class Dealer {
    gameManager: GameManager;
    lootCards: Card[];
    constructor(gameManager: GameManager);
    setup(): void;
    startGame(): void;
    static initializePlayerDeck(gameManager: GameManager): void;
    static shuffle(gameManager: GameManager, characterType: string): void;
    static getNewCard(gameManager: GameManager, rank: Ranks | EdelRanks, suit: Suits): Card;
    static getRandomCard(gameManager: GameManager): Card;
    dealCards(characterType: CharacterTypes): void;
    initializeEnemyDeck(): void;
    determineEdelSuit(): void;
    convertToEdelSuit(card: Card): Card;
    convertToEdelSuitForCharacter(characterType: string): void;
    convertBackToOriginalSuit(card: Card): Card;
    convertBackToOriginalSuitForCharacter(characterType: string): void;
    getLootCards(): Card[];
    addLootCard(card: Card): void;
    hasLootCard(card: Card): boolean;
    deselectLootCards(): void;
    addLootCardsToPlayer(): void;
}
