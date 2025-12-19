import Card from "../Cards/Card";
import Asset from "./Asset";
import { Suits, AssetIds, Ranks, TrumpRanks } from "Enums";
import { exhaustiveGuard } from "Helpers";
import GameManager from "GameManager";
import * as push from "Libraries.push";
import Hoverable from "Hoverable"
const padding = 20;

interface CardOptions {
  multiSelect?: boolean;
  /**
   * Overrides the onSelect/onUnselect behavior for the card, which generally assumes that the card is rendered on the board
   * @param card
   * @returns
   */
  onClick?: (card: Card) => void;
  displayCost?: boolean;
}

export default class CardAssets {
  gameManager: GameManager;
  baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png");
  baseW = this.baseCard.getWidth();
  baseH = this.baseCard.getHeight();

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  addAsset(
    card: Card,
    cardX: number,
    cardY: number,
    options?: CardOptions
  ): void {
    const assetId = CardAssets.getCardAssetId(card);
    const hoverable = new Hoverable(card.id);
    const baseCardAsset = new Asset(
      assetId,
      this.baseCard,
      cardX,
      cardY,
      card.onClick,
      (gameManager: GameManager, asset: Asset) =>
        Card.onHover(gameManager, asset),
      this.baseW,
      this.baseH
    );
    baseCardAsset.setHoverable(hoverable);
    this.gameManager.assetManager.addAsset(assetId, baseCardAsset);
    this.addSuitAsset(card, cardX, cardY, this.baseW, this.baseH, hoverable);
    this.addRankAsset(card, cardX, cardY, this.baseW, this.baseH, hoverable);
  }

  static getCardAssetId(card: Card): string {
    return `${AssetIds.BASE_CARD_TEMPLATE}-${card.id}`;
  }

  addSuitAsset(
    card: Card,
    x: number,
    y: number,
    width: number,
    height: number,
    hoverable: Hoverable
  ): void {
    const suitImagePath = CardAssets.getSuitAssetPath(card.suit);
    const onHoverCallback = (gameManager: GameManager, asset: Asset) =>
      Card.onHover(gameManager, asset);
    const normalAssetId = CardAssets.getSuitAssetId(card, 0);
    const normalAsset = new Asset(
      normalAssetId,
      love.graphics.newImage(suitImagePath),
      x + 10,
      y + 10,
      card.onClick,
      onHoverCallback,
      width,
      height
    );
    this.gameManager.assetManager.addAsset(normalAssetId, normalAsset);
    normalAsset.setHoverable(hoverable);
    const flippedX = x + width - 10;
    const flippedY = y + height - 10;
    const flippedAssetId = CardAssets.getSuitAssetId(card, 1);
    const flippedAsset = new Asset(
      flippedAssetId,
      love.graphics.newImage(suitImagePath),
      flippedX,
      flippedY,
      card.onClick,
      onHoverCallback,
      width,
      height,
      0,
      -1,
      -1
    );
    this.gameManager.assetManager.addAsset(flippedAssetId, flippedAsset);
    flippedAsset.setHoverable(hoverable);
  }

  addRankAsset(
    card: Card,
    x: number,
    y: number,
    width: number,
    height: number,
    hoverable: Hoverable
  ): void {
    const rankImagePath = CardAssets.getRankAssetPath(card.rank);
    const rankImage = love.graphics.newImage(rankImagePath);
    const rankW = rankImage.getWidth();
    const rankH = rankImage.getHeight();
    const assetId = CardAssets.getRankAssetId(card, 0);
    const asset = new Asset(
      assetId,
      rankImage,
      x + this.baseW / 2 - rankW / 2,
      y + this.baseH / 2 - rankH / 2,
      card.onClick,
      (gameManager: GameManager, asset: Asset) =>
        Card.onHover(gameManager, asset),
      width,
      height
    );
    this.gameManager.assetManager.addAsset(assetId, asset);
    asset.setHoverable(hoverable);
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

  static getRankAssetPath(rank: Ranks | TrumpRanks): string {
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
      case TrumpRanks.BARD:
        return "Assets/Images/BardRank.png";
      case TrumpRanks.CHOSEN:
        return "Assets/Images/ChosenRank.png";
      case TrumpRanks.DEVIL:
        return "Assets/Images/DevilRank.png";
      case TrumpRanks.DUKE:
        return "Assets/Images/DukeRank.png";
      case TrumpRanks.EMPEROR:
        return "Assets/Images/EmperorRank.png";
      case TrumpRanks.POPE:
        return "Assets/Images/PopeRank.png";
      case TrumpRanks.KNIGHT:
        return "Assets/Images/KnightRank.png";
      default:
        exhaustiveGuard(rank);
    }
  }

  static getRankAssetId(card: Card, orientation: number): string {
    return `${AssetIds.RANK}-${card.id}-${orientation}`;
  }

  hideCardAssets(card: Card): void {
    this.gameManager.assetManager.assets.delete(
      CardAssets.getCardAssetId(card)
    );
    this.gameManager.assetManager.assets.delete(
      CardAssets.getSuitAssetId(card, 0)
    );
    this.gameManager.assetManager.assets.delete(
      CardAssets.getSuitAssetId(card, 1)
    );
  }

  centerCards(): void {
    const playerHand = this.gameManager.player.hand;
    const cardCount = playerHand.length;
    const screenW = push.getWidth();
    const totalW =
      cardCount * this.baseW + Math.max(0, cardCount - 1) * padding;
    const startX = Math.floor((screenW - totalW) / 2);
    const cardY = this.getCardPosition();

    for (let i = 0; i < playerHand.length; i++) {
      const card = playerHand[i];
      const x = startX + i * (this.baseW + padding);

      this.updateCardPosition(card, x, cardY);
    }
  }

  updateCardPosition(card: Card, x: number, y: number): void {
    const assetManager = this.gameManager.assetManager;
    assetManager
      .getAsset(CardAssets.getCardAssetId(card))
      ?.updatePosition(x, y);
    assetManager
      .getAsset(CardAssets.getSuitAssetId(card, 0))
      ?.updatePosition(x + 10, y + 10);
    assetManager
      .getAsset(CardAssets.getSuitAssetId(card, 1))
      ?.updatePosition(x + this.baseW - 10, y + this.baseH - 10);
  }

  getCardPosition(): number {
    const screenH = push.getHeight();
    return screenH / 2 + this.baseH / 2;
  }

  // TODO: this logic is duplicated in the baord, so consolidate
  appendAsset(card: Card): void {
    const playerHand = this.gameManager.player.hand;
    const cardCount = playerHand.length;
    const screenW = push.getWidth();
    const totalW =
      cardCount * this.baseW + Math.max(0, cardCount - 1) * padding;
    const startX = Math.floor((screenW - totalW) / 2);
    const cardY = this.getCardPosition();
    const x = startX + (cardCount - 1) * (this.baseW + padding);

    this.addAsset(card, x, cardY);
  }
}
