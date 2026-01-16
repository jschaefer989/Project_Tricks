/** @noSelfInFile */

import SlideAnimation from "Assets/Animations/SlideAnimation";
import Asset from "Assets/Asset";
import FontWithPosition from "Assets/Fonts/FontWithPosition";
import IconAsset from "Assets/IconAsset";
import GameManager from "GameManager";
import { exhaustiveGuard, isEmpty } from "Helpers";
import { AssetIds, Ranks, Suits, TextIds } from "../Enums";

export interface CardData {
  id: string;
  suit: Suits;
  rank: Ranks;
  power: number;
  value: number;
  isSelected: boolean;
  cost: number;
  name: string;
}

interface EdelConstructionOptions {
  edelName: string;
  edelPower: number;
  edelValue: number;
  edelRankAssetPath: string;
}

export default abstract class Card {
  gameManager: GameManager;
  id: string;
  suit: Suits;
  rank: Ranks;
  private rankAssetPath: string;
  private power: number;
  private value: number;
  isSelected: boolean = false;
  cost: number;
  private name: string;
  private edelName?: string;
  private edelPower?: number;
  private edelValue?: number;
  private edelRankAssetPath?: string;

  constructor(
    gameManager: GameManager,
    suit: Suits,
    rank: Ranks,
    power: number,
    value: number,
    name: string,
    rankAssetPath: string,
    edelConstructionOptions?: EdelConstructionOptions
  ) {
    this.id = `CARD_${suit}_${rank}_${love.math.random(1000)}`;
    this.gameManager = gameManager;
    this.suit = suit;
    this.rank = rank;
    this.power = power;
    this.value = value;
    this.cost = this.getCost();
    this.rankAssetPath = rankAssetPath;
    this.name = name;
    if (edelConstructionOptions) {
      this.edelName = edelConstructionOptions.edelName;
      this.edelPower = edelConstructionOptions.edelPower;
      this.edelValue = edelConstructionOptions.edelValue;
      this.edelRankAssetPath = edelConstructionOptions.edelRankAssetPath;
    }
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
    return this.getPower() * 10 + this.getValue() * 5;
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
      name: this.name,
    };
  }

  static load(gameManager: GameManager, data: CardData): Card {
    // Use dynamic require to avoid circular dependency
    const CardGenerator = require("./CardGenerator").default;
    const card = CardGenerator.getNewCard(gameManager, data.rank, data.suit);
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

    this.gameManager.board.addPlayerPower(this.getPower());
    this.gameManager.board.addPlayerValue(this.getValue());

    const slideAssets =
      this.gameManager.board?.cardAssets.getCardAssetList(this);

    this.gameManager.animationManager.startAnimation(
      this.id,
      new SlideAnimation(this.gameManager, this.id, 0.15, 0, -20, slideAssets)
    );

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  onUnselect(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.isSelected = false;

    this.gameManager.board.addPlayerPower(-this.getPower());
    this.gameManager.board.addPlayerValue(-this.getValue());

    const slideAssets =
      this.gameManager.board?.cardAssets.getCardAssetList(this);

    this.gameManager.animationManager.startAnimation(
      this.id,
      new SlideAnimation(this.gameManager, this.id, 0.15, 0, 20, slideAssets)
    );

    this.gameManager.board?.updatePrimaryButtonStates();
  }

  onDiscard(): void {
    if (isEmpty(this.gameManager.board)) {
      return;
    }

    this.gameManager.board.addPlayerPower(-this.getPower());
    this.gameManager.board.addPlayerValue(-this.getValue());
  }

  onHover(asset: Asset): void {
    this.gameManager.assetManager.tooltipManager.addTooltip(
      this.getShortCardInfo(5, 10),
      asset
    );
  }

  onUnhover(asset: Asset): void {
    this.gameManager.assetManager.tooltipManager.hideTooltip();
  }

  getShortCardInfo(x: number, y: number): FontWithPosition[] {
    return [
      new FontWithPosition(
        TextIds.TOOLTIP_CARD_NAME,
        x,
        y,
        `${this.getName()} of ${Card.getSuitName(this.suit)}`
      ),
      new FontWithPosition(
        TextIds.TOOLTIP_CARD_POWER,
        x,
        y + 10,
        this.getPower().toString(),
        {
          icon: IconAsset.getPowerIconAsset(
            this.gameManager,
            AssetIds.TOOLTIP_POWER_ICON
          ),
        }
      ),
      new FontWithPosition(
        TextIds.TOOLTIP_CARD_VALUE,
        x,
        y + 20,
        this.getValue().toString(),
        {
          icon: IconAsset.getValueIconAsset(
            this.gameManager,
            AssetIds.TOOLTIP_VALUE_ICON
          ),
        }
      ),
    ];
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

  get isEdel(): boolean {
    return (
      !this.gameManager.board?.showingEdelView &&
      this.gameManager.board?.edelCard?.suit === this.suit &&
      this.edelName !== this.name
    );
  }

  getPower(): number {
    return this.isEdel && !isEmpty(this.edelPower)
      ? this.edelPower
      : this.power;
  }

  getValue(): number {
    return this.isEdel && !isEmpty(this.edelValue)
      ? this.edelValue
      : this.value;
  }

  getName(): string {
    return this.isEdel && !isEmpty(this.edelName) ? this.edelName : this.name;
  }

  getRankAssetPath(): string {
    return this.isEdel && !isEmpty(this.edelRankAssetPath)
      ? this.edelRankAssetPath
      : this.rankAssetPath;
  }
}
