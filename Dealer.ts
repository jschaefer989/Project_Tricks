/** @noSelfInFile */

import {
  Suits,
  Ranks,
  CharacterTypes,
  EdelRanks,
  AnimationIds,
  AssetIds,
} from "./Enums";
import {
  exhaustiveGuard,
  getRandomElementFromArray,
  getRandomElementFromEnum,
  isEmpty,
} from "./Helpers";
import Card from "Cards/Card";
import Banner from "Cards/Banner";
import GameManager from "./GameManager";
import Deuce from "Cards/Deuce";
import Jester from "Cards/Jester";
import King from "Cards/King";
import Overlord from "Cards/Overlord";
import Priest from "Cards/Priest";
import Sergeant from "Cards/Sergeant";
import Thief from "Cards/Thief";
import Soldier from "Cards/Soldier";
import Bard from "Cards/Bard";
import Devil from "Cards/Devil";
import Duke from "Cards/Duke";
import Emperor from "Cards/Emperor";
import Knight from "Cards/Knight";
import Point from "./Point";
import * as push from "Libraries.push";
import { cardWidth, cardHeight, padding } from "Assets/CardAssets";
import SlideAnimation from "Assets/Animations/SlideAnimation";
import Pope from "Cards/Pope";
import Chosen from "Cards/Chosen";
import Baron from "Cards/Baron";
import Board from "Screens/Board";

export default class Dealer {
  gameManager: GameManager;
  lootCards: Card[];
  board: Board;

  constructor(gameManager: GameManager, board: Board) {
    this.gameManager = gameManager;
    this.board = board;
    this.lootCards = [];
  }

  setup(): void {
    if (this.gameManager.player.deck.length === 0) {
      Dealer.initializePlayerDeck(this.gameManager);
    }
    this.gameManager.player.deselectAllCards();
    this.initializeEnemyDeck();
  }

  dealEdel(): void {
    this.dealCards(CharacterTypes.PLAYER);
    this.dealCards(CharacterTypes.ENEMY);
    this.determineEdelSuit();
  }

  dealHandAtStartOfFight(): void {
    const playerHandBefore = this.getCharacterHand(CharacterTypes.PLAYER);
    this.putCharacterHandBackInDeck(CharacterTypes.PLAYER);
    this.startReturnToDeckAnimation(
      CharacterTypes.PLAYER,
      playerHandBefore,
      () => this.finishPlayerDeal()
    );
  }

  dealAtStartOfFightForCharacter(character: CharacterTypes): void {
    this.board.cardAssets.disableAllCards(true);
    this.convertToEdelSuitForCharacter(character);
    Dealer.shuffle(this.gameManager, character);
    this.dealCards(character);

    if (character === CharacterTypes.ENEMY) {
      this.board.tallyEnemyPowerAndValue();
    }
  }

  finishPlayerDeal(): void {
    this.dealAtStartOfFightForCharacter(CharacterTypes.PLAYER);

    // After player is done, do enemy
    const enemyHandBefore = this.getCharacterHand(CharacterTypes.ENEMY);
    this.putCharacterHandBackInDeck(CharacterTypes.ENEMY);
    this.startReturnToDeckAnimation(
      CharacterTypes.ENEMY,
      enemyHandBefore,
      () => {
        this.dealAtStartOfFightForCharacter(CharacterTypes.ENEMY);
      }
    );
  }

  getCharacterHand(characterType: CharacterTypes): Card[] {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return this.gameManager.player.hand;
      case CharacterTypes.ENEMY:
        return this.board.enemy.hand ?? [];
      default:
        exhaustiveGuard(characterType);
    }
  }

  putCharacterHandBackInDeck(characterType: CharacterTypes): void {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        this.gameManager.player.putHandBackInDeck();
        break;
      case CharacterTypes.ENEMY:
        this.board.enemy.putHandBackInDeck();
        break;
      default:
        exhaustiveGuard(characterType);
    }
  }

  // This needs to be static so it can be called when the player is initialized
  static initializePlayerDeck(gameManager: GameManager): void {
    // TODO: We're just gonna insert all of the cards into the player deck for now
    // Eventually, we might want to let players pick their starting cards and then they'll
    // add to their deck based on what they loot from fights and get from shops
    for (const suit of Object.values(Suits)) {
      for (const rank of Object.values(Ranks)) {
        gameManager.player.addToDeck(
          Dealer.getNewCard(gameManager, rank, suit)
        );
      }
    }
    Dealer.shuffle(gameManager, CharacterTypes.PLAYER);
  }

  static shuffle(gameManager: GameManager, characterType: string): void {
    const character = gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return;
    }

    for (let i = character.deck.length - 1; i >= 1; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = character.deck[i];
      character.deck[i] = character.deck[j];
      character.deck[j] = temp;
    }
  }

  static getNewCard(
    gameManager: GameManager,
    rank: Ranks | EdelRanks,
    suit: Suits
  ): Card {
    switch (rank) {
      case Ranks.BANNER:
        return new Banner(gameManager, suit);
      case Ranks.BARON:
        return new Baron(gameManager, suit);
      case Ranks.DEUCE:
        return new Deuce(gameManager, suit);
      case Ranks.JESTER:
        return new Jester(gameManager, suit);
      case Ranks.KING:
        return new King(gameManager, suit);
      case Ranks.OVERLORD:
        return new Overlord(gameManager, suit);
      case Ranks.PRIEST:
        return new Priest(gameManager, suit);
      case Ranks.SERGEANT:
        return new Sergeant(gameManager, suit);
      case Ranks.THIEF:
        return new Thief(gameManager, suit);
      case Ranks.SOLDIER:
        return new Soldier(gameManager, suit);
      case EdelRanks.BARD:
        return new Bard(gameManager, suit);
      case EdelRanks.DEVIL:
        return new Devil(gameManager, suit);
      case EdelRanks.DUKE:
        return new Duke(gameManager, suit);
      case EdelRanks.EMPEROR:
        return new Emperor(gameManager, suit);
      case EdelRanks.KNIGHT:
        return new Knight(gameManager, suit);
      case EdelRanks.POPE:
        return new Pope(gameManager, suit);
      case EdelRanks.CHOSEN:
        return new Chosen(gameManager, suit);
      default:
        exhaustiveGuard(rank);
    }
  }

  static getRandomCard(gameManager: GameManager): Card {
    const suit = getRandomElementFromEnum(Suits);
    const rank = getRandomElementFromEnum(Ranks);
    return Dealer.getNewCard(gameManager, rank, suit);
  }

  dealCards(characterType: CharacterTypes, removedIndices?: number[]): void {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return;
    }

    const cardsToDeal = character.numberOfHeldCards - character.hand.length;

    // Determine deck position (where cards slide from)
    const deckPosition = this.getDeckPosition(characterType);

    // Calculate the final total card count after all cards are dealt
    const finalCardCount = character.hand.length + cardsToDeal;

    for (let index = 0; index < cardsToDeal; index++) {
      const card = character.deck.pop();
      if (isEmpty(card)) {
        continue
      }

      const indexToUse = removedIndices ? removedIndices[index] : index;
      character.addToHand(card, indexToUse);

      // Add card asset at deck position first
      this.board.cardAssets.addAsset(
        card,
        deckPosition.x,
        deckPosition.y,
        characterType === CharacterTypes.PLAYER &&
          !this.board.showingEdelView
      );

      // Calculate final position for this card using the final card count
      const handPosition = this.getCardPointInHand(
        characterType,
        indexToUse,
        finalCardCount
      );

      // Start slide animation from deck to final position
      this.startDealAnimation(characterType, card, handPosition.x, handPosition.y);
    }

    // Redraw the deck so that the cards aren't visible
    this.redrawDeck(characterType);
  }

  redrawDeck(characterType: CharacterTypes): void {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        this.gameManager.assetManager.removeAssets(AssetIds.PLAYER_DECK);
        this.board.buildPlayerDeck();
        break;
      case CharacterTypes.ENEMY:
        this.gameManager.assetManager.removeAssets(AssetIds.ENEMY_DECK);
        this.board.buildEnemyDeck();
        break;
      default:
        exhaustiveGuard(characterType);
    }
  }

  discardCards(characterType: CharacterTypes, cards: Card[]): number[] {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return [];
    }
    const removedIndices =  this.discardForCharacter(characterType);
    this.startDiscardAnimation(characterType, cards);
    return removedIndices;
  }

  discardForCharacter(characterType: CharacterTypes): number[] {
    switch (characterType) {
        case CharacterTypes.PLAYER:
            return this.gameManager.player.discard();
        case CharacterTypes.ENEMY:
            return this.board.enemy.discard() ?? [];
        default:
            exhaustiveGuard(characterType);
    }
  }

  dealNextHand(): void {
    const playerIndices = this.discardCards(CharacterTypes.PLAYER, this.gameManager.player.getSelectedCards());
    this.dealCards(CharacterTypes.PLAYER, playerIndices);

    const enemyIndices = this.discardCards(CharacterTypes.ENEMY, this.board.enemy.hand ?? []);
    this.dealCards(CharacterTypes.ENEMY, enemyIndices);
  }

  getDeckPosition(characterType: CharacterTypes): Point {
    const screenW = push.getWidth();
    const screenH = push.getHeight();
    const portraitPosition =
      this.board.getPortraitPosition(characterType);

    // Position decks on the sides of the screen
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return {
          x: screenW - cardWidth - 5,
          y: portraitPosition ?? screenH - 5,
        };
      case CharacterTypes.ENEMY:
        return { x: screenW - cardWidth - 5, y: portraitPosition ?? 5 };
      default:
        exhaustiveGuard(characterType);
    }
  }

  getCardPointInHand(
    characterType: CharacterTypes,
    cardIndex: number,
    totalCardCount: number
  ): Point {
    const screenW = push.getWidth();
    const screenH = push.getHeight();
    const individualCardWidth = cardWidth + padding;
    const totalW = individualCardWidth * totalCardCount - padding;
    const startX = Math.floor((screenW - totalW) / 2);
    const cardY =
      this.board.cardAssets.getHandYCoordinate(characterType) ??
      (characterType === CharacterTypes.PLAYER
        ? screenH - cardHeight - 20
        : 20);

    return {
      x: startX + cardIndex * individualCardWidth,
      y: cardY,
    };
  }

  startDealAnimation(characterType: CharacterTypes, card: Card, targetX: number, targetY: number): void { 
    const { baseAsset } = this.board.cardAssets.getCardAssets(card);
    const slideAssets =
      this.board.cardAssets.getCardAssetList(card);

    const startX = baseAsset?.x ?? 0;
    const startY = baseAsset?.y ?? 0;
    const offsetX = targetX - startX;
    const offsetY = targetY - startY;

    this.gameManager.animationManager.animations.set(
      AnimationIds.CARD_DEAL + card.id,
      new SlideAnimation(
        this.gameManager.settings.dealerSpeed,
        offsetX,
        offsetY,
        slideAssets,
        {
          waitForAnimationIds:
            this.gameManager.animationManager.getCardAnimationIds(),
          onFinish: this.getDealFinishMethod(characterType),
        }
      )
    );
  }

  getDealFinishMethod(characterType: CharacterTypes): (() => void) | undefined {
    // If the edel view is showing, display it after dealing
    if (this.board.showingEdelView) {
      return () => this.board.displayEdel();
    // If both sides have zero points, start a fresh fight
    } else if (
      this.board.playerPoints === 0 &&
      this.board.enemyPoints === 0
    ) {
      return () => this.board.displayFight();
    // Otherwise, the deal happened as part of normal gameplay
    } else {
        return () => this.finishDeal(characterType);
    }
  }

  finishDeal(characterType: CharacterTypes): void {
    if (this.gameManager.animationManager.hasAnimations()) {
      return;
    }
    this.board.cardAssets.disableAllCards(false);
    if (characterType === CharacterTypes.ENEMY) {
        this.board.tallyEnemyPowerAndValue();
    }    
  }

  startDiscardAnimation(characterType: CharacterTypes, cards: Card[]): void {
    const targetY = this.getDiscardPosition(characterType);

    for (const card of cards) {
      const { baseAsset } =
        this.board.cardAssets.getCardAssets(card);
      const slideAssets =
        this.board.cardAssets.getCardAssetList(card);

      const startY = baseAsset?.y ?? 0;
      const offsetX = 0;
      const offsetY = targetY - startY;

      this.gameManager.animationManager.startAnimation(
        AnimationIds.CARD_DISCARD + card.id,
        new SlideAnimation(
          this.gameManager.settings.dealerSpeed,
          offsetX,
          offsetY,
          slideAssets,
          {
            onFinish: () => this.finishUpAnimation(card),
            waitForAnimationIds:
              this.gameManager.animationManager.getCardAnimationIds(),
          }
        )
      );
    }
  }

  private getDiscardPosition(characterType: CharacterTypes): number {
    const screenH = push.getHeight();
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return screenH + cardHeight + 40;
      case CharacterTypes.ENEMY:
        return -cardHeight - 40;
      default:
        exhaustiveGuard(characterType);
    }
  }

  startReturnToDeckAnimation(
    characterType: CharacterTypes,
    cards: Card[],
    onFinish?: () => void
  ): void {
    const deckPosition = this.getDeckPosition(characterType);

    for (const card of cards) {
      const { baseAsset } =
        this.board.cardAssets.getCardAssets(card);
      const slideAssets =
        this.board.cardAssets.getCardAssetList(card);

      const startX = baseAsset?.x ?? 0;
      const startY = baseAsset?.y ?? 0;
      const offsetX = deckPosition.x - startX;
      const offsetY = deckPosition.y - startY;

      this.gameManager.animationManager.startAnimation(
        AnimationIds.CARD_RETURN_TO_DECK + card.id,
        new SlideAnimation(
          this.gameManager.settings.dealerSpeed,
          offsetX,
          offsetY,
          slideAssets,
          {
            onFinish: () => this.finishUpAnimation(card, onFinish),
            waitForAnimationIds:
              this.gameManager.animationManager.getCardAnimationIds(),
          }
        )
      );
    }
  }

  finishUpAnimation(card: Card, onFinish?: () => void): void {
    this.board.cardAssets.removeCardAssets(card);

    if (!this.gameManager.animationManager.hasAnimations()) {
      this.board.cardAssets.disableAllCards(false);
      onFinish?.();
    }
  }

  initializeEnemyDeck(): void {
    for (let i = 0; i < this.board.enemy.numberOfCardsInDeck; i++) {
      this.board.enemy.addToDeck(
        Dealer.getRandomCard(this.gameManager)
      );
    }
    Dealer.shuffle(this.gameManager, CharacterTypes.ENEMY);
  }

  determineEdelSuit(): void {
    const player = this.gameManager.player;
    let edelCard: Card | undefined = undefined;
    let lowestPower: number = 100;
    for (let index = 0; index < player.hand.length; index++) {
      const card = player.hand[index];
      if (index === 0 || card.power < lowestPower) {
        lowestPower = card.power;
        edelCard = card;
      }
    }

    for (const card of this.board.enemy.hand) {
      if (card.power < lowestPower) {
        lowestPower = card.power;
        edelCard = card;
      }
    }
    this.board.edelCard = edelCard;
  }

  convertToEdelSuit(card: Card): Card {
    if (card.suit !== this.board.edelCard?.suit) {
      return card;
    }

    switch (card.rank) {
      case Ranks.SOLDIER:
        return new Knight(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.BARON:
        return new Duke(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.JESTER:
        return new Bard(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.DEUCE:
        return new Emperor(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.PRIEST:
        return new Pope(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.THIEF:
        return new Devil(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case Ranks.SERGEANT:
        return new Chosen(
          this.gameManager,
          this.board.edelCard?.suit
        );
      default:
        return card;
    }
  }

  convertToEdelSuitForCharacter(characterType: string): void {
    const character = this.gameManager.getCharacter(characterType);

    if (isEmpty(character)) {
      return;
    }

    for (const card of character.deck) {
      if (card.suit !== this.board.edelCard?.suit) {
        continue;
      }
      const edelCard = this.convertToEdelSuit(card);
      if (edelCard !== card) {
        character.removeFromDeck(card);
        character.addToDeck(edelCard);
      }
    }
  }

  convertBackToOriginalSuit(card: Card): Card {
    if (card.suit !== this.board.edelCard?.suit) {
      return card;
    }

    switch (card.rank) {
      case EdelRanks.KNIGHT:
        return new Soldier(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.DUKE:
        return new Baron(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.BARD:
        return new Jester(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.EMPEROR:
        return new Deuce(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.POPE:
        return new Priest(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.DEVIL:
        return new Thief(
          this.gameManager,
          this.board.edelCard?.suit
        );
      case EdelRanks.CHOSEN:
        return new Sergeant(
          this.gameManager,
          this.board.edelCard?.suit
        );
      default:
        return card;
    }
  }

  convertBackToOriginalSuitForCharacter(characterType: string): void {
    const character = this.gameManager.getCharacter(characterType);

    if (isEmpty(character)) {
      return;
    }

    for (const edelCard of character.deck) {
      if (edelCard.suit !== this.board.edelCard?.suit) {
        continue;
      }
      const originalCard = this.convertBackToOriginalSuit(edelCard);
      if (originalCard !== edelCard) {
        character.removeFromDeck(edelCard);
        character.addToDeck(originalCard);
      }
    }
  }

  getLootCards(): Card[] {
    this.lootCards = [];
    for (let i = 0; i < this.gameManager.player.numberOfLootCards; i++) {
      const card = getRandomElementFromArray(
        this.board.enemy.discardPile
      ) as Card | undefined;
      if (card && !this.hasLootCard(card)) {
        this.addLootCard(card);
      } else {
        i--; // try again
      }
    }
    return this.lootCards;
  }

  addLootCard(card: Card): void {
    this.lootCards.push(card);
  }

  hasLootCard(card: Card): boolean {
    for (const lootCard of this.lootCards) {
      if (lootCard.isEqual(card)) {
        return true;
      }
    }
    return false;
  }

  deselectLootCards(): void {
    for (const card of this.lootCards) {
      card.onUnselect();
    }
  }

  addLootCardsToPlayer(): void {
    for (const card of this.lootCards) {
      if (card.isSelected) {
        this.gameManager.player.addToDeck(card);
      }
    }
  }
}
