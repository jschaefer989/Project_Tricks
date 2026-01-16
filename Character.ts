import Asset from "Assets/Asset";
import FontWithPosition from "Assets/Fonts/FontWithPosition";
import Card from "Cards/Card";
import { CharacterTypes, PopupIds, TextIds } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard, isEmpty } from "Helpers";
import * as lovelyToasts from "Libraries.Lovely-Toasts-main.lovelyToasts";
import { PopupSizes } from "Screens/Popup/Popup";

export default class Character {
  gameManager: GameManager;
  deck: Card[];
  hand: Card[];
  discardPile: Card[];
  numberOfHeldCards: number;
  type: CharacterTypes;
  name: string = "Character";
  level: number = 1;
  private lastSortTime = 0;
  private sortMode: SortMode = SortMode.POWER;

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

  getCardPower(): number {
    let power = 0;
    for (const card of this.hand) {
      power += card.getPower();
    }
    return power;
  }

  getCardValue(): number {
    let value = 0;
    for (const card of this.hand) {
      value += card.getValue();
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
        card.onDiscard();
      }
    }
    this.hand = [];
  }

  showDeckOverview(asset: Asset): void {
    this.gameManager.assetManager.tooltipManager.addTooltip(
      [
        new FontWithPosition(
          TextIds.TOOLTIP_DECK_OVERVIEW_CARDS,
          5,
          10,
          `Deck: ${this.deck.length}/${
            this.deck.length + this.discardPile.length + this.hand.length
          }`
        ),
        new FontWithPosition(
          TextIds.TOOLTIP_DECK_OVERVIEW_DISCARDS,
          5,
          20,
          `Discards: ${this.discardPile.length}`
        ),
      ],
      asset
    );
  }

  showDeckContents(): void {
    this.gameManager.popupManager.open(PopupIds.DECK_CONTENTS, `${this.name} Deck`, PopupSizes.MENU);
  }

  sortCards(): void {
    const now = os.time() * 1000; // Convert to milliseconds
    const timeSinceLastSort = now - this.lastSortTime;
    const threshold = 3000; // 3 seconds

    this.getSortMode(timeSinceLastSort, threshold);

    this.lastSortTime = now;
    this.applySort();
    this.redrawHand();
  }

  private getSortMode(timeSinceLastSort: number, threshold: number): void {
    // Determine if this is a quick successive click
    if (timeSinceLastSort < threshold) {
      // Cycle to next sort mode
      switch (this.sortMode) {
        case SortMode.POWER:
          this.sortMode = SortMode.VALUE;
          break;
        case SortMode.VALUE:
          this.sortMode = SortMode.SUIT;
          break;
        case SortMode.SUIT:
          this.sortMode = SortMode.POWER;
          break;
      }
    } else {
      // Reset to power sort if enough time has passed
      this.sortMode = SortMode.POWER;
    }
  }

  private applySort(): void {
    switch (this.sortMode) {
      case SortMode.POWER:
        this.sortByPower();
        break;
      case SortMode.VALUE:
        this.sortByValue();
        break;
      case SortMode.SUIT:
        this.sortBySuit();
        break;
    }
  }

  sortByPower(): void {
    this.hand = this.hand.sort((a, b) => b.getPower() - a.getPower());
    lovelyToasts.show("Sorted by Power", 2, "bottom");
  }

  sortByValue(): void {
    this.hand = this.hand.sort((a, b) => b.getValue() - a.getValue());
    lovelyToasts.show("Sorted by Value", 2, "bottom");
  }

  sortBySuit(): void {
    this.hand = this.hand.sort((a, b) =>
      a.suit === b.suit ? 0 : a.suit < b.suit ? -1 : 1
    );
    lovelyToasts.show("Sorted by Suit", 2, "bottom");
  }

  redrawHand(): void {
    if (isEmpty(this.gameManager.board)) return;

    const cardAssets = this.gameManager.board.cardAssets;
    const y = cardAssets.getHandYCoordinate(CharacterTypes.PLAYER);

    for (let index = 0; index < this.hand.length; index++) {
      const card = this.hand[index];
      const { x: targetX } = this.gameManager.board.dealer.getCardPointInHand(
        CharacterTypes.PLAYER,
        index,
        this.hand.length
      );
      cardAssets.repositionCard(card, targetX, y);
      cardAssets.redrawCard(card);
    }
    this.gameManager.board.cardAssets.disableAllCards(false);
  }
}

enum SortMode {
  POWER = "POWER",
  VALUE = "VALUE",
  SUIT = "SUIT",
}
