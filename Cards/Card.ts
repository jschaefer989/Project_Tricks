/** @noSelfInFile */

import GameManager from "GameManager";
import { AnimationIds, Ranks, Suits, EdelRanks, AssetIds, TextIds } from "../Enums";
import { exhaustiveGuard, isEmpty } from "Helpers";
import Asset from "Assets/Asset";
import SlideAnimation from "Assets/Animations/SlideAnimation";
import { AnimationAssets } from "Assets/Animations/Animation";
import FontWithPosition, { Fonts } from "Assets/FontWithPosition";
import IconAsset from "Assets/IconAsset";

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
      this.onUnselect();
    } else {
      this.onSelect();
    }
  }

  onSelect(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.isSelected = true;

    this.gameManager.board.addPlayerPower(this.power);
    this.gameManager.board.addPlayerValue(this.value);

    const { baseAsset, suitAssets, rankAsset } =
      this.gameManager.board.cardAssets.getCardAssets(this);
    const suitAssetNormal = suitAssets[0];
    const suitAssetFlipped = suitAssets[1];

    const animationAssets: AnimationAssets[] = [];

    const baseId = AnimationIds.CARD_BASE_SELECT + this.id;
    if (
      !isEmpty(baseAsset) &&
      !this.gameManager.animationManager.animations.has(baseId)
    ) {
      animationAssets.push(baseAsset);
    }
    const suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT + this.id;
    if (
      !isEmpty(suitAssetNormal) &&
      !this.gameManager.animationManager.animations.has(suitNormalId)
    ) {
      animationAssets.push(suitAssetNormal);
    }
    const suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT + this.id;
    if (
      !isEmpty(suitAssetFlipped) &&
      !this.gameManager.animationManager.animations.has(suitFlippedId)
    ) {
      animationAssets.push(suitAssetFlipped);
    }
    const rankAssetId = AnimationIds.CARD_RANK_SELECT + this.id;
    if (
      !isEmpty(rankAsset) &&
      !this.gameManager.animationManager.animations.has(rankAssetId)
    ) {
      animationAssets.push(rankAsset);
    }

      this.gameManager.animationManager.animations.set(
        baseId,
        new SlideAnimation(0, -20, animationAssets)
      );

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  onUnselect(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.isSelected = false;

    this.gameManager.board.addPlayerPower(-this.power);
    this.gameManager.board.addPlayerValue(-this.value);

    const { baseAsset, suitAssets, rankAsset } =
      this.gameManager.board.cardAssets.getCardAssets(this);
    const suitAssetNormal = suitAssets[0];
    const suitAssetFlipped = suitAssets[1];

    const animationAssets: AnimationAssets[] = [];

    const baseId = AnimationIds.CARD_BASE_SELECT + this.id;
    if (
      !isEmpty(baseAsset) &&
      !this.gameManager.animationManager.animations.has(baseId)
    ) {
      animationAssets.push(baseAsset);
    }
    const suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT + this.id;
    if (
      !isEmpty(suitAssetNormal) &&
      !this.gameManager.animationManager.animations.has(suitNormalId)
    ) {
      animationAssets.push(suitAssetNormal);
    }
    const suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT + this.id;
    if (
      !isEmpty(suitAssetFlipped) &&
      !this.gameManager.animationManager.animations.has(suitFlippedId)
    ) {
      animationAssets.push(suitAssetFlipped);
    }
    const rankAssetId = AnimationIds.CARD_RANK_SELECT + this.id;
    if (
      !isEmpty(rankAsset) &&
      !this.gameManager.animationManager.animations.has(rankAssetId)
    ) {
      animationAssets.push(rankAsset);
    }

    this.gameManager.animationManager.animations.set(
      baseId,
      new SlideAnimation(0, 20, animationAssets)
    );

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  onHover(asset: Asset): void {
    this.gameManager.assetManager.tooltipManager.addTooltip(
      [
        new FontWithPosition(
          TextIds.TOOLTIP_CARD_NAME,
          5,
          10,
          `${this.name} of ${Card.getSuitName(this.suit)}`
        ),
        new FontWithPosition(
          TextIds.TOOLTIP_CARD_POWER,
          5,
          20,
          this.power.toString(),
          { icon: IconAsset.getPowerIconAsset(AssetIds.TOOLTIP_POWER_ICON) }
        ),
        new FontWithPosition(
          TextIds.TOOLTIP_CARD_VALUE,
          5,
          30,
          this.value.toString(),
          { icon: IconAsset.getValueIconAsset(AssetIds.TOOLTIP_VALUE_ICON) }
        )
      ],
      asset
    )
  }

  onUnhover(asset: Asset): void {
    this.gameManager.assetManager.tooltipManager.hideTooltip();
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
