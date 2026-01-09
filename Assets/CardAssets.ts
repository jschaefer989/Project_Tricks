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

export const padding = 5;
export const cardWidth = 71;
export const cardHeight = 97;

interface AssetsForCard {
  baseAsset?: Asset;
  suitAssets: (Asset | undefined)[];
  rankAsset?: Asset;
}

export default class CardAssets {
  gameManager: GameManager;
  baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png");
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
    const baseCardAsset = new Asset(
      assetId,
      this.baseCard,
      cardX,
      cardY,
      cardWidth,
      cardHeight,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: (asset: Asset) => card.onHover(asset),
        onUnhover: (asset: Asset) => card.onUnhover(asset),
        hoverEffect: includeClickHandler
          ? [HoverEffects.SCALE_UP]
          : [HoverEffects.NONE],
        clickSound: includeClickHandler ? this.cardClick : undefined,
        isDisabled: true,
        useDisabledAnimation: false,
      }
    );
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
    const onHoverCallback = (asset: Asset) => card.onHover(asset);
    const normalAssetId = CardAssets.getSuitAssetId(card, 0);
    const normalPosition = this.getNormalSuitPosition(x, y);
    const normalAsset = new Asset(
      normalAssetId,
      love.graphics.newImage(suitImagePath),
      normalPosition.x,
      normalPosition.y,
      16,
      16,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: onHoverCallback,
        onUnhover: (asset: Asset) => card.onUnhover(asset),
        hoverEffect: includeClickHandler
          ? [HoverEffects.SCALE_UP]
          : [HoverEffects.NONE],
        clickSound: includeClickHandler ? this.cardClick : undefined,
        isDisabled: true,
        useDisabledAnimation: false,
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
      16,
      16,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: onHoverCallback,
        onUnhover: (asset: Asset) => card.onUnhover(asset),
        orientation: 0,
        hoverEffect: includeClickHandler
          ? [HoverEffects.SCALE_UP]
          : [HoverEffects.NONE],
        scaleX: -1,
        scaleY: -1,
        clickSound: includeClickHandler ? this.cardClick : undefined,
        isDisabled: true,
        useDisabledAnimation: false,
      }
    );
    this.gameManager.assetManager.addAsset(
      CardAssets.getBaseAssetId(card),
      flippedAsset
    );
  }

  getNormalSuitPosition(x: number, y: number): Point {
    return { x: x + padding + 1, y: y + padding + 1 };
  }

  getFlippedSuitPosition(x: number, y: number): Point {
    return { x: x + cardWidth - padding - 1, y: y + cardHeight - padding - 1 };
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
      64,
      64,
      {
        onClick: includeClickHandler ? () => card.onClick() : undefined,
        onHover: (asset: Asset) => card.onHover(asset),
        onUnhover: (asset: Asset) => card.onUnhover(asset),
        hoverEffect: includeClickHandler
          ? [HoverEffects.SCALE_UP]
          : [HoverEffects.NONE],
        clickSound: includeClickHandler ? this.cardClick : undefined,
        isDisabled: true,
        useDisabledAnimation: false,
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
      x: x + cardWidth / 2 - rankW / 2,
      y: y + cardHeight / 2 - rankH / 2,
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

  removeCardAssets(card: Card): void {
    this.gameManager.assetManager.removeAssets(CardAssets.getBaseAssetId(card));
  }

  hideCardAssets(card: Card): void {
    const assetsForCard = this.getCardAssets(card);
    if (isEmpty(assetsForCard.baseAsset)) {
      return;
    }
    assetsForCard.baseAsset.isHidden = true;
    for (const suitAsset of assetsForCard.suitAssets) {
      if (!isEmpty(suitAsset)) {
        suitAsset.isHidden = true;
      }
    }
    if (!isEmpty(assetsForCard.rankAsset)) {
      assetsForCard.rankAsset.isHidden = true;
    }
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
          ? -(cardHeight * 0.25)
          : cardHeight / 2;
      case CharacterTypes.ENEMY:
        return -(cardHeight * 1.5);
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
    const totalW = cardCount * cardWidth + Math.max(0, cardCount - 1) * padding;
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
      cardPosition.x + (character.hand.length - 1) * (cardWidth + padding);
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

    return {
      baseAsset: baseAsset,
      suitAssets: [suitAsset0, suitAsset1],
      rankAsset: rankAsset,
    };
  }

  getCardAssetList(card: Card): Asset[] {
    const { baseAsset, suitAssets, rankAsset } = this.getCardAssets(card);
    const assets: Asset[] = [];
    if (!isEmpty(baseAsset)) assets.push(baseAsset);
    if (!isEmpty(rankAsset)) assets.push(rankAsset);
    if (!isEmpty(suitAssets[0])) assets.push(suitAssets[0]);
    if (!isEmpty(suitAssets[1])) assets.push(suitAssets[1]);
    return assets;
  }

  disableAllCards(disable: boolean): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    for (const card of this.gameManager.board.getAllCardsInPlay()) {
      for (const asset of this.getCardAssetList(card)) {
        asset.isDisabled = disable;
      }
    }
  }
}
