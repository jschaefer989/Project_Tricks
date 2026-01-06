import Card from "../Cards/Card";
import Asset from "./Asset";
import {
  Suits,
  AssetIds,
  Ranks,
  EdelRanks,
  CharacterTypes,
  HoverEffects,
} from "Enums";
import { exhaustiveGuard, isEmpty } from "Helpers";
import GameManager from "GameManager";
import * as push from "Libraries.push";
import Point from "Point";
import { Image } from "love.graphics";
const padding = 20;

interface AssetsForCard {
  baseAsset: Asset;
  suitAssets: Asset[];
  rankAsset: Asset;
}

export default class CardAssets {
  gameManager: GameManager;
  baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png");
  baseW = this.baseCard.getWidth();
  baseH = this.baseCard.getHeight();
  cardClick = love.audio.newSource("Assets/Sounds/CardClick.wav", "static");

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  addAsset(
    card: Card,
    cardX: number,
    cardY: number,
    includeClickHandler: boolean = true
  ): void {
    const assetId = CardAssets.getBaseAssetId(card);
    const baseCardAsset = new Asset(assetId, this.baseCard, cardX, cardY, {
      onClick: includeClickHandler ? () => card.onClick() : undefined,
      onHover: (gameManager: GameManager, asset: Asset) =>
        Card.onHover(gameManager, asset),
      hoverEffect: includeClickHandler ? [HoverEffects.SCALE_UP] : [HoverEffects.NONE]  ,
      clickSound: includeClickHandler ? this.cardClick : undefined,
    });
    this.gameManager.assetManager.addAsset(assetId, baseCardAsset);
    this.addSuitAsset(card, cardX, cardY, includeClickHandler);
    this.addRankAsset(card, cardX, cardY, includeClickHandler);
  }

  static getBaseAssetId(card: Card): string {
    return `${AssetIds.BASE_CARD_TEMPLATE}-${card.id}`;
  }

  addSuitAsset(
    card: Card,
    x: number,
    y: number,
    includeClickHandler: boolean = true
  ): void {
    const suitImagePath = CardAssets.getSuitAssetPath(card.suit);
    const onHoverCallback = (gameManager: GameManager, asset: Asset) =>
      Card.onHover(gameManager, asset);
    const normalAssetId = CardAssets.getSuitAssetId(card, 0);
    const normalPosition = this.getNormalSuitPosition(x, y);
    const normalAsset = new Asset(
      normalAssetId,
      love.graphics.newImage(suitImagePath),
      normalPosition.x,
      normalPosition.y,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: onHoverCallback,
        hoverEffect: includeClickHandler ? [HoverEffects.SCALE_UP] : [HoverEffects.NONE],
        clickSound: includeClickHandler ? this.cardClick : undefined,
      }
    );
    this.gameManager.assetManager.addAsset(
      CardAssets.getBaseAssetId(card),
      normalAsset
    );
    const flippedPosition = this.getFlippedSuitPosition(x, y);
    const flippedAssetId = CardAssets.getSuitAssetId(card, 1);
    const flippedAsset = new Asset(
      flippedAssetId,
      love.graphics.newImage(suitImagePath),
      flippedPosition.x,
      flippedPosition.y,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: onHoverCallback,
        orientation: 0,
        hoverEffect: includeClickHandler ? [HoverEffects.SCALE_UP] : [HoverEffects.NONE],
        scaleX: -1,
        scaleY: -1,
        clickSound: includeClickHandler ? this.cardClick : undefined,
      }
    );
    this.gameManager.assetManager.addAsset(
      CardAssets.getBaseAssetId(card),
      flippedAsset
    );
  }

  getNormalSuitPosition(x: number, y: number): Point {
    return { x: x + 10, y: y + 10 };
  }

  getFlippedSuitPosition(x: number, y: number): Point {
    return { x: x + this.baseW - 10, y: y + this.baseH - 10 };
  }

  addRankAsset(
    card: Card,
    x: number,
    y: number,
    includeClickHandler: boolean = true
  ): void {
    const rankImagePath = CardAssets.getRankAssetPath(card.rank);
    const rankImage = love.graphics.newImage(rankImagePath);
    const assetId = CardAssets.getRankAssetId(card, 0);
    const rankPosition = this.getRankPosition(x, y, rankImage);
    const asset = new Asset(
      assetId,
      rankImage,
      rankPosition.x,
      rankPosition.y,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: (gameManager: GameManager, asset: Asset) =>
          Card.onHover(gameManager, asset),
        hoverEffect: includeClickHandler ? [HoverEffects.SCALE_UP] : [HoverEffects.NONE],
        clickSound: includeClickHandler ? this.cardClick : undefined,
      }
    );
    this.gameManager.assetManager.addAsset(
      CardAssets.getBaseAssetId(card),
      asset
    );
  }

  getRankPosition(x: number, y: number, rankImage: Image): Point {
    const rankW = rankImage.getWidth();
    const rankH = rankImage.getHeight();
    return {
      x: x + this.baseW / 2 - rankW / 2,
      y: y + this.baseH / 2 - rankH / 2,
    };
  }

  static getSuitAssetPath(suit: Suits): string {
    switch (suit) {
      case Suits.HEARTS:
        return "Assets/Images/HeartSuit.png";
      case Suits.BELLS:
        return "Assets/Images/BellSuit.png";
      case Suits.ACORNS:
        return "Assets/Images/AcornSuit.png";
      case Suits.LEAVES:
        return "Assets/Images/LeafSuit.png";
      default:
        exhaustiveGuard(suit);
    }
  }

  static getSuitAssetId(card: Card, orientation: number): string {
    return `${AssetIds.SUIT}-${card.id}-${orientation}`;
  }

  static getRankAssetPath(rank: Ranks | EdelRanks): string {
    switch (rank) {
      case Ranks.BANNER:
        return "Assets/Images/BannerRank.png";
      case Ranks.BARON:
        return "Assets/Images/BaronRank.png";
      case Ranks.DEUCE:
        return "Assets/Images/DeuceRank.png";
      case Ranks.JESTER:
        return "Assets/Images/JesterRank.png";
      case Ranks.KING:
        return "Assets/Images/KingRank.png";
      case Ranks.OVERLORD:
        return "Assets/Images/OverlordRank.png";
      case Ranks.PRIEST:
        return "Assets/Images/PriestRank.png";
      case Ranks.SERGEANT:
        return "Assets/Images/SergeantRank.png";
      case Ranks.SOLDIER:
        return "Assets/Images/SoldierRank.png";
      case Ranks.THIEF:
        return "Assets/Images/ThiefRank.png";
      case EdelRanks.BARD:
        return "Assets/Images/BardRank.png";
      case EdelRanks.CHOSEN:
        return "Assets/Images/ChosenRank.png";
      case EdelRanks.DEVIL:
        return "Assets/Images/DevilRank.png";
      case EdelRanks.DUKE:
        return "Assets/Images/DukeRank.png";
      case EdelRanks.EMPEROR:
        return "Assets/Images/EmperorRank.png";
      case EdelRanks.POPE:
        return "Assets/Images/PopeRank.png";
      case EdelRanks.KNIGHT:
        return "Assets/Images/KnightRank.png";
      default:
        exhaustiveGuard(rank);
    }
  }

  static getRankAssetId(card: Card, orientation: number): string {
    return `${AssetIds.RANK}-${card.id}-${orientation}`;
  }

  hideCardAssets(card: Card): void {
    this.gameManager.assetManager.hideAsset(CardAssets.getBaseAssetId(card));
  }

  centerCards(characterType: CharacterTypes): void {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return;
    }
    const cardCount = character.hand.length;
    const screenW = push.getWidth();
    const totalW =
      cardCount * this.baseW + Math.max(0, cardCount - 1) * padding;
    const startX = Math.floor((screenW - totalW) / 2);
    const cardY = this.getCardPosition(characterType);

    for (let i = 0; i < character.hand.length; i++) {
      const card = character.hand[i];
      const x = startX + i * (this.baseW + padding);

      this.updateCardPosition(card, x, cardY);
    }
  }

  updateCardPosition(card: Card, x: number, y: number): void {
    const assetManager = this.gameManager.assetManager;
    const baseAssetId = CardAssets.getBaseAssetId(card);
    assetManager.getAsset(baseAssetId, baseAssetId)?.updatePosition(x, y);
    assetManager
      .getAsset(baseAssetId, CardAssets.getSuitAssetId(card, 0))
      ?.updatePosition(x + 10, y + 10);
    assetManager
      .getAsset(baseAssetId, CardAssets.getSuitAssetId(card, 1))
      ?.updatePosition(x + this.baseW - 10, y + this.baseH - 10);

    const rankAsset = this.getRankAsset(card);
    if (isEmpty(rankAsset)) {
      return;
    }
    const rankPosition = this.getRankPosition(x, y, rankAsset.image);
    assetManager
      .getAsset(baseAssetId, CardAssets.getRankAssetId(card, 0))
      ?.updatePosition(rankPosition.x, rankPosition.y);
  }

  getRankAsset(card: Card): Asset | undefined {
    return this.gameManager.assetManager.getAsset(
      CardAssets.getBaseAssetId(card),
      CardAssets.getRankAssetId(card, 0)
    );
  }

  getCardPosition(characterType: CharacterTypes): number {
    const screenH = push.getHeight();
    return screenH / 2 + this.getHeightModifier(characterType);
  }

  getHeightModifier(characterType: CharacterTypes): number {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return !this.gameManager.board?.showingEdelView
          ? -(this.baseH * 0.25)
          : this.baseH / 2;
      case CharacterTypes.ENEMY:
        return -(this.baseH * 1.5);
      default:
        exhaustiveGuard(characterType);
    }
  }

  determineCardStartingPosition(characterType: CharacterTypes): Point {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return { x: 0, y: 0 };
    }
    const cardCount = character.hand.length;
    const screenW = push.getWidth();
    const totalW =
      cardCount * this.baseW + Math.max(0, cardCount - 1) * padding;
    return {
      x: Math.floor((screenW - totalW) / 2),
      y: this.getCardPosition(characterType),
    };
  }

  appendAsset(card: Card, characterType: CharacterTypes): void {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return;
    }
    const cardPosition = this.determineCardStartingPosition(characterType);
    const x =
      cardPosition.x + (character.hand.length - 1) * (this.baseW + padding);
    this.addAsset(
      card,
      x,
      cardPosition.y,
      characterType === CharacterTypes.PLAYER
    );
  }

  getCardAssets(card: Card): AssetsForCard {
    const baseAssetId = CardAssets.getBaseAssetId(card);
    const suitAssetId0 = CardAssets.getSuitAssetId(card, 0);
    const suitAssetId1 = CardAssets.getSuitAssetId(card, 1);
    const rankAssetId = CardAssets.getRankAssetId(card, 0);

    const baseAsset = this.gameManager.assetManager.getAsset(
      baseAssetId,
      baseAssetId
    );
    const suitAsset0 = this.gameManager.assetManager.getAsset(
      baseAssetId,
      suitAssetId0
    );
    const suitAsset1 = this.gameManager.assetManager.getAsset(
      baseAssetId,
      suitAssetId1
    );
    const rankAsset = this.gameManager.assetManager.getAsset(
      baseAssetId,
      rankAssetId
    );

    if (
      isEmpty(baseAsset) ||
      isEmpty(suitAsset0) ||
      isEmpty(suitAsset1) ||
      isEmpty(rankAsset)
    ) {
      throw new Error(`One or more assets for card ${card.id} are missing.`);
    }

    return {
      baseAsset: baseAsset,
      suitAssets: [suitAsset0, suitAsset1],
      rankAsset: rankAsset,
    };
  }
}
