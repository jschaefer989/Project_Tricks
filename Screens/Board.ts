/** @noSelfInFile */

import { AnimationAssets } from "Assets/Animations/Animation";
import CutAnimation from "Assets/Animations/CutAnimation";
import FlickerAnimation from "Assets/Animations/FlickerAnimation";
import GlowAnimation from "Assets/Animations/GlowAnimation";
import SlideAnimation from "Assets/Animations/SlideAnimation";
import Asset from "Assets/Asset";
import CardAssets, { cardHeight, cardWidth } from "Assets/CardAssets";
import FontWithPosition, {
  Fonts,
  Format,
  OutlineThickness,
} from "Assets/Fonts/FontWithPosition";
import IconAsset from "Assets/IconAsset";
import Card from "Cards/Card";
import Enemy, { EnemyData } from "Enemies/Enemy";
import { exhaustiveGuard, isEmpty } from "Helpers";
import * as push from "Libraries.push";
import { Image } from "love.graphics";
import ShimmerShader from "Shaders/ShimmerShader";
import Dealer from "../Dealer";
import {
  AssetIds,
  CharacterTypes,
  GameStates,
  HoverEffects,
  MousePressEffects,
  TextIds,
} from "../Enums";
import type GameManager from "../GameManager";

const portraitGap = 12;

interface BoardData {
  discardUsed: number;
  playerPoints: number;
  enemyPoints: number;
  enemy: EnemyData;
  edelCard?: Card;
  playerPower: number;
  playerValue: number;
  enemyPower: number;
  enemyValue: number;
  showingInitialView: boolean;
}

export default class Board {
  gameManager: GameManager;
  discardUsed = 0;
  enemy: Enemy;
  dealer: Dealer;
  playerPoints = 0;
  enemyPoints = 0;
  edelCard?: Card;
  playerPower = 0;
  playerValue = 0;
  enemyPower = 0;
  enemyValue = 0;
  showingEdelView = true;
  cardAssets: CardAssets;
  portraitPosition: number | undefined; // Saved off so it can be restored on resume
  winFireSound = love.audio.newSource("Assets/Sounds/Dominating.wav", "static");

  constructor(gameManager: GameManager, enemy?: Enemy) {
    this.gameManager = gameManager;
    this.enemy = enemy ?? new Enemy(gameManager);
    this.dealer = new Dealer(gameManager, this);
    this.cardAssets = new CardAssets(gameManager, this);
  }

  load(data: BoardData): void {
    this.discardUsed = data.discardUsed;
    this.playerPoints = data.playerPoints;
    this.enemyPoints = data.enemyPoints;
    this.edelCard = data.edelCard;
    this.playerPower = data.playerPower;
    this.playerValue = data.playerValue;
    this.enemyPower = data.enemyPower;
    this.enemyValue = data.enemyValue;
    this.showingEdelView = data.showingInitialView ?? true;
    this.enemy = new Enemy(this.gameManager);
    this.enemy.load(this.gameManager, data.enemy);
  }

  save(): BoardData {
    return {
      discardUsed: this.discardUsed,
      playerPoints: this.playerPoints,
      enemyPoints: this.enemyPoints,
      enemy: this.enemy.save(),
      edelCard: this.edelCard,
      playerPower: this.playerPower,
      playerValue: this.playerValue,
      enemyPower: this.enemyPower,
      enemyValue: this.enemyValue,
      showingInitialView: this.showingEdelView,
    };
  }

  getPlayerPoints(): number {
    let points = this.playerValue - this.enemyValue;
    if (points < 0) points = 0;
    return points;
  }

  getEnemyPoints(): number {
    let points = this.enemyValue - this.playerValue;
    if (points < 0) points = 0;
    return points;
  }

  handleStartFight(): void {
    this.showingEdelView = false;
    this.gameManager.assetManager.removeAssets(AssetIds.LETS_FIGHT_BUTTON);
    this.gameManager.assetManager.textManager.hideText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION
    );

    this.gameManager.assetManager.disableAllClickableAssets(true);
    this.dealer.dealHandAtStartOfFight();
    this.hideEdelBoard();
  }

  private hideEdelBoard(): void {
    this.gameManager.assetManager.textManager.hideText(TextIds.EDEL_LABEL);
    this.gameManager.assetManager.removeAssets(AssetIds.EDEL_BOARD);
    this.gameManager.assetManager.removeAssets(AssetIds.EDEL_SUIT_ICON_LEFT);
    this.gameManager.assetManager.removeAssets(AssetIds.EDEL_SUIT_ICON_RIGHT);
  }

  handleAttack(): void {
    if (!this.gameManager.player.anySelectedCards()) return;

    this.gameManager.assetManager.disableAllClickableAssets(true);

    if (this.playerPower > this.enemyPower) {
      // Mark all enemy cards as cut and update the assets
      for (const card of this.getSlainCards(CharacterTypes.ENEMY)) {
        this.cardAssets.redrawCard(card);
        this.startCutAnimation(
          card,
          CharacterTypes.PLAYER,
          CharacterTypes.ENEMY
        );
      }
      return; // Don't deal cards yet - let the animation play first
    } else {
      for (const card of this.getSlainCards(CharacterTypes.PLAYER)) {
        this.cardAssets.redrawCard(card);
        this.startCutAnimation(
          card,
          CharacterTypes.ENEMY,
          CharacterTypes.PLAYER
        );
      }
    }
  }

  getSlainCards(characterType: CharacterTypes): Card[] {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return this.gameManager.player.hand.filter((card) => card.isSelected);
      case CharacterTypes.ENEMY:
        return this.enemy.hand;
      default:
        exhaustiveGuard(characterType);
    }
  }

  startCutAnimation(
    card: Card,
    winner: CharacterTypes,
    loser: CharacterTypes
  ): void {
    const { baseAsset, suitAssets, rankAsset } =
      this.cardAssets.getCardAssets(card);
    const normalSuitAsset = suitAssets[0];

    // Start up the cut animation on the card base and rank
    const cutAnimationAssets: AnimationAssets[] = [];
    if (!isEmpty(baseAsset)) {
      cutAnimationAssets.push(baseAsset);
    }
    if (!isEmpty(rankAsset)) {
      cutAnimationAssets.push(rankAsset);
    }

    this.gameManager.animationManager.startAnimation(
      card.id + "_cut",
      new CutAnimation(
        this.gameManager,
        card.id + "_cut",
        0.15,
        0,
        -40,
        cutAnimationAssets,
        {
          onFinish: () => this.startFlickerAnimation(card, winner, loser),
        }
      )
    );

    // Just slide the top suit, don't cut it
    const slideAnimationAssets: AnimationAssets[] = [];
    if (!isEmpty(normalSuitAsset)) {
      slideAnimationAssets.push(normalSuitAsset);
    }

    this.gameManager.animationManager.startAnimation(
      card.id + "_slide",
      new SlideAnimation(
        this.gameManager,
        card.id + "_slide",
        0.15,
        0,
        -40,
        slideAnimationAssets
      )
    );

    // Leave the bottom suit where it is
  }

  startFlickerAnimation(
    card: Card,
    winner: CharacterTypes,
    loser: CharacterTypes
  ): void {
    this.gameManager.animationManager.startAnimation(
      card.id,
      new FlickerAnimation(
        this.gameManager,
        card.id,
        this.cardAssets.getCardAssetList(card),
        {
          onFinish: () => this.wrapUpAttack(winner, loser),
          animDuration: 0.6,
        }
      )
    );
  }

  wrapUpAttack(winner: CharacterTypes, loser: CharacterTypes): void {
    if (this.gameManager.animationManager.hasAnimations()) {
      return; // Wait for all animations to finish
    }

    this.hideSlainCards(loser);
    this.addPoints(winner);
    this.clearEnemyStats();
    if (this.enemy.deck.length === 0) {
      this.endFight();
    } else {
      this.dealer.dealNextHand();
    }
  }

  private hideSlainCards(characterType: CharacterTypes): void {
    for (const card of this.getSlainCards(characterType)) {
      this.cardAssets.removeCardAssets(card);
    }
  }

  private addPlayerPoints(points: number): void {
    this.playerPoints += points;

    this.gameManager.assetManager.textManager.updateText(
      TextIds.POINTS_PLAYER,
      `${this.gameManager.player.name}: ${this.playerPoints}`
    );
  }

  getAllCardsInPlay(): Card[] {
    const cardsInPlay: Card[] = [];
    for (const card of this.gameManager.player.hand) {
      cardsInPlay.push(card);
    }
    for (const card of this.enemy.hand) {
      cardsInPlay.push(card);
    }
    return cardsInPlay;
  }

  private addPoints(winner: CharacterTypes): void {
    switch (winner) {
      case CharacterTypes.PLAYER:
        this.addPlayerPoints(this.getPlayerPoints());
        break;
      case CharacterTypes.ENEMY:
        this.addEnemyPoints(this.getEnemyPoints());
        break;
      default:
        exhaustiveGuard(winner);
    }
  }

  private addEnemyPoints(points: number): void {
    this.enemyPoints += points;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.POINTS_ENEMY,
      `${this.enemy.name}: ${this.enemyPoints}`
    );
  }

  displayEdel(): void {
    if (this.gameManager.animationManager.hasAnimations()) {
      return; // wait for deal animations to finish
    }

    this.gameManager.assetManager.disableAllClickableAssets(false);
    this.cardAssets.disableAllCards(false);
    this.buildLetsFightButton();
    this.buildEdelBoard();

    if (!isEmpty(this.edelCard)) {
      this.gameManager.animationManager.startAnimation(
        this.edelCard.id,
        new GlowAnimation(
          this.gameManager,
          this.edelCard.id,
          () => !this.gameManager.board?.showingEdelView,
          [...this.cardAssets.getCardAssetList(this.edelCard)],
          { glowPeriodSeconds: 3 }
        )
      );

      const { baseAsset } = this.cardAssets.getCardAssets(this.edelCard);
      if (!isEmpty(baseAsset)) {
        this.gameManager.shaderManager.addShader(
          baseAsset.id,
          new ShimmerShader(this.gameManager, () => !this.showingEdelView, [
            baseAsset,
          ])
        );
      }
    }
  }

  displayFight(): void {
    if (this.gameManager.animationManager.hasAnimations()) {
      return; // wait for deal animations to finish
    }

    this.gameManager.assetManager.disableAllClickableAssets(false);
    this.cardAssets.disableAllCards(false);
    this.buildPrimaryButtons();
    this.buildPointBoard();
    const portraitHeight = this.getPortraitHeight() ?? 0;
    this.buildPowerAndValues(CharacterTypes.PLAYER, portraitHeight);
    this.buildPowerAndValues(CharacterTypes.ENEMY, portraitHeight);
  }

  handleDiscard(): void {
    if (!this.gameManager.player.anySelectedCards()) return;
    if (this.getRemainingDiscards() <= 0) return;

    this.gameManager.assetManager.disableAllClickableAssets(true);

    const removedIndices = this.dealer.discardCards(
      CharacterTypes.PLAYER,
      this.gameManager.player.getSelectedCards()
    );

    this.discardUsed = this.discardUsed + 1;
    const remaining = this.getRemainingDiscards();
    this.updateDiscardCounter(remaining);

    if (remaining <= 0) {
      this.disableDiscardButton();
    }

    // Refill the player's hand after discarding
    this.gameManager.board?.dealer.dealCards(
      CharacterTypes.PLAYER,
      removedIndices
    );
  }

  updateDiscardCounter(remainingNumberOfDiscards: number): void {
    this.gameManager.assetManager.textManager.updateText(
      TextIds.DISCARD_BUTTON_COUNTER,
      `${remainingNumberOfDiscards}/${this.gameManager.player.discards}`
    );
  }

  getRemainingDiscards(): number {
    return this.gameManager.player.discards - this.discardUsed;
  }

  getWinner(): CharacterTypes {
    if (this.playerPoints > this.enemyPoints) {
      return CharacterTypes.PLAYER;
    } else {
      return CharacterTypes.ENEMY;
    }
  }

  endFight(): void {
    this.clearStats();
    this.gameManager.player.unselectCards();
    const winner = this.getWinner();
    if (winner === CharacterTypes.PLAYER) {
      this.enemy.removeAllCardsFromHand();
      this.gameManager.player.addDiscardsToDeck();
      this.gameManager.player.cashout(this.playerPoints);
      this.dealer.getLootCards();
      this.gameManager.switchBasedOnGameState(GameStates.WIN_SCREEN);
    } else if (winner === CharacterTypes.ENEMY) {
      this.gameManager.switchBasedOnGameState(GameStates.LOSE_SCREEN);
    }
  }

  clearStats(): void {
    this.clearPlayerStats();
    this.clearEnemyStats();
  }

  clearPlayerStats(): void {
    this.addPlayerPower(-this.playerPower);
    this.addPlayerValue(-this.playerValue);
  }

  clearEnemyStats(): void {
    this.addEnemyPower(-this.enemyPower);
    this.addEnemyValue(-this.enemyValue);
  }

  addPlayerPower(power: number): void {
    this.playerPower += power;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_POWER,
      this.playerPower.toString()
    );
    if (this.playerPower > this.enemyPower) {
      this.buildWinFire();
    } else {
      this.removeWinFire();
    }
  }

  addPlayerValue(value: number): void {
    this.playerValue += value;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_VALUE,
      this.playerValue.toString()
    );
    this.gameManager.assetManager.textManager.updateText(
      TextIds.POINTS,
      `Points: ${this.getPlayerPoints()}`
    );
  }

  addEnemyPower(power: number): void {
    this.enemyPower += power;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_POWER,
      this.enemyPower.toString()
    );
  }

  addEnemyValue(value: number): void {
    this.enemyValue += value;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_VALUE,
      this.enemyValue.toString()
    );
  }

  start(): void {
    // TODO: we'll want this to either support loading and rendering after saving and restarting the game,
    // or we'll want to update saving so that it's only supported in specific places (like between fights, on the map screen).
    this.buildPlayerPortrait();
    this.buildEnemyPortrait();
    this.buildDeck(CharacterTypes.PLAYER);
    this.buildDeck(CharacterTypes.ENEMY);
    this.gameManager.assetManager.disableAllClickableAssets(true);
    this.dealer.dealEdel();
  }

  private buildLetsFightButton(): void {
    const buttonHeight = 87;
    const buttonWidth = 253;
    const screenW = push.getWidth();
    const screenH = push.getHeight();
    const buttonX = Math.floor((screenW - buttonWidth) / 2);
    const buttonY = Math.floor((screenH - buttonHeight) / 2);
    const centerX = buttonX + buttonWidth / 2;
    const centerY = buttonY + buttonHeight / 2;

    const letsFightButtonText = new FontWithPosition(
      TextIds.LETS_FIGHT_BUTTON_CAPTION,
      centerX + 14,
      centerY,
      "Let's Fight!",
      {
        size: 42,
        format: Format.CENTER,
        outlineThickness: OutlineThickness.THICK,
        font: Fonts.FANTASY,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION,
      letsFightButtonText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.LETS_FIGHT_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.LETS_FIGHT_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/LetsFightButton.png"
        ),
        buttonX,
        centerY - buttonHeight / 2,
        buttonWidth,
        buttonHeight,
        {
          onClick: () => this.handleStartFight(),
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
          associatedTexts: [letsFightButtonText],
          clickSound: this.gameManager.assetManager.buttonClickSound,
        }
      )
    );
  }

  private buildPrimaryButtons(): void {
    const gap = 10;
    const btnW = 90;
    const btnH = 70;
    const totalW = btnW * 3 + gap * 2;
    const buttonY =
      this.cardAssets.getHandYCoordinate(CharacterTypes.PLAYER) +
      cardHeight +
      gap;
    const buttonX = Math.floor((push.getWidth() - totalW) / 2);
    this.buildAttackButton(buttonX, buttonY, btnW, btnH);
    const discardX = this.buildDiscardButton(buttonX, buttonY, btnW, btnH, gap);
    const deselectX = this.buildDeselectButton(
      discardX,
      buttonY,
      btnW,
      btnH,
      gap
    );
    this.buildSortButton(deselectX, buttonY, btnW, btnH);

    // Disable buttons initially since no cards are selected
    this.updatePrimaryButtonStates();
  }

  private buildAttackButton(
    buttonX: number,
    buttonY: number,
    btnW: number,
    btnH: number
  ): void {
    const centerX = buttonX + btnW / 2;
    const centerY = buttonY + btnH / 2;
    const attackButtonText = new FontWithPosition(
      TextIds.ATTACK_BUTTON_CAPTION,
      centerX,
      centerY,
      "Attack",
      {
        size: 18,
        format: Format.CENTER,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.ATTACK_BUTTON_CAPTION,
      attackButtonText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.ATTACK_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.ATTACK_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/AttackButton.png"
        ),
        buttonX,
        buttonY,
        btnW,
        btnH,
        {
          onClick: () => this.handleAttack(),
          clickSound: this.gameManager.assetManager.buttonClickSound,
          associatedTexts: [attackButtonText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
        }
      )
    );
  }

  private buildDiscardButton(
    buttonX: number,
    buttonY: number,
    btnW: number,
    btnH: number,
    gap: number
  ): number {
    const discardX = buttonX + btnW + gap;

    const centerX = discardX + btnW / 2;
    const centerY = buttonY + btnH / 2;
    const discardButtonCaptionText = new FontWithPosition(
      TextIds.DISCARD_BUTTON_CAPTION,
      centerX,
      centerY,
      "Discard",
      {
        size: 18,
        format: Format.CENTER,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.DISCARD_BUTTON_CAPTION,
      discardButtonCaptionText
    );

    const remaining = this.gameManager.player.discards - this.discardUsed;
    const discardButtonCounterText = new FontWithPosition(
      TextIds.DISCARD_BUTTON_COUNTER,
      centerX,
      centerY + 12,
      `${remaining}/${this.gameManager.player.discards}`,
      {
        size: 9,
        format: Format.CENTER,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.DISCARD_BUTTON_COUNTER,
      discardButtonCounterText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.DISCARD_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.DISCARD_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/DiscardButton.png"
        ),
        discardX,
        buttonY,
        btnW,
        btnH,
        {
          onClick: () => this.handleDiscard(),
          associatedTexts: [discardButtonCaptionText, discardButtonCounterText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
          clickSound: this.gameManager.assetManager.buttonClickSound,
        }
      )
    );

    return discardX;
  }

  private buildDeselectButton(
    discardX: number,
    buttonY: number,
    btnW: number,
    btnH: number,
    gap: number
  ): number {
    const deselectX = discardX + btnW + gap;

    const centerX = deselectX + btnW / 2;
    const centerY = buttonY + btnH / 4;
    const deselectButtonCaptionText = new FontWithPosition(
      TextIds.DESELECT_BUTTON_CAPTION,
      centerX,
      centerY,
      "Deselect",
      {
        size: 9,
        format: Format.CENTER,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.DESELECT_BUTTON_CAPTION,
      deselectButtonCaptionText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.DESELECT_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.DESELECT_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/DeselectButton.png"
        ),
        deselectX,
        buttonY,
        btnW,
        btnH / 2,
        {
          onClick: () => this.gameManager.player.unselectCards(),
          associatedTexts: [deselectButtonCaptionText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
          clickSound: this.gameManager.assetManager.buttonClickSound,
        }
      )
    );
    return deselectX;
  }

  private buildSortButton(
    deselectX: number,
    buttonY: number,
    btnW: number,
    btnH: number
  ): void {
    const centerX = deselectX + btnW / 2;
    const centerY = buttonY + btnH / 4 + btnH / 2 + 1;
    const sortButtonCaptionText = new FontWithPosition(
      TextIds.SORT_BUTTON_CAPTION,
      centerX,
      centerY,
      "Sort",
      {
        size: 9,
        format: Format.CENTER,
      }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.SORT_BUTTON_CAPTION,
      sortButtonCaptionText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.SORT_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.SORT_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/SortButton.png"
        ),
        deselectX,
        buttonY + btnH / 2 + 1,
        btnW,
        btnH / 2,
        {
          onClick: () => {
            this.gameManager.player.sortCards();
            this.enemy.sortCards();
          },
          associatedTexts: [sortButtonCaptionText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
          clickSound: this.gameManager.assetManager.buttonClickSound,
        }
      )
    );
  }

  updatePrimaryButtonStates(): void {
    const hasSelectedCards = this.gameManager.player.anySelectedCards();

    if (hasSelectedCards) {
      this.enablePrimaryButtons();
    } else {
      this.disablePrimaryButtons();
    }
  }

  enablePrimaryButtons(): void {
    this.enableAttackButton();
    this.enableDiscardButton();
    this.enableDeselectButton();
  }

  disablePrimaryButtons(): void {
    this.disableAttackButton();
    this.disableDiscardButton();
    this.disableDeselectButton();
  }

  enableAttackButton(): void {
    this.gameManager.assetManager.enableAsset(AssetIds.ATTACK_BUTTON);
  }

  enableDiscardButton(): void {
    if (this.getRemainingDiscards() <= 0) {
      return; // Never enable the button if the player is out of discards
    }

    this.gameManager.assetManager.enableAsset(AssetIds.DISCARD_BUTTON);
  }

  enableDeselectButton(): void {
    this.gameManager.assetManager.enableAsset(AssetIds.DESELECT_BUTTON);
  }

  disableAttackButton(): void {
    this.gameManager.assetManager.disableAsset(AssetIds.ATTACK_BUTTON);
  }

  disableDiscardButton(): void {
    this.gameManager.assetManager.disableAsset(AssetIds.DISCARD_BUTTON);
  }

  disableDeselectButton(): void {
    this.gameManager.assetManager.disableAsset(AssetIds.DESELECT_BUTTON);
  }

  private buildPointBoard(): void {
    const boardWidth = 250;
    const boardHeight = 23;
    const screenW = push.getWidth();
    const buttonX = Math.floor((screenW - boardWidth) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.POINT_DISPLAY,
      new Asset(
        this.gameManager,
        AssetIds.POINT_DISPLAY,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PointBoard.png"
        ),
        buttonX,
        5,
        boardWidth,
        boardHeight
      )
    );

    const centerX = screenW / 2;
    const textY = boardHeight / 2 + 5;

    const playerText = `${this.gameManager.player.name}: ${this.playerPoints}`;
    const enemyText = `${this.enemy.name}: ${this.enemyPoints}`;

    // Left label (player)
    this.gameManager.assetManager.textManager.addText(
      TextIds.POINTS_PLAYER,
      new FontWithPosition(
        TextIds.POINTS_PLAYER,
        centerX - boardWidth / 2 + 5,
        textY,
        playerText,
        {
          size: 9,
        }
      )
    );

    // Right label (enemy)
    this.gameManager.assetManager.textManager.addText(
      TextIds.POINTS_ENEMY,
      new FontWithPosition(
        TextIds.POINTS_ENEMY,
        centerX + boardWidth / 2 - 5,
        textY,
        enemyText,
        {
          size: 9,
          format: Format.RIGHT,
        }
      )
    );

    if (!isEmpty(this.edelCard)) {
      const suitImage = this.gameManager.assetManager.assetLoader.loadImage(
        CardAssets.getSuitAssetPath(this.edelCard.suit)
      );
      this.gameManager.assetManager.addAsset(
        AssetIds.EDEL_ICON,
        new Asset(
          this.gameManager,
          AssetIds.EDEL_ICON,
          suitImage,
          centerX - suitImage.getWidth() / 2,
          5 + boardHeight / 2 - suitImage.getHeight() / 2,
          16,
          16
        )
      );
    }
  }

  private buildPowerAndValues(
    characterType: CharacterTypes,
    portraitHeight: number
  ): void {
    const levelText =
      characterType === CharacterTypes.PLAYER
        ? this.gameManager.assetManager.textManager.getText(
            TextIds.PLAYER_PORTRAIT_LEVEL
          )
        : this.gameManager.assetManager.textManager.getText(
            TextIds.ENEMY_PORTRAIT_LEVEL
          );
    if (isEmpty(levelText)) {
      return;
    }

    const powerId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_POWER
        : TextIds.ENEMY_POWER;
    const powerValue =
      characterType === CharacterTypes.PLAYER
        ? this.playerPower
        : this.enemyPower;
    const attackPowerAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_ATTACK_POWER_ICON
        : AssetIds.ENEMY_ATTACK_POWER_ICON;
    const powerY = levelText.y + portraitGap;
    this.gameManager.assetManager.textManager.addText(
      powerId,
      new FontWithPosition(powerId, 20, powerY, powerValue.toString(), {
        icon: IconAsset.getPowerIconAsset(this.gameManager, attackPowerAssetId),
      })
    );

    const valueAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_VALUE_ICON
        : AssetIds.ENEMY_VALUE_ICON;
    const valueId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_VALUE
        : TextIds.ENEMY_VALUE;
    const valueValue =
      characterType === CharacterTypes.PLAYER
        ? this.playerValue
        : this.enemyValue;
    this.gameManager.assetManager.textManager.addText(
      valueId,
      new FontWithPosition(
        valueId,
        20,
        powerY + portraitGap,
        valueValue.toString(),
        { icon: IconAsset.getValueIconAsset(this.gameManager, valueAssetId) }
      )
    );
  }

  private buildPlayerPortrait(): void {
    this.buildPortrait(CharacterTypes.PLAYER);
    this.buildPowerAndValues(
      CharacterTypes.PLAYER,
      this.getPortraitHeight() ?? 0
    );
  }

  private getPortraitHeight(): number | undefined {
    const portraitAsset = this.gameManager.assetManager.getAsset(
      AssetIds.PLAYER_PORTRAIT,
      AssetIds.PLAYER_PORTRAIT
    );
    if (isEmpty(portraitAsset)) {
      return;
    }
    return portraitAsset.getHeight();
  }

  private getPortraitWidth(): number | undefined {
    const portraitAsset = this.gameManager.assetManager.getAsset(
      AssetIds.PLAYER_PORTRAIT,
      AssetIds.PLAYER_PORTRAIT
    );
    if (isEmpty(portraitAsset)) {
      return;
    }
    return portraitAsset.getWidth();
  }

  private buildEnemyPortrait(): void {
    this.buildPortrait(CharacterTypes.ENEMY);
    this.buildPowerAndValues(
      CharacterTypes.ENEMY,
      this.getPortraitHeight() ?? 0
    );
  }

  private buildPortrait(characterType: CharacterTypes): void {
    if (
      this.portraitPosition === undefined &&
      characterType === CharacterTypes.PLAYER
    ) {
      this.portraitPosition = this.cardAssets.getHandYCoordinate(characterType);
    }
    const portraitPosition = this.getPortraitPosition(characterType);

    const portraitBackgroundW = 99;
    const portraitBackgroundH = 106;
    const portraitBackgroundAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_PORTRAIT_BACKGROUND
        : AssetIds.ENEMY_PORTRAIT_BACKGROUND;
    this.gameManager.assetManager.addAsset(
      portraitBackgroundAssetId,
      new Asset(
        this.gameManager,
        portraitBackgroundAssetId,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PortraitBackground.png"
        ),
        5,
        portraitPosition,
        portraitBackgroundW,
        portraitBackgroundH
      )
    );

    const portraitW = 54;
    const portraitH = 53;
    const portraitAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_PORTRAIT
        : AssetIds.ENEMY_PORTRAIT;
    this.gameManager.assetManager.addAsset(
      portraitAssetId,
      new Asset(
        this.gameManager,
        portraitAssetId,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/Portrait.png"
        ),
        5,
        portraitPosition,
        portraitW,
        portraitH
      )
    );

    const portraitNameId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_PORTRAIT_NAME
        : TextIds.ENEMY_PORTRAIT_NAME;
    const nameY = portraitH + portraitPosition + 10;
    this.gameManager.assetManager.textManager.addText(
      portraitNameId,
      new FontWithPosition(
        portraitNameId,
        10,
        nameY,
        characterType === CharacterTypes.PLAYER
          ? this.gameManager.player.name
          : this.enemy.name,
        { size: 16, font: Fonts.FANTASY }
      )
    );

    const portraitLevelId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_PORTRAIT_LEVEL
        : TextIds.ENEMY_PORTRAIT_LEVEL;
    const levelY = nameY + portraitGap;
    this.gameManager.assetManager.textManager.addText(
      portraitLevelId,
      new FontWithPosition(
        portraitLevelId,
        10,
        levelY,
        `Lvl ${
          characterType === CharacterTypes.PLAYER
            ? this.gameManager.player.level
            : this.enemy.level
        }`,
        { size: 9 }
      )
    );

    if (characterType === CharacterTypes.PLAYER) {
      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PORTRAIT_EXPERIENCE,
        new FontWithPosition(
          TextIds.PLAYER_PORTRAIT_EXPERIENCE,
          portraitBackgroundW,
          levelY,
          `${this.gameManager.player.experience} xp`,
          { size: 9, format: Format.RIGHT }
        )
      );

      const perksText = new FontWithPosition(
        TextIds.PLAYER_PERKS,
        portraitW + 13,
        portraitPosition + 20,
        "Perks",
        { size: 9 }
      );
      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PERKS,
        perksText
      );

      this.gameManager.assetManager.addAsset(
        AssetIds.PERKS_BUTTON,
        new Asset(
          this.gameManager,
          AssetIds.PERKS_BUTTON,
          this.gameManager.assetManager.assetLoader.loadImage(
            "Assets/Images/PerksButton.png"
          ),
          portraitW + 8,
          portraitPosition + 10,
          39,
          18,
          {
            onClick: () => this.gameManager.perkScreen.showPerks(),
            clickSound: this.gameManager.assetManager.buttonClickSound,
            associatedTexts: [perksText],
            hoverEffect: [HoverEffects.CHANGE_COLOR],
            mousePressEffect: [
              MousePressEffects.DARKEN,
              MousePressEffects.SHIFT_DOWN,
            ],
            alwaysEnabled: true,
          }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PORTRAIT_MONEY,
        new FontWithPosition(
          TextIds.PLAYER_PORTRAIT_MONEY,
          portraitBackgroundW - 2,
          nameY,
          `${this.gameManager.player.money}`,
          {
            size: 9,
            icon: new IconAsset(
              this.gameManager,
              AssetIds.MONEY_ICON,
              this.gameManager.assetManager.assetLoader.loadImage(
                "Assets/Images/Mark.png"
              ),
              9,
              9
            ),
            format: Format.RIGHT,
          }
        )
      );
    }
  }

  buildDeck(characterType: CharacterTypes): void {
    const character = this.gameManager.getCharacter(characterType);
    if (isEmpty(character)) {
      return;
    }

    const deckPosition = this.dealer.getDeckPosition(characterType);
    const assetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_DECK
        : AssetIds.ENEMY_DECK;
    this.gameManager.assetManager.addAsset(
      assetId,
      new Asset(
        this.gameManager,
        assetId,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/BaseCardBack.png"
        ),
        deckPosition.x,
        deckPosition.y,
        cardWidth,
        cardHeight,
        {
          onHover: (asset) => character.showDeckOverview(asset),
          onUnhover: () =>
            this.gameManager.assetManager.tooltipManager.hideTooltip(),
          onClick: () => character.showDeckContents(),
          hoverEffect: [HoverEffects.WOBBLE, HoverEffects.SHIMMER],
          mousePressEffect: [MousePressEffects.SHIFT_DOWN],
          clickSound: this.cardAssets.cardClick,
          hoverSound: this.cardAssets.hoverSound,
          showDisabledColor: false,
        }
      )
    );
  }

  private buildEdelBoard(): void {
    if (isEmpty(this.edelCard)) {
      return;
    }

    const boardWidth = 149;
    const boardHeight = 23;
    const screenW = push.getWidth();
    const boardX = Math.floor((screenW - boardWidth) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.EDEL_BOARD,
      new Asset(
        this.gameManager,
        AssetIds.EDEL_BOARD,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/EdelBoard.png"
        ),
        boardX,
        5,
        boardWidth,
        boardHeight
      )
    );

    const centerX = screenW / 2;

    this.gameManager.assetManager.textManager.addText(
      TextIds.EDEL_LABEL,
      new FontWithPosition(
        TextIds.EDEL_LABEL,
        centerX,
        18,
        Card.getSuitName(this.edelCard.suit),
        {
          size: 16,
          format: Format.CENTER,
          font: Fonts.ELOQUENT,
        }
      )
    );

    const suitImage = this.gameManager.assetManager.assetLoader.loadImage(
      CardAssets.getSuitAssetPath(this.edelCard.suit)
    );
    this.gameManager.assetManager.addAsset(
      AssetIds.EDEL_SUIT_ICON_LEFT,
      new Asset(
        this.gameManager,
        AssetIds.EDEL_SUIT_ICON_LEFT,
        suitImage,
        boardX + 5,
        8,
        16,
        16
      )
    );
    this.gameManager.assetManager.addAsset(
      AssetIds.EDEL_SUIT_ICON_RIGHT,
      new Asset(
        this.gameManager,
        AssetIds.EDEL_SUIT_ICON_RIGHT,
        suitImage,
        boardX + boardWidth - suitImage.getWidth() - 5,
        8,
        16,
        16
      )
    );
  }

  private playWinFireSound(): void {
    if (!this.winFireSound.isPlaying()) {
      this.winFireSound.play();
    }
  }

  private buildWinFire(): void {
    if (this.gameManager.assetManager.hasAssets(AssetIds.BASIC_WIN_FIRE)) {
      return; // Already built
    }

    const fireSprite = this.getWinFireSprite();
    const portraitWidth = this.getPortraitWidth() ?? 0;
    const portraitHeight = this.getPortraitHeight() ?? 0;

    const playerPortraitY = this.getPortraitPosition(CharacterTypes.PLAYER);
    const enemyPortraitY = this.getPortraitPosition(CharacterTypes.ENEMY);

    const portraitCenterX = 5 + portraitWidth / 2;
    const playerCenterY = playerPortraitY + portraitHeight / 2;
    const enemyCenterY = enemyPortraitY + portraitHeight / 2;
    const centerY = (playerCenterY + enemyCenterY) / 2;

    this.gameManager.assetManager.addAsset(
      AssetIds.BASIC_WIN_FIRE,
      new Asset(
        this.gameManager,
        AssetIds.BASIC_WIN_FIRE,
        fireSprite,
        portraitCenterX - fireSprite.getWidth() / 4,
        centerY - fireSprite.getHeight() / 4,
        90,
        90
      )
    );

    this.gameManager.assetManager.textManager.addText(
      TextIds.WIN_FIRE_TEXT,
      new FontWithPosition(
        TextIds.WIN_FIRE_TEXT,
        portraitCenterX + 20,
        centerY + 20,
        "You are winning!",
        {
          size: 9,
          format: Format.CENTER,
          outlineThickness: OutlineThickness.THICK,
        }
      )
    );

    const points = this.getPlayerPoints();
    if (points <= 0) {
      this.gameManager.assetManager.textManager.addText(
        TextIds.POINTS,
        new FontWithPosition(
          TextIds.POINTS,
          portraitCenterX + 15,
          centerY + 32,
          "But you'll get no points...",
          { size: 9, format: Format.CENTER }
        )
      );
    } else {
      this.gameManager.assetManager.textManager.addText(
        TextIds.POINTS,
        new FontWithPosition(
          TextIds.POINTS,
          portraitCenterX + 10,
          centerY + 32,
          "Points: " + points,
          { size: 9, format: Format.CENTER }
        )
      );
    }

    this.playWinFireSound();
  }

  private removeWinFire(): void {
    this.gameManager.assetManager.removeAssets(AssetIds.BASIC_WIN_FIRE);
    this.gameManager.assetManager.textManager.hideText(TextIds.WIN_FIRE_TEXT);
    this.gameManager.assetManager.textManager.hideText(TextIds.POINTS);
  }

  private getWinFireSprite(): Image {
    // TODO: render different fire sprites and animations based on how hard the player is about to win
    return this.gameManager.assetManager.assetLoader.loadImage(
      "Assets/Images/BasicWinFire.png"
    );
  }

  getPortraitPosition(characterType: CharacterTypes): number {
    return characterType === CharacterTypes.PLAYER
      ? this.portraitPosition ??
          this.cardAssets.getHandYCoordinate(characterType)
      : 5;
  }

  tallyEnemyPowerAndValue(): void {
    this.addEnemyPower(this.enemy.getCardPower());
    this.addEnemyValue(this.enemy.getCardValue());
  }
}
