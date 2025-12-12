import Card from "Cards/Card";
export default class Character {
    deck: Card[];
    hand: Card[];
    discardPile: Card[];
    numberOfHeldCards: number;
    constructor();
    addToHand(card: Card): void;
    getCardFromHand(position: number): Card | undefined;
    addToDeck(card: Card): void;
    getCardFromDeck(position: number): Card | undefined;
    addToDiscards(card: Card): void;
    getCardFromDiscards(position: number): Card | undefined;
    addDiscardsToDeck(): void;
    deselectAllCards(): void;
}
