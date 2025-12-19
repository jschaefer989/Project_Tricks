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
    addToHand(card: Card): void;
    getCardFromHand(position: number): Card | undefined;
    addToDeck(card: Card): void;
    getCardFromDeck(position: number): Card | undefined;
    addToDiscards(card: Card): void;
    getCardFromDiscards(position: number): Card | undefined;
    addDiscardsToDeck(): void;
    deselectAllCards(): void;
    getCardPower(): number;
    getCardValue(): number;
    removeAllCardsFromHand(): void;
    removeFromDeck(card: Card): void;
    putHandBackInDeck(): void;
}
