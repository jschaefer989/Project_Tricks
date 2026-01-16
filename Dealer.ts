/** @noSelfInFile */

import SlideAnimation from "Assets/Animations/SlideAnimation";
import { cardHeight, cardWidth, padding } from "Assets/CardAssets";
import Card from "Cards/Card";
import CardGenerator from "Cards/CardGenerator";
import * as push from "Libraries.push";
import Board from "Screens/Board";
import { AssetIds, CharacterTypes, Ranks, Suits } from "./Enums";
import GameManager from "./GameManager";
import { exhaustiveGuard, getRandomElementFromArray, isEmpty } from "./Helpers";
import Point from "./Point";
import { Source } from "love.audio";

export default class Dealer {
  gameManager: GameManager;
  lootCards: Card[];
  board: Board;
  dealSound: Source = love.audio.newSource("Assets/Sounds/Deal.wav", "static");

  constructor(gameManager: GameManager, board: Board) {
    this.gameManager = gameManager;
    this.board = board;
    this.lootCards = [];
  }

  setup(): void {
    if (this.gameManager.player.deck.length === 0) {
      Dealer.initializePlayerDeck(this.gameManager);
    }
    this.gameManager.player.unselectCards();
    this.initializeEnemyDeck();
  }

  dealEdel(): void {
    this.dealCards(CharacterTypes.PLAYER);
    this.dealCards(CharacterTypes.ENEMY);
    this.determineEdelSuit();
  }

  dealHandAtStartOfFight(): void {
    this.board.cardAssets.disableAllCards(true);
    const playerHandBefore = this.getCharacterHand(CharacterTypes.PLAYER);
    this.putCharacterHandBackInDeck(CharacterTypes.PLAYER);
    this.startReturnToDeckAnimation(
      CharacterTypes.PLAYER,
      playerHandBefore,
      () => this.finishPlayerDeal()
    );
  }

  dealAtStartOfFightForCharacter(character: CharacterTypes): void {
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
          CardGenerator.getNewCard(gameManager, rank, suit)
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
        continue;
      }

      const indexToUse = removedIndices ? removedIndices[index] : index;
      character.addToHand(card, indexToUse);

      // Add card asset at deck position first
      this.board.cardAssets.addAsset(
        card,
        deckPosition.x,
        deckPosition.y,
        characterType === CharacterTypes.PLAYER && !this.board.showingEdelView
      );

      // Calculate final position for this card using the final card count
      const handPosition = this.getCardPointInHand(
        characterType,
        indexToUse,
        finalCardCount
      );

      // Start slide animation from deck to final position
      this.startDealAnimation(
        characterType,
        card,
        handPosition.x,
        handPosition.y
      );
    }

    // Redraw the deck so that the cards aren't visible
    this.redrawDeck(characterType);
  }

  redrawDeck(characterType: CharacterTypes): void {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        const playerDeck = this.gameManager.assetManager.getAsset(
          AssetIds.PLAYER_DECK,
          AssetIds.PLAYER_DECK
        );
        this.gameManager.assetManager.removeAssets(AssetIds.PLAYER_DECK);
        if (!isEmpty(playerDeck)) {
          this.gameManager.assetManager.addAsset(
            AssetIds.PLAYER_DECK,
            playerDeck
          );
        }
        break;
      case CharacterTypes.ENEMY:
        const enemyDeck = this.gameManager.assetManager.getAsset(
          AssetIds.ENEMY_DECK,
          AssetIds.ENEMY_DECK
        );
        this.gameManager.assetManager.removeAssets(AssetIds.ENEMY_DECK);
        if (!isEmpty(enemyDeck)) {
          this.gameManager.assetManager.addAsset(
            AssetIds.ENEMY_DECK,
            enemyDeck
          );
        }
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
    const removedIndices = this.discardForCharacter(characterType);
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
    const playerIndices = this.discardCards(
      CharacterTypes.PLAYER,
      this.gameManager.player.getSelectedCards()
    );
    this.dealCards(CharacterTypes.PLAYER, playerIndices);

    const enemyIndices = this.discardCards(
      CharacterTypes.ENEMY,
      this.board.enemy.hand ?? []
    );
    this.dealCards(CharacterTypes.ENEMY, enemyIndices);
  }

  getDeckPosition(characterType: CharacterTypes): Point {
    const screenW = push.getWidth();
    const screenH = push.getHeight();
    const portraitPosition = this.board.getInfoPanel(characterType).getPortraitPosition();

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

  startDealAnimation(
    characterType: CharacterTypes,
    card: Card,
    targetX: number,
    targetY: number
  ): void {
    const { baseAsset } = this.board.cardAssets.getCardAssets(card);
    const slideAssets = this.board.cardAssets.getCardAssetList(card);

    const startX = baseAsset?.x ?? 0;
    const startY = baseAsset?.y ?? 0;
    const offsetX = targetX - startX;
    const offsetY = targetY - startY;

    this.gameManager.animationManager.startAnimation(
      card.id,
      new SlideAnimation(
        this.gameManager,
        card.id,
        this.gameManager.settings.dealerSpeed,
        offsetX,
        offsetY,
        slideAssets,
        {
          waitForAnimationIds:
            this.gameManager.animationManager.getCardAnimationIds(),
          onFinish: this.getDealFinishMethod(characterType),
          soundToPlay: this.dealSound,
        }
      )
    );
  }

  getDealFinishMethod(characterType: CharacterTypes): (() => void) | undefined {
    // If the edel view is showing, display it after dealing
    if (this.board.showingEdelView) {
      return () => this.board.displayEdel();
      // If both sides have zero points, start a fresh fight
    } else if (this.board.playerPoints === 0 && this.board.enemyPoints === 0) {
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
    this.gameManager.assetManager.disableAllClickableAssets(false);
    this.board.cardAssets.disableAllCards(false);
    this.board.updatePrimaryButtonStates();
    if (characterType === CharacterTypes.ENEMY) {
      this.board.tallyEnemyPowerAndValue();
    }
  }

  startDiscardAnimation(characterType: CharacterTypes, cards: Card[]): void {
    const targetY = this.getDiscardPosition(characterType);

    for (const card of cards) {
      const { baseAsset } = this.board.cardAssets.getCardAssets(card);
      const slideAssets = this.board.cardAssets.getCardAssetList(card);

      const startY = baseAsset?.y ?? 0;
      const offsetX = 0;
      const offsetY = targetY - startY;

      this.gameManager.animationManager.startAnimation(
        card.id,
        new SlideAnimation(
          this.gameManager,
          card.id,
          this.gameManager.settings.dealerSpeed,
          offsetX,
          offsetY,
          slideAssets,
          {
            onFinish: () => this.finishUpRemoveCardAnimation(card),
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
      const { baseAsset } = this.board.cardAssets.getCardAssets(card);
      const slideAssets = this.board.cardAssets.getCardAssetList(card);

      const startX = baseAsset?.x ?? 0;
      const startY = baseAsset?.y ?? 0;
      const offsetX = deckPosition.x - startX;
      const offsetY = deckPosition.y - startY;

      this.gameManager.animationManager.startAnimation(
        card.id,
        new SlideAnimation(
          this.gameManager,
          card.id,
          this.gameManager.settings.dealerSpeed,
          offsetX,
          offsetY,
          slideAssets,
          {
            onFinish: () => this.finishUpRemoveCardAnimation(card, onFinish),
            waitForAnimationIds:
              this.gameManager.animationManager.getCardAnimationIds(),
            soundToPlay: this.dealSound,
          }
        )
      );
    }
  }

  finishUpRemoveCardAnimation(card: Card, onFinish?: () => void): void {
    this.board.cardAssets.removeCardAssets(card);

    if (!this.gameManager.animationManager.hasAnimations()) {
        onFinish?.();
    }
  }

  initializeEnemyDeck(): void {
    for (let i = 0; i < this.board.enemy.numberOfCardsInDeck; i++) {
      this.board.enemy.addToDeck(CardGenerator.getRandomCard(this.gameManager));
    }
    Dealer.shuffle(this.gameManager, CharacterTypes.ENEMY);
  }

  determineEdelSuit(): void {
    const player = this.gameManager.player;
    let edelCard: Card | undefined = undefined;
    let lowestPower: number = 100;
    for (let index = 0; index < player.hand.length; index++) {
      const card = player.hand[index];
      if (index === 0 || card.getPower() < lowestPower) {
        lowestPower = card.getPower();
        edelCard = card;
      }
    }

    for (const card of this.board.enemy.hand) {
      if (card.getPower() < lowestPower) {
        lowestPower = card.getPower();
        edelCard = card;
      }
    }
    this.board.edelCard = edelCard;
  }

  getLootCards(): Card[] {
    this.lootCards = [];
    for (let i = 0; i < this.gameManager.player.numberOfLootCards; i++) {
      const card = getRandomElementFromArray(this.board.enemy.discardPile) as
        | Card
        | undefined;
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
      card.onDiscard();
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
