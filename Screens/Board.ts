/** @noSelfInFile */

import { AssetIds, CharacterTypes, FontIds, Suits } from "../Enums";
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
  discardUsed = 0
  enemy: Enemy;
  dealer: Dealer;
  playerPoints = 0
  enemyPoints = 0
  edelSuit = Suits.ACORNS;
  playerPower = 0
  playerValue = 0
  enemyPower = 0
  enemyValue = 0
  showingInitialView = true
  cardAssets: CardAssets;
  letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png");
  attackButton = love.graphics.newImage("Assets/Images/AttackButton.png");
  discardButton = love.graphics.newImage("Assets/Images/DiscardButton.png");
  deselectButton = love.graphics.newImage("Assets/Images/DeselectButton.png");
  pointBoard = love.graphics.newImage("Assets/Images/PointBoard.png");
  portraitBackground = love.graphics.newImage("Assets/Images/PortraitBackground.png");
  portrait = love.graphics.newImage("Assets/Images/Portrait.png")
  baseDeck = love.graphics.newImage("Assets/Images/BaseCardBack.png");
  perksButton = love.graphics.newImage("Assets/Images/PerksButton.png");
  mark = love.graphics.newImage("Assets/Images/Mark.png")
  biome: Biome;

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

  getPlayerCashout(): number {
    let cashout = this.playerValue - this.enemyValue;
    if (cashout < 0) cashout = 0;
    return cashout;
  }

  getEnemyCashout(): number {
    let cashout = this.enemyValue - this.playerValue;
    if (cashout < 0) cashout = 0;
    return cashout;
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
        "Your cashout: " + this.getPlayerCashout(),
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

    this.dealer.startGame();
    this.buildPrimaryButtons();
    this.buildPointBoard();
    this.gameManager.assetManager.textManager.hideText(FontIds.EDEL_SUIT_LABEL);
  }

  handleAttack(): void {
    if (!this.gameManager.player.anySelectedCards()) return;
    if (this.enemy.deck.length === 0) {
      this.endFight();
      return;
    }

    if (this.playerPower > this.enemyPower) {
      this.addPlayerPoints(this.getPlayerCashout());
    } else {
      this.addEnemyPoints(this.getEnemyCashout());
    }

    this.clearStats();

    this.gameManager.player.removeSelectedCardsFromHand();
    this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER);

    this.enemy.removeAllCardsFromHand();
    this.gameManager.board?.dealer.dealCards(CharacterTypes.ENEMY);
  }

  private addPlayerPoints(points: number): void {
    this.playerPoints += points;
    const text = this.gameManager.assetManager.textManager.getText(FontIds.POINTS_PLAYER);
    if (!isEmpty(text)) {
      text.text = `${this.gameManager.player.name}: ${this.playerPoints}`;
    }
  }

  private addEnemyPoints(points: number): void {
    this.enemyPoints += points;
    const text = this.gameManager.assetManager.textManager.getText(FontIds.POINTS_ENEMY);
    if (!isEmpty(text)) {
      text.text = `${this.enemy.name}: ${this.enemyPoints}`;
    }
  }

  handleDiscard(): void {
    if (!this.gameManager.player.anySelectedCards()) return;

    this.gameManager.player.discard();

    this.discardUsed = this.discardUsed + 1;

    // Refill the player's hand after discarding
    this.gameManager.board?.dealer.dealCards(CharacterTypes.PLAYER);
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
    this.playerPower = 0;
    this.playerValue = 0;
    this.enemyPower = 0;
    this.enemyValue = 0;
  }

  buildAssets(): void {
    this.buildBackground();
    this.buildCardAssets();
    this.buildLetsFightButton();
    this.buildPlayerPortrait();
    this.buildEnemyPortrait();
    this.buildPlayerDeck();
    this.buildEnemyDeck();
    this.buildEdelSuitText();
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
      new Asset(AssetIds.LETS_FIGHT_BUTTON, this.letsFightButton, buttonX, buttonY, () =>
        this.handleStartFight()
      )
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
  }

  private buildAttackButton(
    buttonX: number,
    buttonY: number,
    btnW: number
  ): void {
    this.gameManager.assetManager.addAsset(
      AssetIds.ATTACK_BUTTON,
      new Asset(
        AssetIds.ATTACK_BUTTON,
        this.attackButton,
        buttonX,
        buttonY,
        () => this.handleAttack()
      )
    );

    const centerX = buttonX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
    this.gameManager.assetManager.textManager.addText(
      FontIds.ATTACK_BUTTON_CAPTION,
      new FontWithPosition(centerX, centerY, "Attack", { size: 28, format: Format.CENTER })
    );
  }

  private buildDiscardButton(
    buttonX: number,
    buttonY: number,
    btnW: number,
    gap: number
  ): number {
    const discardX = buttonX + btnW + gap;
    this.gameManager.assetManager.addAsset(
      AssetIds.DISCARD_BUTTON,
      new Asset(
        AssetIds.DISCARD_BUTTON,
        this.discardButton,
        discardX,
        buttonY,
        () => this.handleDiscard()
      )
    );

    const centerX = discardX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
    this.gameManager.assetManager.textManager.addText(
      FontIds.DISCARD_BUTTON_CAPTION,
      new FontWithPosition(centerX, centerY, "Discard", { size: 28, format: Format.CENTER })
    );

    return discardX
  }

  private buildDeselectButton(
    discardX: number,
    buttonY: number,
    btnW: number,
    gap: number
  ): void {
    const deselectX = discardX + btnW + gap;
    this.gameManager.assetManager.addAsset(
      AssetIds.DESELECT_BUTTON,
      new Asset(
        AssetIds.DESELECT_BUTTON,
        this.deselectButton,
        deselectX,
        buttonY,
        () => this.gameManager.player.unselectCards()
      )
    );

    const centerX = deselectX + btnW / 2;
    const centerY = buttonY + this.attackButton.getHeight() / 2;
    this.gameManager.assetManager.textManager.addText(
      FontIds.DESELECT_BUTTON_CAPTION,
      new FontWithPosition(centerX, centerY, "Deselect", { size: 28, format: Format.CENTER })
    );
  }

  private buildPointBoard(): void {
    const boardWidth = this.pointBoard.getWidth();
    const screenW = push.getWidth();
    const buttonX = Math.floor((screenW - boardWidth) / 2);
    this.gameManager.assetManager.addAsset(
      AssetIds.POINT_DISPLAY,
      new Asset(
        AssetIds.POINT_DISPLAY,
        this.pointBoard,
        buttonX,
        10,
      )
    );

    const centerX = screenW / 2;
    const textY = 30;

    const playerText = `${this.gameManager.player.name}: ${this.playerPoints}`;
    const enemyText = `${this.enemy.name}: ${this.enemyPoints}`;

    // Left label (player)
    this.gameManager.assetManager.textManager.addText(
      FontIds.POINTS_PLAYER,
      new FontWithPosition(centerX - (boardWidth / 2) + 10, textY, playerText, { size: 20 })
    );

    // Right label (enemy)
    this.gameManager.assetManager.textManager.addText(
      FontIds.POINTS_ENEMY,
      new FontWithPosition(centerX + (boardWidth / 2) - 10, textY, enemyText, { size: 20, format: Format.RIGHT })
    );
  }

  private buildPlayerPortrait(): void {
    this.buildPortrait(CharacterTypes.PLAYER);
  }

  private buildEnemyPortrait(): void {
    this.buildPortrait(CharacterTypes.ENEMY);
  }

  private buildPortrait(characterType: CharacterTypes): void {
    const playerCardY = characterType === CharacterTypes.PLAYER
      ? this.cardAssets.getCardPosition(characterType)
      : 5;

    const portraitBackgroundAssetId = characterType === CharacterTypes.PLAYER
      ? AssetIds.PLAYER_PORTRAIT_BACKGROUND
      : AssetIds.ENEMY_PORTRAIT_BACKGROUND;
    this.gameManager.assetManager.addAsset(
      portraitBackgroundAssetId,
      new Asset(
        portraitBackgroundAssetId,
        this.portraitBackground,
        5,
        playerCardY,
      )
    );

    const portraitAssetId = characterType === CharacterTypes.PLAYER
      ? AssetIds.PLAYER_PORTRAIT
      : AssetIds.ENEMY_PORTRAIT;
    this.gameManager.assetManager.addAsset(
      portraitAssetId,
      new Asset(
        portraitAssetId,
        this.portrait,
        5,
        playerCardY,
      )
    );

    const portraitWidth = this.portrait.getWidth();
    const portraitHeight = this.portrait.getHeight();
    const portraitBackgroundWidth = this.portraitBackground.getWidth();

    const portraitNameId = characterType === CharacterTypes.PLAYER
      ? FontIds.PLAYER_PORTRAIT_NAME
      : FontIds.ENEMY_PORTRAIT_NAME;
    this.gameManager.assetManager.textManager.addText(
      portraitNameId,
      new FontWithPosition(
        10,
        portraitHeight + playerCardY + 15,
        characterType === CharacterTypes.PLAYER ? this.gameManager.player.name : this.enemy.name,
        { size: 24 }
      )
    );

    const portraitLevelId = characterType === CharacterTypes.PLAYER
      ? FontIds.PLAYER_PORTRAIT_LEVEL
      : FontIds.ENEMY_PORTRAIT_LEVEL;
    this.gameManager.assetManager.textManager.addText(
      portraitLevelId,
      new FontWithPosition(
        10,
        portraitHeight + playerCardY + 40,
        `Lvl ${characterType === CharacterTypes.PLAYER ? this.gameManager.player.level : this.enemy.level}`,
        { size: 15 }
      )
    );

    if (characterType === CharacterTypes.PLAYER) {
      this.gameManager.assetManager.textManager.addText(
        FontIds.PLAYER_PORTRAIT_EXPERIENCE,
        new FontWithPosition(
          portraitBackgroundWidth,
          portraitHeight + playerCardY + 40,
          `${this.gameManager.player.experience} XP`,
          { size: 15, format: Format.RIGHT }
        )
      );

      this.gameManager.assetManager.textManager.addText(
        FontIds.PLAYER_PORTRAIT_MONEY,
        new FontWithPosition(
          30,
          portraitHeight + playerCardY + 60,
          `${this.gameManager.player.money} Mark`,
          { size: 15, icon: this.mark }
        )
      );

      this.gameManager.assetManager.addAsset(
        AssetIds.PERKS_BUTTON,
        new Asset(
          AssetIds.PERKS_BUTTON,
          this.perksButton,
          portraitWidth + 15,
          playerCardY + 10,
          () => this.gameManager.switchToPerkScreen()
        )
      );

      this.gameManager.assetManager.textManager.addText(
        FontIds.PLAYER_PERKS,
        new FontWithPosition(
          portraitWidth  + (this.perksButton.getWidth() / 2),
          playerCardY + 10  + (this.perksButton.getHeight() / 2),
          "Perks",
          { size: 15 }
        )
      );
    }
  }

  private buildPlayerDeck(): void {  
    const playerCardY = this.cardAssets.getCardPosition(CharacterTypes.PLAYER);  
    this.gameManager.assetManager.addAsset(
      AssetIds.PLAYER_DECK,
      new Asset(
        AssetIds.PLAYER_DECK,
        this.baseDeck,
        push.getWidth() - this.baseDeck.getWidth() - 5,
        playerCardY,
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
        5,
      )
    );
  }

  private buildEdelSuitText(): void {
    const screenW = push.getWidth();
    const centerX = screenW / 2;
    this.gameManager.assetManager.textManager.addText(
      FontIds.EDEL_SUIT_LABEL,
      new FontWithPosition(
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
        0,
      )
    );
  }
}
