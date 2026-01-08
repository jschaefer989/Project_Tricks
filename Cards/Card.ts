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

    const slideAssets = this.gameManager.board?.cardAssets.getCardAssetList(this);
    
    this.gameManager.animationManager.animations.set(
      AnimationIds.CARD_SELECT + this.id,
      new SlideAnimation(0.15, 0, -20, slideAssets)
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

    const slideAssets = this.gameManager.board?.cardAssets.getCardAssetList(this);

    this.gameManager.animationManager.animations.set(
      AnimationIds.CARD_SELECT + this.id,
      new SlideAnimation(0.15, 0, 20, slideAssets)
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
