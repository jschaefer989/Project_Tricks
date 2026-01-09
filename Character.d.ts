import Card from "Cards/Card";
import { CharacterTypes } from "Enums";
import GameManager from "GameManager";
export default class Character {
    gameManager: GameManager;
    deck: Card[];
    hand: Card[];
    discardPile: Card[];
    numberOfHeldCards: number;
    type: CharacterTypes;
    constructor(gameManager: GameManager, type: CharacterTypes);
    addToHand(card: Card, index?: number): void;
    removeFromHand(card: Card): void;
    addToDeck(card: Card): void;
    addToDiscards(card: Card): void;
    addDiscardsToDeck(): void;
    deselectAllCards(): void;
    getCardPower(): number;
    getCardValue(): number;
    removeAllCardsFromHand(): void;
    removeFromDeck(card: Card): void;
    putHandBackInDeck(): void;
}
