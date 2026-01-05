/** @noSelfInFile */

import GameManager from "GameManager";
import { AnimationIds, Ranks, Suits, EdelRanks } from "../Enums";
import { exhaustiveGuard, isEmpty } from "Helpers";
import Asset from "Assets/Asset";
import Animation from "Assets/Animation";

export interface CardData {
  id: string;
  suit: Suits;
  rank: Ranks | EdelRanks;
  power: number;
  value: number;
  isSelected: boolean;
  cost: number;
  isEdel: boolean;
  name: string;
}

export default class Card {
  gameManager: GameManager;
  id: string;
  suit: Suits;
  rank: Ranks | EdelRanks;
  power: number;
  value: number;
  isSelected: boolean = false;
  cost: number;
  isEdel: boolean = false;
  name: string;

  constructor(
    gameManager: GameManager,
    suit: Suits,
    rank: Ranks | EdelRanks,
    power: number,
    value: number,
    name: string,
    isEdel?: boolean
  ) {
    const id = `${suit}_${rank}_${love.math.random(1000)}`;
    this.gameManager = gameManager;
    this.suit = suit;
    this.rank = rank;
    this.power = power;
    this.value = value;
    this.cost = this.getCost();
    this.isEdel = isEdel ?? false;
    this.name = name;
    this.id = id;
  }

  isEqual(otherCard: Card): boolean {
    return this.id === otherCard.id;
  }

  getCost(): number {
    let cost = 0;
    cost += this.getBaseCost();
    return cost;
  }

  getBaseCost(): number {
    return this.power * 10 + this.value * 5;
  }

  save(): CardData {
    return {
      id: this.id,
      suit: this.suit,
      rank: this.rank,
      power: this.power,
      value: this.value,
      isSelected: this.isSelected,
      cost: this.cost,
      isEdel: this.isEdel,
      name: this.name,
    };
  }

  static load(gameManager: GameManager, data: CardData): Card {
    const card = new Card(
      gameManager,
      data.suit,
      data.rank,
      data.power,
      data.value,
      data.name,
      data.isEdel
    );
    card.id = data.id;
    card.isSelected = data.isSelected;
    card.cost = data.cost;
    return card;
  }

  onClick(): void {
    if (this.isSelected) {
      this.isSelected = false;
      this.onUnselect();
    } else {
      this.isSelected = true;
      this.onSelect();
    }
  }

  onSelect(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.gameManager.board.addPlayerPower(this.power);
    this.gameManager.board.addPlayerValue(this.value);

    const { baseAsset, suitAssets, rankAsset } =
      this.gameManager.board.cardAssets.getCardAssets(this);
    const suitAssetNormal = suitAssets[0];
    const suitAssetFlipped = suitAssets[1];

    const baseId = AnimationIds.CARD_BASE_SELECT + this.id;
    if (
      !isEmpty(baseAsset) &&
      !this.gameManager.animationManager.animations.has(baseId)
    ) {
      this.gameManager.animationManager.animations.set(
        baseId,
        new Animation(0, -20, baseAsset)
      );
    }
    const suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT + this.id;
    if (
      !isEmpty(suitAssetNormal) &&
      !this.gameManager.animationManager.animations.has(suitNormalId)
    ) {
      this.gameManager.animationManager.animations.set(
        suitNormalId,
        new Animation(0, -20, suitAssetNormal)
      );
    }
    const suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT + this.id;
    if (
      !isEmpty(suitAssetFlipped) &&
      !this.gameManager.animationManager.animations.has(suitFlippedId)
    ) {
      this.gameManager.animationManager.animations.set(
        suitFlippedId,
        new Animation(0, -20, suitAssetFlipped)
      );
    }
    const rankAssetId = AnimationIds.CARD_RANK_SELECT + this.id;
    if (
      !isEmpty(rankAsset) &&
      !this.gameManager.animationManager.animations.has(rankAssetId)
    ) {
      this.gameManager.animationManager.animations.set(
        rankAssetId,
        new Animation(0, -20, rankAsset)
      );
    }

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  onUnselect(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.gameManager.board.addPlayerPower(-this.power);
    this.gameManager.board.addPlayerValue(-this.value);

    const { baseAsset, suitAssets, rankAsset } =
      this.gameManager.board.cardAssets.getCardAssets(this);
    const suitAssetNormal = suitAssets[0];
    const suitAssetFlipped = suitAssets[1];

    const baseId = AnimationIds.CARD_BASE_SELECT + this.id;
    if (
      !isEmpty(baseAsset) &&
      !this.gameManager.animationManager.animations.has(baseId)
    ) {
      this.gameManager.animationManager.animations.set(
        baseId,
        new Animation(0, 20, baseAsset)
      );
    }
    const suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT + this.id;
    if (
      !isEmpty(suitAssetNormal) &&
      !this.gameManager.animationManager.animations.has(suitNormalId)
    ) {
      this.gameManager.animationManager.animations.set(
        suitNormalId,
        new Animation(0, 20, suitAssetNormal)
      );
    }
    const suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT + this.id;
    if (
      !isEmpty(suitAssetFlipped) &&
      !this.gameManager.animationManager.animations.has(suitFlippedId)
    ) {
      this.gameManager.animationManager.animations.set(
        suitFlippedId,
        new Animation(0, 20, suitAssetFlipped)
      );
    }
    const rankAssetId = AnimationIds.CARD_RANK_SELECT + this.id;
    if (
      !isEmpty(rankAsset) &&
      !this.gameManager.animationManager.animations.has(rankAssetId)
    ) {
      this.gameManager.animationManager.animations.set(
        rankAssetId,
        new Animation(0, 20, rankAsset)
      );
    }

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  static onHover(gameManager: GameManager, asset: Asset): void {
    const tooltipMaxWidth = 200;
    const padding = 20;
    const bgPadding = 8;

    // Extract card ID from asset ID (format: "BASE_CARD_TEMPLATE-{cardId}")
    // TODO: move to its own method somewhere (not CardAssets)
    const cardId = asset.id.split("-")[1];
    const card = gameManager.getCard(cardId);
    const font = love.graphics.getFont();

    if (isEmpty(card) || isEmpty(font)) {
      return;
    }

    const screenW = love.graphics.getWidth();
    const defaultX = asset.x + asset.getWidth() + padding;
    const placeRight = defaultX + tooltipMaxWidth <= screenW - padding;
    const tooltipX = placeRight
      ? defaultX
      : math.max(padding, asset.x - padding - tooltipMaxWidth);
    const tooltipY = asset.y;

    const lineHeight = font.getHeight();
    const bgX = tooltipX - bgPadding;
    const bgY = tooltipY - bgPadding;
    const bgW = tooltipMaxWidth + bgPadding * 2;
    const bgH = lineHeight * 4 + bgPadding * 2;

    // Draw background
    love.graphics.setColor(0, 0, 0, 0.8);
    love.graphics.rectangle("fill", bgX, bgY, bgW, bgH);
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.rectangle("line", bgX, bgY, bgW, bgH);

    // Draw text
    love.graphics.setColor(1, 1, 1, 1);
    love.graphics.printf(
      card.name,
      tooltipX,
      tooltipY,
      tooltipMaxWidth,
      "left"
    );
    love.graphics.printf(
      Card.getSuitName(card.suit),
      tooltipX,
      tooltipY,
      tooltipMaxWidth,
      "right"
    );
    love.graphics.printf(
      "Power: " + card.power,
      tooltipX,
      tooltipY + 20,
      tooltipMaxWidth,
      "left"
    );
    love.graphics.printf(
      "Value: " + card.value,
      tooltipX,
      tooltipY + 40,
      tooltipMaxWidth,
      "left"
    );
  }

  static getSuitName(suit: Suits): string {
    switch (suit) {
      case Suits.HEARTS:
        return "Hearts";
      case Suits.ACORNS:
        return "Acorns";
      case Suits.LEAVES:
        return "Leaves";
      case Suits.BELLS:
        return "Bells";
      default:
        exhaustiveGuard(suit);
    }
  }
}
