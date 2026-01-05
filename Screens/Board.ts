/** @noSelfInFile */

import { AssetIds, CharacterTypes, TextIds as TextIds, Suits } from "../Enums";
import Dealer from "../Dealer";
import Draw from "../Draw";
import Enemy, { EnemyData } from "Enemies/Enemy";
import * as suit from "Libraries.suit-master.suit";
import type GameManager from "../GameManager";
import CardAssets from "Assets/CardAssets";
import * as push from "Libraries.push";
import Asset from "Assets/Asset";
import { isEmpty } from "Helpers";
import FontWithPosition, { Format } from "Assets/FontWithPosition";
import Grass from "Biomes/Grass";
import Biome from "Biomes/Biome";
import Card from "Cards/Card";
import { Image } from "love.graphics";

const padding = 20;

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
  showingInitialView = true;
  cardAssets: CardAssets;
  letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png");
  attackButton = love.graphics.newImage("Assets/Images/AttackButton.png");
  discardButton = love.graphics.newImage("Assets/Images/DiscardButton.png");
  deselectButton = love.graphics.newImage("Assets/Images/DeselectButton.png");
  pointBoard = love.graphics.newImage("Assets/Images/PointBoard.png");
  portraitBackground = love.graphics.newImage(
    "Assets/Images/PortraitBackground.png"
  );
  portrait = love.graphics.newImage("Assets/Images/Portrait.png");
  baseDeck = love.graphics.newImage("Assets/Images/BaseCardBack.png");
  perksButton = love.graphics.newImage("Assets/Images/PerksButton.png");
  markIcon = love.graphics.newImage("Assets/Images/Mark.png");
  attackPowerIcon = love.graphics.newImage("Assets/Images/AttackPower.png");
  valueIcon = love.graphics.newImage("Assets/Images/Value.png");
  biome: Biome;
  portraitPosition: number | undefined; // Saved off so it can be restored on resume
  winFireSound = love.audio.newSource("Assets/Sounds/Dominating.wav", "static");

  constructor(gameManager: GameManager, enemy?: Enemy) {
    this.gameManager = gameManager;
    this.enemy = enemy ?? new Enemy(gameManager);
    this.dealer = new Dealer(gameManager);
    this.cardAssets = new CardAssets(gameManager);
    this.biome = new Grass(); // TODO: initialize this based on data from the map
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
    this.showingInitialView = data.showingInitialView ?? true;

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
      showingInitialView: this.showingInitialView,
    };
  }

  drawBoard(): void {
    if (!this.gameManager.devMode) {
      return;
    }
    if (this.showingInitialView) {
      this.drawInitialView();
    } else {
      this.drawNormalView();
    }
  }

  drawInitialView(): void {
    const btnW = 140;
    const btnH = 70;
    const lblH = 30;
    const padX = 20;
    const padY = 20;

    const contentW = this.getContentWidth();
    const coords = this.getStartingCoordinates(contentW, btnH, lblH, padY);
    const startX = coords.startX;
    let startY = coords.startY;

    // Trump suit label at the top
    this.renderTrumpSuitLabel();

    // Enemy deck visualization (left side)
    this.renderEnemyDeck();

    // Enemy row
    this.renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY);

    // Player row (below enemy) with buttons instead of selectable cards
    startY = startY + lblH + padY + btnH + 200;
    this.renderPlayerRowInitial(
      startX,
      startY,
      contentW,
      btnW,
      btnH,
      lblH,
      padX,
      padY
    );

    // Let's Fight button
    this.renderLetsFightButton(startY + lblH + btnH + padY + 50, btnW, btnH);

    // Player info (upper-right)
    Draw.playerInfo(this.gameManager.player, this.gameManager);

    // Player deck visualization (bottom right)
    Draw.playerDeck(this.gameManager.player, { showDiscards: true });
  }

  drawNormalView(): void {
    const btnW = 140;
    const btnH = 70;
    const lblH = 30;
    const padX = 20;
    const padY = 20;

    const contentW = this.getContentWidth();
    const coords = this.getStartingCoordinates(contentW, btnH, lblH, padY);
    const startX = coords.startX;
    let startY = coords.startY;

    // Points display (top center)
    this.renderPointsDisplay();

    // Enemy deck visualization (left side)
    this.renderEnemyDeck();

    // Enemy stats panel (left of enemy row)
    this.renderEnemyStats(startX, startY);

    // Enemy row
    this.renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY);

    // Player row (below enemy)
    startY = startY + lblH + padY + btnH + 200;
    this.renderPlayerRow(
      startX,
      startY,
      contentW,
      btnW,
      btnH,
      lblH,
      padX,
      padY
    );

    // Submit button centered below
    this.renderAttackButton(
      startY + lblH + btnH + padY + 50,
      btnW,
      btnH,
      padX,
      padY
    );

    // Player selected stats panel (right of player row)
    this.renderPlayerSelectedStats(startX, startY, contentW, btnW);

    // Win status display (right of player row)
    this.renderWinStatus(startX, startY);

    // Player info (upper-right)
    Draw.playerInfo(this.gameManager.player, this.gameManager);

    // Player deck visualization (bottom right)
    Draw.playerDeck(this.gameManager.player, { showDiscards: true });

    // Discard counter (bottom center)
    this.renderDiscardCounter();
  }

  getStartingCoordinates(
    contentW: number,
    btnH: number,
    groupH: number,
    padY: number
  ): { startX: number; startY: number } {
    const totalH = groupH * 2 + padY + btnH; // two groups plus spacing plus submit button

    const centerX = love.graphics.getWidth() / 2;
    const centerY = love.graphics.getHeight() / 2;
    return {
      startX: Math.floor(centerX - contentW / 2),
      startY: Math.floor(centerY - totalH / 2 - 200),
    };
  }

  getContentWidth(): number {
    const enemyHand = this.enemy.hand;
    const playerHand = this.gameManager.player.hand;

    const rowWidth = (count: number): number => {
      if (count <= 0) return 100;
      return count * 100 + (count - 1) * 20;
    };

    return Math.max(
      rowWidth(enemyHand.length),
      rowWidth(playerHand.length),
      300
    );
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

  renderWinStatus(startX: number, startY: number): void {
    if (this.playerPower > this.enemyPower) {
      const gap = 30;
      const panelW = 180;
      const selectedStatsW = this.gameManager.player.anySelectedCards()
        ? 180
        : 0;
      const selectedStatsGap = this.gameManager.player.anySelectedCards()
        ? gap
        : 0;
      const x = startX - panelW - gap - selectedStatsW - selectedStatsGap;

      suit.layout.reset(x, startY, 10, 10);
      suit.Label(
        "You will slay your foe!",
        { align: "left" },
        ...suit.layout.row(panelW, 40)
      );
      suit.Label(
        "Your cashout: " + this.getPlayerWinnings(),
        { align: "left" },
        ...suit.layout.row(panelW, 30)
      );
    }
  }

  renderTrumpSuitLabel(): void {
    const screenW = love.graphics.getWidth();
    const centerX = screenW / 2;
    const panelW = 300;
    const panelX = Math.floor(centerX - panelW / 2);

    suit.layout.reset(panelX, 20, 10, 10);
    suit.Label(
      "Trump Suit: " + this.edelSuit,
      { align: "center" },
      ...suit.layout.row(panelW, 40)
    );
  }

  renderPointsDisplay(): void {
    const screenW = love.graphics.getWidth();
    const centerX = screenW / 2;
    const panelW = 300;
    const panelX = Math.floor(centerX - panelW / 2);

    suit.layout.reset(panelX, 70, 10, 10);
    suit.Label(
      `${this.enemy.name}: ${this.enemyPoints} | Player: ${this.playerPoints}`,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
  }

  renderEnemyStats(startX: number, startY: number): void {
    const gap = 30;
    const panelW = 150;
    const x = startX - panelW - gap;

    suit.layout.reset(x, startY, 10, 10);
    suit.Label(
      `${this.enemy.name} Hand`,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
    suit.Label(
      "Value: " + this.enemyValue,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
    suit.Label(
      "Power: " + this.enemyPower,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
  }

  renderEnemyDeck(): void {
    const enemyDeck = this.enemy.deck;

    suit.layout.reset(10, 10, 10, 10);
    suit.Label(
      `${this.enemy.name} Deck (${enemyDeck.length} cards)`,
      { align: "left" },
      ...suit.layout.row(150, 30)
    );
    suit.layout.row(0, 5);

    // Display each card in the enemy's deck
    for (const card of enemyDeck) {
      const cardText =
        card.rank +
        " " +
        card.suit +
        " - Val: " +
        card.value +
        ", Pow: " +
        card.power;
      suit.Label(cardText, { align: "left" }, ...suit.layout.row(150, 25));
    }
  }

  renderPlayerSelectedStats(
    startX: number,
    startY: number,
    contentW: number,
    btnW: number
  ): void {
    // Only show when the player has at least one selected card
    if (!this.gameManager.player.anySelectedCards()) return;

    const gap = 30;
    const panelW = 180;
    const x = startX - panelW - gap;

    suit.layout.reset(x, startY, 10, 10);
    suit.Label(
      "Selected Hand",
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
    suit.Label(
      "Value: " + this.playerValue,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
    suit.Label(
      "Power: " + this.playerPower,
      { align: "center" },
      ...suit.layout.row(panelW, 30)
    );
  }

  renderEnemyRow(
    startX: number,
    startY: number,
    contentW: number,
    btnW: number,
    btnH: number,
    lblH: number,
    padX: number,
    padY: number
  ): void {
    const enemyHand = this.enemy.hand;
    suit.layout.reset(startX, startY, padX, padY);
    suit.Label(
      "Enemy hand: " + enemyHand.length,
      { align: "left" },
      ...suit.layout.row(contentW, lblH)
    );
    suit.layout.row(0, 0);
    for (const card of enemyHand) {
      const labelText =
        card.rank +
        " " +
        card.suit +
        " (Val: " +
        card.value +
        ", Pow: " +
        card.power +
        ")";
      suit.Label(labelText, { align: "left" }, ...suit.layout.col(btnW, btnH));
    }
  }

  renderPlayerRowInitial(
    startX: number,
    startY: number,
    contentW: number,
    btnW: number,
    btnH: number,
    lblH: number,
    padX: number,
    padY: number
  ): void {
    const playerHand = this.gameManager.player.hand;
    suit.layout.reset(startX, startY, padX, padY);
    suit.Label(
      "Your hand: " + playerHand.length,
      { align: "left" },
      ...suit.layout.row(contentW, lblH)
    );
    suit.layout.row(0, 0);
    for (const card of playerHand) {
      const cardText =
        card.rank +
        " " +
        card.suit +
        " (Val: " +
        card.value +
        ", Pow: " +
        card.power +
        ")";
      suit.Button(cardText, {}, ...suit.layout.col(btnW, btnH));
    }
  }

  renderPlayerRow(
    startX: number,
    startY: number,
    contentW: number,
    btnW: number,
    btnH: number,
    lblH: number,
    padX: number,
    padY: number
  ): void {
    const playerHand = this.gameManager.player.hand;
    suit.layout.reset(startX, startY, padX, padY);
    suit.Label(
      "Your hand: " + playerHand.length,
      { align: "left" },
      ...suit.layout.row(contentW, lblH)
    );
    suit.layout.row(0, 0);
    for (const card of playerHand) {
      Draw.card(card, btnW, btnH, { multiSelect: true });
    }
  }

  renderLetsFightButton(startY: number, btnW: number, btnH: number): void {
    const screenW = love.graphics.getWidth();
    const buttonW = 200;
    const buttonX = Math.floor(screenW / 2 - buttonW / 2);

    suit.layout.reset(buttonX, startY, 20, 20);
    const hit = suit.Button(
      "Let's Fight!",
      {},
      ...suit.layout.row(buttonW, btnH)
    ).hit;

    if (hit) {
      this.handleStartFight();
    }
  }

  renderAttackButton(
    startY: number,
    btnW: number,
    btnH: number,
    padX: number,
    padY: number
  ): void {
    // Center the buttons horizontally
    const gap = 20;
    const totalW = btnW * 3 + gap * 2;

    suit.layout.reset(
      love.graphics.getWidth() / 2 - totalW / 2,
      startY,
      padX,
      padY
    );

    const attackHit = suit.Button(
      "Attack",
      {},
      ...suit.layout.col(btnW, btnH)
    ).hit;

    // Check if discard button should be enabled
    const discardEnabled = this.discardUsed < this.gameManager.player.discards;
    const discardLabel = discardEnabled ? "Discard" : "Discard (used)";
    const discardHit = suit.Button(
      discardLabel,
      {},
      ...suit.layout.col(btnW, btnH)
    ).hit;

    const deselectHit = suit.Button(
      "Deselect All",
      {},
      ...suit.layout.col(btnW, btnH)
    ).hit;

    if (attackHit) {
      this.handleAttack();
    }
    if (discardHit && discardEnabled) {
      this.handleDiscard();
    }
    if (deselectHit) {
      this.gameManager.player.unselectCards();
    }
  }

  renderDiscardCounter(): void {
    const screenW = love.graphics.getWidth();
    const screenH = love.graphics.getHeight();
    const panelX = screenW - 170; // Right side, aligned with discard pile
    const panelY = screenH - 240; // Above the discard pile visualization

    suit.layout.reset(panelX, panelY, 10, 10);
    suit.Label(
      "Discards Remaining: " +
        (this.gameManager.player.discards - this.discardUsed) +
        "/" +
        this.gameManager.player.discards,
      { align: "center" },
      ...suit.layout.row(150, 30)
    );
  }

  handleStartFight(): void {
    this.showingInitialView = false;
    this.gameManager.assetManager.hideAsset(AssetIds.LETS_FIGHT_BUTTON);
    this.gameManager.assetManager.textManager.hideText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION
    );

    this.dealer.startGame();
    this.buildFightAssets();
    this.gameManager.assetManager.textManager.hideText(TextIds.EDEL_SUIT_LABEL);
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
      this.gameManager.switchToWinScreen();
    } else if (winner === CharacterTypes.ENEMY) {
      this.gameManager.switchToLoseScreen();
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
    this.updatePowerEmphasis();
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
    this.updateValueEmphasis();
  }

  addEnemyPower(power: number): void {
    this.enemyPower += power;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_POWER,
      `Power: ${this.enemyPower}`
    );
    this.updatePowerEmphasis();
  }

  addEnemyValue(value: number): void {
    this.enemyValue += value;
    this.gameManager.assetManager.textManager.updateText(
      TextIds.ENEMY_VALUE,
      `Value: ${this.enemyValue}`
    );
    this.updateValueEmphasis();
  }

  buildAssets(): void {
    this.buildBackground();
    this.buildCardAssets();
    this.buildPlayerPortrait();
    this.buildEnemyPortrait();
    this.buildPlayerDeck();
    this.buildEnemyDeck();
    if (this.showingInitialView) {
      this.buildLetsFightButton();
      this.buildEdelSuitText();
    } else {
      this.buildFightAssets();
      this.updatePowerEmphasis();
      this.updateValueEmphasis();
    }
  }

  private buildCardAssets(): void {
    const playerCardPosition = this.cardAssets.determineCardStartingPosition(
      CharacterTypes.PLAYER
    );

    for (let i = 0; i < this.gameManager.player.hand.length; i++) {
      const card = this.gameManager.player.hand[i];
      const x = playerCardPosition.x + i * (this.cardAssets.baseW + padding);
      this.cardAssets.addAsset(card, x, playerCardPosition.y);
    }

    const enemyCardPosition = this.cardAssets.determineCardStartingPosition(
      CharacterTypes.ENEMY
    );
    for (let i = 0; i < this.enemy.hand.length; i++) {
      const card = this.enemy.hand[i];
      const x = enemyCardPosition.x + i * (this.cardAssets.baseW + padding);
      this.cardAssets.addAsset(card, x, enemyCardPosition.y);
    }
  }

  private buildLetsFightButton(): void {
    const cardY = this.cardAssets.getCardPosition(CharacterTypes.PLAYER);
    const buttonHeight = this.letsFightButton.getHeight();
    const buttonWidth = this.letsFightButton.getWidth();
    const screenW = push.getWidth();
    const buttonX = Math.floor((screenW - buttonWidth) / 2);
    const buttonY = cardY - buttonHeight - padding;
    this.gameManager.assetManager.addAsset(
      AssetIds.LETS_FIGHT_BUTTON,
      new Asset(
        AssetIds.LETS_FIGHT_BUTTON,
        this.letsFightButton,
        buttonX,
        buttonY,
        { onClick: () => this.handleStartFight() }
      )
    );

    const centerX = buttonX + buttonWidth / 2;
    const centerY = buttonY + buttonHeight / 2;
    this.gameManager.assetManager.textManager.addText(
      TextIds.LETS_FIGHT_BUTTON_CAPTION,
      new FontWithPosition(TextIds.LETS_FIGHT_BUTTON_CAPTION, centerX, centerY, "Let's Fight!", {
        size: 28,
        format: Format.CENTER,
      })
    );
  }

  private buildPrimaryButtons(): void {
    const gap = 20;
    const btnW = this.attackButton.getWidth();
    const totalW = btnW * 3 + gap * 2;
    const buttonY =
      this.cardAssets.getCardPosition(CharacterTypes.PLAYER) +
      this.cardAssets.baseH +
      padding;
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
    this.gameManager.assetManager.textManager.addText(
      TextIds.ATTACK_BUTTON_CAPTION,
      new FontWithPosition(TextIds.ATTACK_BUTTON_CAPTION, centerX, centerY, "Attack", {
        size: 28,
        format: Format.CENTER,
      })
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.ATTACK_BUTTON,
      new Asset(AssetIds.ATTACK_BUTTON, this.attackButton, buttonX, buttonY, {
        onClick: () => this.handleAttack(),
        clickSound: love.audio.newSource("Assets/Sounds/AttackClicked.flac", "static"),
        associatedTexts: [TextIds.ATTACK_BUTTON_CAPTION],
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
    this.gameManager.assetManager.textManager.addText(
      TextIds.DISCARD_BUTTON_CAPTION,
      new FontWithPosition(TextIds.DISCARD_BUTTON_CAPTION, centerX, centerY - 8, "Discard", {
        size: 28,
        format: Format.CENTER,
      })
    );

    const remaining = this.gameManager.player.discards - this.discardUsed;
    this.gameManager.assetManager.textManager.addText(
      TextIds.DISCARD_BUTTON_COUNTER,
      new FontWithPosition(TextIds.DISCARD_BUTTON_COUNTER, centerX, centerY + 12, `${remaining}/${this.gameManager.player.discards}`, {
        size: 18,
        format: Format.CENTER,
      })
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.DISCARD_BUTTON,
      new Asset(
        AssetIds.DISCARD_BUTTON,
        this.discardButton,
        discardX,
        buttonY,
        { onClick: () => this.handleDiscard(), associatedTexts: [TextIds.DISCARD_BUTTON_CAPTION, TextIds.DISCARD_BUTTON_COUNTER],}
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
    this.gameManager.assetManager.textManager.addText(
      TextIds.DESELECT_BUTTON_CAPTION,
      new FontWithPosition(TextIds.DESELECT_BUTTON_CAPTION, centerX, centerY, "Deselect", {
        size: 28,
        format: Format.CENTER,
      })
    );

        this.gameManager.assetManager.addAsset(
      AssetIds.DESELECT_BUTTON,
      new Asset(
        AssetIds.DESELECT_BUTTON,
        this.deselectButton,
        deselectX,
        buttonY,
        { onClick: () => this.gameManager.player.unselectCards(), associatedTexts: [TextIds.DESELECT_BUTTON_CAPTION], }
      )
    );
  }

  updatePrimaryButtonStates(): void {
    const hasSelectedCards = this.gameManager.player.anySelectedCards();
    
    if (hasSelectedCards) {
      this.gameManager.assetManager.enableAsset(AssetIds.ATTACK_BUTTON);
      this.gameManager.assetManager.textManager.enableText(TextIds.ATTACK_BUTTON_CAPTION);
      
      this.gameManager.assetManager.enableAsset(AssetIds.DISCARD_BUTTON);
      this.gameManager.assetManager.textManager.enableText(TextIds.DISCARD_BUTTON_CAPTION);
      this.gameManager.assetManager.textManager.enableText(TextIds.DISCARD_BUTTON_COUNTER);
      
      this.gameManager.assetManager.enableAsset(AssetIds.DESELECT_BUTTON);
      this.gameManager.assetManager.textManager.enableText(TextIds.DESELECT_BUTTON_CAPTION);
    } else {
      this.gameManager.assetManager.disableAsset(AssetIds.ATTACK_BUTTON);
      this.gameManager.assetManager.textManager.disableText(TextIds.ATTACK_BUTTON_CAPTION);
      
      this.gameManager.assetManager.disableAsset(AssetIds.DISCARD_BUTTON);
      this.gameManager.assetManager.textManager.disableText(TextIds.DISCARD_BUTTON_CAPTION);
      this.gameManager.assetManager.textManager.disableText(TextIds.DISCARD_BUTTON_COUNTER);
      
      this.gameManager.assetManager.disableAsset(AssetIds.DESELECT_BUTTON);
      this.gameManager.assetManager.textManager.disableText(TextIds.DESELECT_BUTTON_CAPTION);
    }
  }

  private buildPointBoard(): void {
    const boardWidth = this.pointBoard.getWidth();
    const screenW = push.getWidth();
    const buttonX = Math.floor((screenW - boardWidth) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.POINT_DISPLAY,
      new Asset(AssetIds.POINT_DISPLAY, this.pointBoard, buttonX, 10)
    );

    const centerX = screenW / 2;
    const textY = 30;

    const playerText = `${this.gameManager.player.name}: ${this.playerPoints}`;
    const enemyText = `${this.enemy.name}: ${this.enemyPoints}`;

    // Left label (player)
    this.gameManager.assetManager.textManager.addText(
      TextIds.POINTS_PLAYER,
      new FontWithPosition(TextIds.POINTS_PLAYER, centerX - boardWidth / 2 + 10, textY, playerText, {
        size: 20,
      })
    );

    // Right label (enemy)
    this.gameManager.assetManager.textManager.addText(
      TextIds.POINTS_ENEMY,
      new FontWithPosition(TextIds.POINTS_ENEMY, centerX + boardWidth / 2 - 10, textY, enemyText, {
        size: 20,
        format: Format.RIGHT,
      })
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
    const isLeading = this.playerPower > this.enemyPower;
    const isTrailing = this.enemyPower > this.playerPower;
    const emphasize =
      (characterType === CharacterTypes.PLAYER && isLeading) ||
      (characterType === CharacterTypes.ENEMY && isTrailing);
    this.gameManager.assetManager.textManager.addText(
      powerId,
      new FontWithPosition(
        powerId,
        30,
        portraitHeight + portraitAsset.y + 60,
        `Power: ${powerValue}`,
        { size: emphasize ? 18 : 15, icon: this.attackPowerIcon }
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
    const valueLeading = this.playerValue > this.enemyValue;
    const valueTrailing = this.enemyValue > this.playerValue;
    const emphasizeValue =
      (characterType === CharacterTypes.PLAYER && valueLeading) ||
      (characterType === CharacterTypes.ENEMY && valueTrailing);
    this.gameManager.assetManager.textManager.addText(
      valueId,
      new FontWithPosition(
        valueId,
        30,
        portraitHeight + portraitAsset.y + 80,
        `Value: ${valueValue}`,
        { size: emphasizeValue ? 18 : 15, icon: this.valueIcon }
      )
    );
  }

  private updatePowerEmphasis(): void {
    const playerText = this.gameManager.assetManager.textManager.getText(
      TextIds.PLAYER_POWER
    );
    const enemyText = this.gameManager.assetManager.textManager.getText(
      TextIds.ENEMY_POWER
    );
    if (isEmpty(playerText) || isEmpty(enemyText)) {
      return;
    }

    const playerLeading = this.playerPower > this.enemyPower;
    const enemyLeading = this.enemyPower > this.playerPower;

    playerText.size = playerLeading ? 18 : 15;
    enemyText.size = enemyLeading ? 18 : 15;
  }

  private updateValueEmphasis(): void {
    const playerText = this.gameManager.assetManager.textManager.getText(
      TextIds.PLAYER_VALUE
    );
    const enemyText = this.gameManager.assetManager.textManager.getText(
      TextIds.ENEMY_VALUE
    );
    if (isEmpty(playerText) || isEmpty(enemyText)) {
      return;
    }

    const playerLeading = this.playerValue > this.enemyValue;
    const enemyLeading = this.enemyValue > this.playerValue;

    playerText.size = playerLeading ? 18 : 15;
    enemyText.size = enemyLeading ? 18 : 15;
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

    const portraitWidth = this.portrait.getWidth();
    const portraitHeight = this.portrait.getHeight();
    const portraitBackgroundWidth = this.portraitBackground.getWidth();

    const portraitNameId =
      characterType === CharacterTypes.PLAYER
        ? TextIds.PLAYER_PORTRAIT_NAME
        : TextIds.ENEMY_PORTRAIT_NAME;
    this.gameManager.assetManager.textManager.addText(
      portraitNameId,
      new FontWithPosition(
        portraitNameId,
        10,
        portraitHeight + portraitPosition + 15,
        characterType === CharacterTypes.PLAYER
          ? this.gameManager.player.name
          : this.enemy.name,
        { size: 24 }
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
        portraitHeight + portraitPosition + 40,
        `Lvl ${
          characterType === CharacterTypes.PLAYER
            ? this.gameManager.player.level
            : this.enemy.level
        }`,
        { size: 15 }
      )
    );

    if (characterType === CharacterTypes.PLAYER) {
      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PORTRAIT_EXPERIENCE,
        new FontWithPosition(
          TextIds.PLAYER_PORTRAIT_EXPERIENCE,
          portraitBackgroundWidth,
          portraitHeight + portraitPosition + 40,
          `${this.gameManager.player.experience} XP`,
          { size: 15, format: Format.RIGHT }
        )
      );

      this.gameManager.assetManager.addAsset(
        AssetIds.PERKS_BUTTON,
        new Asset(
          AssetIds.PERKS_BUTTON,
          this.perksButton,
          portraitWidth + 15,
          portraitPosition + 10,
          { onClick: () => this.gameManager.switchToPerkScreen() }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PERKS,
        new FontWithPosition(
          TextIds.PLAYER_PERKS,
          portraitWidth + this.perksButton.getWidth() / 2,
          portraitPosition + 10 + this.perksButton.getHeight() / 2,
          "Perks",
          { size: 15 }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        TextIds.PLAYER_PORTRAIT_MONEY,
        new FontWithPosition(
          TextIds.PLAYER_PORTRAIT_MONEY,
          portraitBackgroundWidth,
          portraitHeight + portraitPosition + 15,
          `${this.gameManager.player.money}`,
          { size: 15, icon: this.markIcon, format: Format.RIGHT }
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

  private buildEdelSuitText(): void {
    const screenW = push.getWidth();
    const centerX = screenW / 2;
    this.gameManager.assetManager.textManager.addText(
      TextIds.EDEL_SUIT_LABEL,
      new FontWithPosition(
        TextIds.EDEL_SUIT_LABEL,
        centerX,
        40,
        "Edel! \n" + Card.getSuitName(this.edelSuit),
        { size: 24, format: Format.CENTER }
      )
    );
  }

  private buildBackground(): void {
    this.gameManager.assetManager.addAsset(
      AssetIds.GRASS_BACKGROUND,
      new Asset(
        AssetIds.GRASS_BACKGROUND,
        love.graphics.newImage(this.biome.boardBackgroundImagePath),
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
        centerY + 20,
        "You are\ndominating!",
        { size: 32, format: Format.CENTER }
      )
    );

    const winnings = this.getPlayerWinnings();
    if (winnings <= 0) {
      this.gameManager.assetManager.textManager.addText(
        TextIds.WINNINGS,
        new FontWithPosition(
          TextIds.WINNINGS,
          portraitCenterX * 2,
          centerY + 100,
          "But you'll get no winnings...",
          { size: 20, format: Format.CENTER }
        )
      );
    } else {
      this.gameManager.assetManager.textManager.addText(
        TextIds.WINNINGS,
        new FontWithPosition(
          TextIds.WINNINGS,
          portraitCenterX * 2,
          centerY + 100,
          "Winnings: " + winnings,
          { size: 20, format: Format.CENTER }
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
