/** @noSelfInFile */

import Card, { CardData } from "Cards/Card";
import Dealer from "Dealer";
import { CharacterTypes, Perks, TextIds } from "Enums";
import GameManager from "GameManager";
import Perk, { PerkData } from "Perk";
import Character from "./Character";

interface PlayerData {
  name: string;
  money: number;
  experience: number;
  level: number;
  discards: number;
  numberOfLootCards: number;
  hand: CardData[];
  deck: CardData[];
  discardPile: CardData[];
  perks: PerkData[];
}

export default class Player extends Character {
  name = "Player";
  money = 0;
  experience = 0;
  level = 1;
  discards = 3;
  numberOfLootCards = 3;
  perks: Perk[] = [];

  constructor(gameManager: GameManager) {
    super(gameManager, CharacterTypes.PLAYER);
  }

  load(data: PlayerData): void {
    this.name = data.name;
    this.money = data.money;
    this.experience = data.experience;
    this.level = data.level;
    this.discards = data.discards;
    this.numberOfLootCards = data.numberOfLootCards;
    this.hand = data.hand.map((cardData) =>
      Card.load(this.gameManager, cardData)
    );
    this.deck = data.deck.map((cardData) =>
      Card.load(this.gameManager, cardData)
    );
    this.discardPile = data.discardPile.map((cardData) =>
      Card.load(this.gameManager, cardData)
    );
    this.perks = data.perks.map((perkData) =>
      Perk.load(this.gameManager, perkData)
    );
  }

  save(): PlayerData {
    return {
      name: this.name,
      money: this.money,
      experience: this.experience,
      level: this.level,
      discards: this.discards,
      numberOfLootCards: this.numberOfLootCards,
      hand: this.hand.map((card) => card.save()),
      deck: this.deck.map((card) => card.save()),
      discardPile: this.discardPile.map((card) => card.save()),
      perks: this.perks.map((perk) => perk.save()),
    };
  }

  setup(): void {
    if (this.deck.length === 0) {
      Dealer.initializePlayerDeck(this.gameManager);
    }
  }

  anySelectedCards(): boolean {
    for (const card of this.hand) {
      if (card.isSelected) {
        return true;
      }
    }
    return false;
  }

  getSelectedCards(): Card[] {
    const selectedCards: Card[] = [];
    for (const card of this.hand) {
      if (card.isSelected) {
        selectedCards.push(card);
      }
    }
    return selectedCards;
  }

  cashout(points: number): void {
    if (points < 0) return;
    this.addMoney(points);
  }

  addMoney(amount: number): void {
    this.money += amount;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_PORTRAIT_MONEY,
      `${this.money}`
    );
  }

  hasPerk(perkType: Perks): boolean {
    for (const perk of this.perks) {
      if (perk.perkType === perkType) {
        return true;
      }
    }
    return false;
  }

  addPerk(perk: Perk): void {
    this.perks.push(perk);
  }

  gatherExperience(exp: number): boolean {
    this.addExperience(exp);

    if (this.experience >= this.getNextLevelExperience()) {
      this.levelUp();
      return true;
    }
    return false;
  }

  getNextLevelExperience(): number {
    switch (this.level) {
      case 1:
        return 100;
      case 2:
        return 150;
      case 3:
        return 250;
      case 4:
        return 500;
      default:
        return 1000;
    }
  }

  levelUp(): void {
    this.experience = 0;
  }

  addExperience(exp: number): void {
    this.experience += exp;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_PORTRAIT_EXPERIENCE,
      `${this.experience} XP`
    );
  }

  unselectCards(): void {
    for (const card of this.hand) {
      if (card.isSelected) {
        card.onUnselect();
      }
    }
  }

  discard(): number[] {
    const newHand: Card[] = [];
    const removedIndices: number[] = [];
    for (let index = 0; index < this.hand.length; index++) {
      const card = this.hand[index];
      if (card.isSelected) {
        card.onUnselect();
        this.addToDiscards(card);
        removedIndices.push(index);
      } else {
        newHand.push(card);
      }
    }
    this.hand = newHand;
    return removedIndices;
  }
}
