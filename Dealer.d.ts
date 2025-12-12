/** @noSelfInFile */
import Card from "./Card";
import GameManager from "./GameManager";
export default class Dealer {
    gameManager: GameManager;
    lootCards: Card[];
    constructor(gameManager: GameManager);
    setup(): void;
    static initializePlayerDeck(gameManager: GameManager): void;
    static shuffle(gameManager: GameManager, characterType: string): void;
    static dealCards(gameManager: GameManager, characterType: string): void;
    static getRandomCard(): Card;
    initializeEnemyDeck(): void;
    getLootCards(): Card[];
    addLootCard(card: Card): void;
    hasLootCard(card: Card): boolean;
    deselectLootCards(): void;
    addLootCardsToPlayer(): void;
}
