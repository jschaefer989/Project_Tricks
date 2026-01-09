import Card from "Cards/Card";
import { CharacterTypes } from "Enums";
import GameManager from "GameManager";
import { isEmpty } from "Helpers";

export default class Character {
  gameManager: GameManager;
  deck: Card[];
  hand: Card[];
  discardPile: Card[];
  numberOfHeldCards: number;
  type: CharacterTypes;

  constructor(gameManager: GameManager, type: CharacterTypes) {
    this.gameManager = gameManager;
    this.type = type;
    this.deck = [];
    this.hand = [];
    this.discardPile = [];
    this.numberOfHeldCards = 5;
  }

  addToHand(card: Card, index?: number): void {
    if (!isEmpty(index) && index >= 0 && index < this.hand.length) {
      this.hand.splice(index, 0, card);
    } else {
      this.hand.push(card);
    }
  }

  removeFromHand(card: Card): void {
    for (let index = 0; index < this.hand.length; index++) {
      const otherCard = this.hand[index];
      if (card.isEqual(otherCard)) {
        this.hand.splice(index, 1);
        break;
      }
    }
  }

  addToDeck(card: Card): void {
    this.deck.push(card);
  }

  addToDiscards(card: Card): void {
    this.discardPile.push(card);
  }

  addDiscardsToDeck(): void {
    for (const card of this.discardPile) {
      this.addToDeck(card);
    }
    this.discardPile = [];
  }

  deselectAllCards(): void {
    for (const card of this.hand) {
      card.onUnselect();
    }
  }

  getCardPower(): number {
    let power = 0;
    for (const card of this.hand) {
      power += card.power;
    }
    return power;
  }

  getCardValue(): number {
    let value = 0;
    for (const card of this.hand) {
      value += card.value;
    }
    return value;
  }

  removeAllCardsFromHand(): void {
    for (let i = this.hand.length - 1; i >= 0; i--) {
      const card = this.hand[i];
      this.addToDiscards(card);
      this.hand.splice(i, 1);
    }
  }

  removeFromDeck(card: Card): void {
    for (let index = 0; index < this.deck.length; index++) {
      const otherCard = this.deck[index];
      if (card.isEqual(otherCard)) {
        this.deck.splice(index, 1);
      }
    }
  }

  putHandBackInDeck(): void {    
    for (const card of this.hand) {
      this.addToDeck(card);
      if (card.isSelected) {
        card.onUnselect();
      }
    }
    this.hand = [];
  }
}
