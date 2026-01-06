/** @noSelfInFile */

import {
  AssetIds,
  CharacterTypes,
  TextIds as TextIds,
  Suits,
  GameStates,
  HoverEffects,
  MousePressEffects,
} from "../Enums";
import Dealer from "../Dealer";
import Enemy, { EnemyData } from "Enemies/Enemy";
import type GameManager from "../GameManager";
import CardAssets, { padding } from "Assets/CardAssets";
import * as push from "Libraries.push";
import Asset from "Assets/Asset";
import { isEmpty } from "Helpers";
import FontWithPosition, { Format, OutlineThickness } from "Assets/FontWithPosition";
import Card from "Cards/Card";
import { Image } from "love.graphics";

interface BoardData {
  discardUsed: number;
  playerPoints: number;
  enemyPoints: number;
  enemy: EnemyData;
  edelSuit: Suits;
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
  edelSuit = Suits.ACORNS;
  playerPower = 0;
  playerValue = 0;
  enemyPower = 0;
  enemyValue = 0;
  showingEdelView = true;
  cardAssets: CardAssets;
  letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png");
  attackButton = love.graphics.newImage("Assets/Images/AttackButton.png");
  discardButton = love.graphics.newImage("Assets/Images/DiscardButton.png");
  deselectButton = love.graphics.newImage("Assets/Images/DeselectButton.png");
  pointBoard = love.graphics.newImage("Assets/Images/PointBoard.png");
  edelBoard = love.graphics.newImage("Assets/Images/EdelBoard.png");
  portraitBackground = love.graphics.newImage(
    "Assets/Images/PortraitBackground.png"
  );
  portrait = love.graphics.newImage("Assets/Images/Portrait.png");
  baseDeck = love.graphics.newImage("Assets/Images/BaseCardBack.png");
  perksButton = love.graphics.newImage("Assets/Images/PerksButton.png");
  markIcon = love.graphics.newImage("Assets/Images/Mark.png");
  attackPowerIcon = love.graphics.newImage("Assets/Images/AttackPower.png");
  valueIcon = love.graphics.newImage("Assets/Images/Value.png");
  portraitPosition: number | undefined; // Saved off so it can be restored on resume
  winFireSound = love.audio.newSource("Assets/Sounds/Dominating.wav", "static");

  constructor(gameManager: GameManager, enemy?: Enemy) {
    this.gameManager = gameManager;
    this.enemy = enemy ?? new Enemy(gameManager);
    this.dealer = new Dealer(gameManager);
    this.cardAssets = new CardAssets(gameManager);
  }

  load(data: BoardData): void {
    this.discardUsed = data.discardUsed;
    this.playerPoints = data.playerPoints;
    this.enemyPoints = data.enemyPoints;
    this.edelSuit = data.edelSuit;
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
      edelSuit: this.edelSuit,
      playerPower: this.playerPower,
      playerValue: this.playerValue,
      enemyPower: this.enemyPower,
      enemyValue: this.enemyValue,
      showingInitialView: this.showingEdelView,
    };
  }

  getPlayerWinnings(): number {
    let winnings = this.playerValue - this.enemyValue;
    if (winnings < 0) winnings = 0;
    return winnings;
  }

  getEnemyWinnings(): number {
    let winnings = this.enemyValue - this.playerValue;
    if (winnings < 0) winnings = 0;
    return winnings;
  }


  handleStartFight(): void {
    this.showingEdelView = false;
    this.gameManager.assetManager.hideAsset(AssetIds.LETS_FIGHT_BUTTON);
    this.gameManager.assetManager.textManager.hideText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION
    );

    this.dealer.startGame();
    this.buildFightAssets();
    this.gameManager.assetManager.textManager.hideText(TextIds.EDEL_LABEL);
    this.gameManager.assetManager.hideAsset(AssetIds.EDEL_BOARD);
    this.gameManager.assetManager.hideAsset(AssetIds.EDEL_SUIT_ICON_LEFT);
    this.gameManager.assetManager.hideAsset(AssetIds.EDEL_SUIT_ICON_RIGHT);
  }

  buildFightAssets(): void {
    this.buildPrimaryButtons();
    this.buildPointBoard();
    this.buildPowerAndValues(CharacterTypes.PLAYER);
    this.buildPowerAndValues(CharacterTypes.ENEMY);
  }

  handleAttack(): void {
    if (!this.gameManager.player.anySelectedCards()) return;
    if (this.enemy.deck.length === 0) {
      this.endFight();
      return;
    }

    if (this.playerPower > this.enemyPower) {
      this.addPlayerPoints(this.getPlayerWinnings());
    } else {
      this.addEnemyPoints(this.getEnemyWinnings());
    }

    this.clearStats();

    this.gameManager.player.removeSelectedCardsFromHand();
    this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER);

    this.enemy.removeAllCardsFromHand();
    this.gameManager.board?.dealer.dealCards(CharacterTypes.ENEMY);
  }

  private addPlayerPoints(points: number): void {
    this.playerPoints += points;

    this.gameManager.assetManager.textManager.updateText(
      TextIds.POINTS_PLAYER,
      `${this.gameManager.player.name}: ${this.playerPoints}`
    );
  }

  private addEnemyPoints(points: number): void {
    this.enemyPoints += points;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.POINTS_ENEMY,
      `${this.enemy.name}: ${this.enemyPoints}`
    );
  }

  handleDiscard(): void {
    if (!this.gameManager.player.anySelectedCards()) return;
    if (this.getRemainingDiscards() <= 0) return;

    this.gameManager.player.discard();

    this.discardUsed = this.discardUsed + 1;

    // Update the discard counter
    const remaining = this.getRemainingDiscards();
    this.gameManager.assetManager.textManager.updateText(
      TextIds.DISCARD_BUTTON_COUNTER,
      `${remaining}/${this.gameManager.player.discards}`
    );

    if (remaining <= 0) {
      // Disable the discard button
      this.gameManager.assetManager.disableAsset(AssetIds.DISCARD_BUTTON);
      this.gameManager.assetManager.textManager.disableText(
        TextIds.DISCARD_BUTTON_CAPTION
      );
      this.gameManager.assetManager.textManager.disableText(
        TextIds.DISCARD_BUTTON_COUNTER
      );
    }

    // Refill the player's hand after discarding!isEmpty(asset.onClick)
    this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER);
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
    this.gameManager.player.deselectAllCards();
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
    this.addPlayerPower(-this.playerPower);
    this.addPlayerValue(-this.playerValue);
    this.addEnemyPower(-this.enemyPower);
    this.addEnemyValue(-this.enemyValue);
  }

  addPlayerPower(power: number): void {
    this.playerPower += power;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_POWER,
      `Power: ${this.playerPower}`
    );
    if (this.playerPower > this.enemyPower) {
      this.playWinFireSound();
      this.buildWinFire();
    } else {
      this.removeWinFire();
    }
  }

  addPlayerValue(value: number): void {
    this.playerValue += value;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.PLAYER_VALUE,
      `Value: ${this.playerValue}`
    );
    this.gameManager.assetManager.textManager.updateText(
      TextIds.WINNINGS,
      `Winnings: ${this.getPlayerWinnings()}`
    );
  }

  addEnemyPower(power: number): void {
    this.enemyPower += power;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_POWER,
      `Power: ${this.enemyPower}`
    );
  }

  addEnemyValue(value: number): void {
    this.enemyValue += value;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_VALUE,
      `Value: ${this.enemyValue}`
    );
  }

  buildAssets(): void {
    this.buildBackground();
    this.buildCardAssets();
    this.buildPlayerPortrait();
    this.buildEnemyPortrait();
    this.buildPlayerDeck();
    this.buildEnemyDeck();
    if (this.showingEdelView) {
      this.buildLetsFightButton();
      this.buildEdelBoard();
    } else {
      this.buildFightAssets();
    }
  }

  private buildCardAssets(): void {
    const playerCardPosition = this.cardAssets.determineCardStartingPosition(
      CharacterTypes.PLAYER
    );

    for (let i = 0; i < this.gameManager.player.hand.length; i++) {
      const card = this.gameManager.player.hand[i];
      const x = playerCardPosition.x + i * (this.cardAssets.baseW + padding);
      this.cardAssets.addAsset(
        card,
        x,
        playerCardPosition.y,
        !this.showingEdelView
      );
    }

    const enemyCardPosition = this.cardAssets.determineCardStartingPosition(
      CharacterTypes.ENEMY
    );
    for (let i = 0; i < this.enemy.hand.length; i++) {
      const card = this.enemy.hand[i];
      const x = enemyCardPosition.x + i * (this.cardAssets.baseW + padding);
      this.cardAssets.addAsset(card, x, enemyCardPosition.y, false);
    }
  }

  private buildLetsFightButton(): void {
    const buttonHeight = this.letsFightButton.getHeight();
    const buttonWidth = this.letsFightButton.getWidth();
    const screenW = push.getWidth();
    const screenH = push.getHeight();
    const buttonX = Math.floor((screenW - buttonWidth) / 2);
    const buttonY = Math.floor((screenH - buttonHeight) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.LETS_FIGHT_BUTTON,
      new Asset(
        AssetIds.LETS_FIGHT_BUTTON,
        this.letsFightButton,
        buttonX,
        buttonY + 85,
        { onClick: () => this.handleStartFight() }
      )
    );

    const centerX = buttonX + buttonWidth / 2;
    const centerY = buttonY + buttonHeight / 2;
    this.gameManager.assetManager.textManager.addText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION,
      new FontWithPosition(
        TextIds.LETS_FIGHT_BUTTON_CAPTION,
        centerX,
        centerY,
        "Let's Fight!",
        {
          size: 27,
          format: Format.CENTER,
          outlineThickness: OutlineThickness.THICK,
        }
      )
    );
  }

  private buildPrimaryButtons(): void {
    const gap = 10;
    const btnW = this.attackButton.getWidth();
    const totalW = btnW * 3 + gap * 2;
    const buttonY =
      this.cardAssets.getCardPosition(CharacterTypes.PLAYER) +
      this.cardAssets.baseH +
      gap;
    const buttonX = Math.floor((push.getWidth() - totalW) / 2);
    this.buildAttackButton(buttonX, buttonY, btnW);
    const discardX = this.buildDiscardButton(buttonX, buttonY, btnW, gap);
    this.buildDeselectButton(discardX, buttonY, btnW, gap);

    // Disable buttons initially since no cards are selected
    this.updatePrimaryButtonStates();
  }

  private buildAttackButton(
    buttonX: number,
    buttonY: number,
    btnW: number
  ): void {
    const centerX = buttonX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
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
      new Asset(AssetIds.ATTACK_BUTTON, this.attackButton, buttonX, buttonY, {
        onClick: () => this.handleAttack(),
        clickSound: love.audio.newSource(
          "Assets/Sounds/AttackClicked.flac",
          "static"
        ),
        associatedTexts: [attackButtonText],
        hoverEffect: [HoverEffects.CHANGE_COLOR],
        mousePressEffect: [
          MousePressEffects.DARKEN,
          MousePressEffects.SHIFT_DOWN,
        ],
      })
    );
  }

  private buildDiscardButton(
    buttonX: number,
    buttonY: number,
    btnW: number,
    gap: number
  ): number {
    const discardX = buttonX + btnW + gap;

    const centerX = discardX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
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
        AssetIds.DISCARD_BUTTON,
        this.discardButton,
        discardX,
        buttonY,
        {
          onClick: () => this.handleDiscard(),
          associatedTexts: [discardButtonCaptionText, discardButtonCounterText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
        }
      )
    );

    return discardX;
  }

  private buildDeselectButton(
    discardX: number,
    buttonY: number,
    btnW: number,
    gap: number
  ): void {
    const deselectX = discardX + btnW + gap;

    const centerX = deselectX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
    const deselectButtonCaptionText = new FontWithPosition(
      TextIds.DESELECT_BUTTON_CAPTION,
      centerX + 2,
      centerY,
      "Deselect",
      {
        size: 18,
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
        AssetIds.DESELECT_BUTTON,
        this.deselectButton,
        deselectX,
        buttonY,
        {
          onClick: () => this.gameManager.player.unselectCards(),
          associatedTexts: [deselectButtonCaptionText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
        }
      )
    );
  }

  updatePrimaryButtonStates(): void {
    const hasSelectedCards = this.gameManager.player.anySelectedCards();

    if (hasSelectedCards) {
      this.gameManager.assetManager.enableAsset(AssetIds.ATTACK_BUTTON);
      this.gameManager.assetManager.textManager.enableText(
        TextIds.ATTACK_BUTTON_CAPTION
      );

      this.gameManager.assetManager.enableAsset(AssetIds.DISCARD_BUTTON);
      this.gameManager.assetManager.textManager.enableText(
        TextIds.DISCARD_BUTTON_CAPTION
      );
      this.gameManager.assetManager.textManager.enableText(
        TextIds.DISCARD_BUTTON_COUNTER
      );

      this.gameManager.assetManager.enableAsset(AssetIds.DESELECT_BUTTON);
      this.gameManager.assetManager.textManager.enableText(
        TextIds.DESELECT_BUTTON_CAPTION
      );
    } else {
      this.gameManager.assetManager.disableAsset(AssetIds.ATTACK_BUTTON);
      this.gameManager.assetManager.textManager.disableText(
        TextIds.ATTACK_BUTTON_CAPTION
      );

      this.gameManager.assetManager.disableAsset(AssetIds.DISCARD_BUTTON);
      this.gameManager.assetManager.textManager.disableText(
        TextIds.DISCARD_BUTTON_CAPTION
      );
      this.gameManager.assetManager.textManager.disableText(
        TextIds.DISCARD_BUTTON_COUNTER
      );

      this.gameManager.assetManager.disableAsset(AssetIds.DESELECT_BUTTON);
      this.gameManager.assetManager.textManager.disableText(
        TextIds.DESELECT_BUTTON_CAPTION
      );
    }
  }

  private buildPointBoard(): void {
    const boardWidth = this.pointBoard.getWidth();
    const screenW = push.getWidth();
    const buttonX = Math.floor((screenW - boardWidth) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.POINT_DISPLAY,
      new Asset(AssetIds.POINT_DISPLAY, this.pointBoard, buttonX, 5)
    );

    const centerX = screenW / 2;
    const textY = this.pointBoard.getHeight() / 2 + 5;

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
  }

  private buildPowerAndValues(characterType: CharacterTypes): void {
    const portraitHeight = this.portrait.getHeight();
    const portraitAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_PORTRAIT
        : AssetIds.ENEMY_PORTRAIT;
    const portraitAsset = this.gameManager.assetManager.getAsset(
      portraitAssetId,
      portraitAssetId
    );
    if (isEmpty(portraitAsset)) {
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
    this.gameManager.assetManager.textManager.addText(
      powerId,
      new FontWithPosition(
        powerId,
        15,
        portraitHeight + portraitAsset.y + 18,
        `Power: ${powerValue}`,
        { size: 9, icon: this.attackPowerIcon }
      )
    );

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
        15,
        portraitHeight + portraitAsset.y + 28,
        `Value: ${valueValue}`,
        { size: 9, icon: this.valueIcon }
      )
    );
  }

  private buildPlayerPortrait(): void {
    this.buildPortrait(CharacterTypes.PLAYER);
  }

  private buildEnemyPortrait(): void {
    this.buildPortrait(CharacterTypes.ENEMY);
  }

  private buildPortrait(characterType: CharacterTypes): void {
    if (
      this.portraitPosition === undefined &&
      characterType === CharacterTypes.PLAYER
    ) {
      this.portraitPosition = this.cardAssets.getCardPosition(characterType);
    }
    const portraitPosition = this.getPortraitPosition(characterType);

    const portraitBackgroundAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_PORTRAIT_BACKGROUND
        : AssetIds.ENEMY_PORTRAIT_BACKGROUND;
    this.gameManager.assetManager.addAsset(
      portraitBackgroundAssetId,
      new Asset(
        portraitBackgroundAssetId,
        this.portraitBackground,
        5,
        portraitPosition
      )
    );

    const portraitAssetId =
      characterType === CharacterTypes.PLAYER
        ? AssetIds.PLAYER_PORTRAIT
        : AssetIds.ENEMY_PORTRAIT;
    this.gameManager.assetManager.addAsset(
      portraitAssetId,
      new Asset(portraitAssetId, this.portrait, 5, portraitPosition)
    );

    const portraitWidth = this.portrait.getWidth() - 12;
    const portraitHeight = this.portrait.getHeight() - 12;
    const portraitBackgroundWidth = this.portraitBackground.getWidth() - 28;

    const portraitNameId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_PORTRAIT_NAME
        : TextIds.ENEMY_PORTRAIT_NAME;
    this.gameManager.assetManager.textManager.addText(
      portraitNameId,
      new FontWithPosition(
        portraitNameId,
        10,
        portraitHeight + portraitPosition + 8,
        characterType === CharacterTypes.PLAYER
          ? this.gameManager.player.name
          : this.enemy.name,
        { size: 9, outlineThickness: OutlineThickness.THICK }
      )
    );

    const portraitLevelId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_PORTRAIT_LEVEL
        : TextIds.ENEMY_PORTRAIT_LEVEL;
    this.gameManager.assetManager.textManager.addText(
      portraitLevelId,
      new FontWithPosition(
        portraitLevelId,
        10,
        portraitHeight + portraitPosition + 20,
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
          portraitBackgroundWidth,
          portraitHeight + portraitPosition + 20,
          `${this.gameManager.player.experience} xp`,
          { size: 9, format: Format.RIGHT }
        )
      );

      this.gameManager.assetManager.addAsset(
        AssetIds.PERKS_BUTTON,
        new Asset(
          AssetIds.PERKS_BUTTON,
          this.perksButton,
          portraitWidth + 10,
          portraitPosition + 10,
          {
            onClick: () =>
              this.gameManager.switchBasedOnGameState(GameStates.PERKS),
          }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PERKS,
        new FontWithPosition(
          TextIds.PLAYER_PERKS,
          portraitWidth + 15,
          portraitPosition + 20,
          "Perks",
          { size: 9 }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PORTRAIT_MONEY,
        new FontWithPosition(
          TextIds.PLAYER_PORTRAIT_MONEY,
          portraitBackgroundWidth,
          portraitHeight + portraitPosition + 8,
          `${this.gameManager.player.money}`,
          { size: 9, icon: this.markIcon, format: Format.RIGHT }
        )
      );
    }
  }

  private buildPlayerDeck(): void {
    const portraitPosition = this.getPortraitPosition(CharacterTypes.PLAYER);
    this.gameManager.assetManager.addAsset(
      AssetIds.PLAYER_DECK,
      new Asset(
        AssetIds.PLAYER_DECK,
        this.baseDeck,
        push.getWidth() - this.baseDeck.getWidth() - 5,
        portraitPosition
      )
    );
  }

  private buildEnemyDeck(): void {
    this.gameManager.assetManager.addAsset(
      AssetIds.ENEMY_DECK,
      new Asset(
        AssetIds.ENEMY_DECK,
        this.baseDeck,
        push.getWidth() - this.baseDeck.getWidth() - 5,
        5
      )
    );
  }

  private buildEdelBoard(): void {
    const boardWidth = this.edelBoard.getWidth();
    const screenW = push.getWidth();
    const boardX = Math.floor((screenW - boardWidth) / 2);
        this.gameManager.assetManager.addAsset(
      AssetIds.EDEL_BOARD,
      new Asset(AssetIds.EDEL_BOARD, this.edelBoard, boardX, 5)
    );

    const centerX = screenW / 2;    

    this.gameManager.assetManager.textManager.addText(
      TextIds.EDEL_LABEL,
      new FontWithPosition(
        TextIds.EDEL_LABEL,
        centerX,
        20,
        Card.getSuitName(this.edelSuit),
        { size: 16, format: Format.CENTER, filepath: "Assets/Fonts/Bitmgothic.ttf" }
      )
    );

    const suitImage = love.graphics.newImage(CardAssets.getSuitAssetPath(this.edelSuit));
    this.gameManager.assetManager.addAsset(AssetIds.EDEL_SUIT_ICON_LEFT, new Asset(
      AssetIds.EDEL_SUIT_ICON_LEFT,
      suitImage,
      boardX + 5,
      10,
    ));
    this.gameManager.assetManager.addAsset(AssetIds.EDEL_SUIT_ICON_RIGHT, new Asset(
      AssetIds.EDEL_SUIT_ICON_RIGHT,
      suitImage,
      boardX + boardWidth - suitImage.getWidth() - 5,
      10,
    ));
  }

  private buildBackground(): void {
    this.gameManager.assetManager.addAsset(
      AssetIds.BACKGROUND,
      new Asset(
        AssetIds.BACKGROUND,
        love.graphics.newImage(this.gameManager.biome.boardBackgroundImagePath),
        0,
        0
      )
    );
  }

  private playWinFireSound(): void {
    if (!this.winFireSound.isPlaying()) {
      this.winFireSound.play();
    }
  }

  private buildWinFire(): void {
    const fireSprite = this.getWinFireSprite();
    const portraitWidth = this.portrait.getWidth();
    const portraitHeight = this.portrait.getHeight();

    const playerPortraitY = this.getPortraitPosition(CharacterTypes.PLAYER);
    const enemyPortraitY = this.getPortraitPosition(CharacterTypes.ENEMY);

    const portraitCenterX = 5 + portraitWidth / 2;
    const playerCenterY = playerPortraitY + portraitHeight / 2;
    const enemyCenterY = enemyPortraitY + portraitHeight / 2;
    const centerY = (playerCenterY + enemyCenterY) / 2;

    this.gameManager.assetManager.addAsset(
      AssetIds.BASIC_WIN_FIRE,
      new Asset(
        AssetIds.BASIC_WIN_FIRE,
        fireSprite,
        portraitCenterX - fireSprite.getWidth() / 4,
        centerY - fireSprite.getHeight() / 4
      )
    );

    this.gameManager.assetManager.textManager.addText(
      TextIds.WIN_FIRE_TEXT,
      new FontWithPosition(
        TextIds.WIN_FIRE_TEXT,
        portraitCenterX * 2,
        centerY + 10,
        "You are\ndominating!",
        { size: 16, format: Format.CENTER }
      )
    );

    const winnings = this.getPlayerWinnings();
    if (winnings <= 0) {
      this.gameManager.assetManager.textManager.addText(
        TextIds.WINNINGS,
        new FontWithPosition(
          TextIds.WINNINGS,
          portraitCenterX * 2,
          centerY + 50,
          "But you'll get no winnings...",
          { size: 10, format: Format.CENTER }
        )
      );
    } else {
      this.gameManager.assetManager.textManager.addText(
        TextIds.WINNINGS,
        new FontWithPosition(
          TextIds.WINNINGS,
          portraitCenterX * 2,
          centerY + 50,
          "Winnings: " + winnings,
          { size: 10, format: Format.CENTER }
        )
      );
    }
  }

  private removeWinFire(): void {
    this.gameManager.assetManager.hideAsset(AssetIds.BASIC_WIN_FIRE);
    this.gameManager.assetManager.textManager.hideText(TextIds.WIN_FIRE_TEXT);
    this.gameManager.assetManager.textManager.hideText(TextIds.WINNINGS);
  }

  private getWinFireSprite(): Image {
    // TODO: render different fire sprites and animations based on how hard the player is about to win
    return love.graphics.newImage("Assets/Images/BasicWinFire.png");
  }

  getPortraitPosition(characterType: CharacterTypes): number {
    return characterType === CharacterTypes.PLAYER
      ? this.portraitPosition ?? this.cardAssets.getCardPosition(characterType)
      : 5;
  }
}
