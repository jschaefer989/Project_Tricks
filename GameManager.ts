/** @noSelfInFile */

import { GameStates, CharacterTypes } from "./Enums";
import MainMenu from "Screens/MainMenu";
import NewGameMenu from "Screens/NewGameMenu";
import PauseMenu from "Screens/PauseMenu";
import Board from "Screens/Board";
import WinScreen from "Screens/WinScreen";
import LoseScreen from "Screens/LoseScreen";
import Settings from "Settings";
import Character from "Character";
import { exhaustiveGuard, isEmpty } from "Helpers";
import * as GameStateManager from "Libraries.GameStateManager-main.gamestateManager";
import Player from "Player";
import Map from "Screens/Map/Map";
import Enemy from "Enemies/Enemy";
import Shop from "Screens/Shop";
import LevelUpScreen from "Screens/LevelUpScreen";
import PerkScreen from "Screens/PerkScreen";
import * as push from "Libraries.push";
import AssetManager from "Assets/AssetManager";
import Card from "Cards/Card";
import AnimationManager from "Assets/Animations/AnimationManager";
import MusicPlayer from "Assets/Music/MusicPlayer";
import Biome from "Biomes/Biome";
import Grass from "Biomes/Grass";
import BackgroundManager from "Screens/BackgroundManager";
import ShaderManager from "Shaders/ShaderManager";

interface GameState {
  update: (dt: number) => void;
  draw?: () => void;
  mousepressed?: (x: number, y: number, button: number) => void;
  mousereleased?: (x: number, y: number, button: number) => void;
}

export default class GameManager {
  gameState: GameStates;
  player = new Player(this);
  settings = new Settings();
  mainMenu?: MainMenu;
  newGameMenu?: NewGameMenu;
  pauseMenu?: PauseMenu;
  board?: Board;
  winScreen?: WinScreen;
  loseScreen?: LoseScreen;
  map: Map = new Map(this);
  shop?: Shop;
  levelUpScreen?: LevelUpScreen;
  perkScreen?: PerkScreen;
  assetManager = new AssetManager(this);
  animationManager = new AnimationManager(this);
  musicPlayer = new MusicPlayer(this);
  biome: Biome
  backgroundManager = new BackgroundManager(this);
  shaderManager = new ShaderManager(this);
  devMode: boolean = false; // Change if you want to test in dev mode

  constructor() {
    this.gameState = GameStates.MAIN_MENU;
    this.biome = new Grass(); // TODO: initialize this based on data from the map
  }

  getCharacter(characterType: string): Character | undefined {
    switch (characterType) {
      case CharacterTypes.PLAYER:
        return this.player;
      case CharacterTypes.ENEMY:
        return this.board?.enemy;
    }
  }

  switchBasedOnGameState(gameState = this.gameState, enemy = this.board?.enemy): void {
    this.assetManager = new AssetManager(this);
    this.backgroundManager.updateBackground(gameState);
    if (this.settings.playMusic) {
      this.musicPlayer.play(gameState, this.biome);
    }

    switch (gameState) {
      case GameStates.MAIN_MENU:
        this.switchToMainMenu();
        break;
      case GameStates.NEW_GAME_MENU:
        this.switchToNewGameMenu();
        break;
      case GameStates.BOARD:
        this.switchToBoard(enemy);
        break;
      case GameStates.PAUSE_MENU:
        this.switchToPauseMenu();
        break;
      case GameStates.WIN_SCREEN:
        this.switchToWinScreen();
        break;
      case GameStates.LOSE_SCREEN:
        this.switchToLoseScreen();
        break;
      case GameStates.MAP:
        this.switchToMap();
        break;
      case GameStates.SHOP:
        this.switchToShop();
        break;
      case GameStates.LEVEL_UP:
        this.switchToLevelUpScreen();
        break;
      case GameStates.PERKS:
        this.switchToPerkScreen();
        break;
      default:
        exhaustiveGuard(gameState);
    }
  }

  private switchToMainMenu(): void {
    const mainMenuState: GameState = {
      update: (dt: number) => {
        this.mainMenu?.drawScreen();
      },
    };

    this.gameState = GameStates.MAIN_MENU;
    this.board = undefined;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;

    if (isEmpty(this.mainMenu)) {
      this.mainMenu = new MainMenu(this);
    }

    GameStateManager.setState(mainMenuState);
  }

  private switchToNewGameMenu(): void {
    const newGameMenuState: GameState = {
      update: (dt: number) => {
        this.newGameMenu?.drawScreen();
      },
    };

    this.gameState = GameStates.NEW_GAME_MENU;

    if (isEmpty(this.newGameMenu)) {
      this.newGameMenu = new NewGameMenu(this);
    }

    GameStateManager.setState(newGameMenuState);
  }

  private switchToPauseMenu(): void {
    const pauseMenuState: GameState = {
      update: (dt: number) => {
        this.pauseMenu?.drawScreen();
      },
    };

    // Game state needs to be the previous state in the pause menu so we save correctly
    // this.gameState = GameStates.PAUSE_MENU


    if (isEmpty(this.pauseMenu)) {
      this.pauseMenu = new PauseMenu(this);
    }

    GameStateManager.setState(pauseMenuState);
  }

  private switchToBoard(enemy?: Enemy): void {
    const shadowShader = love.graphics.newShader("Shaders/Shadow.glsl");
    shadowShader.send("shadow_strength", 0.6);
    shadowShader.send("shadow_color", [0, 0, 0]); 

    const boardState: GameState = {
      update: (dt: number) => {        
        this.assetManager.handleMouseHover();        
        this.animationManager.updateAnimations(dt);
        this.shaderManager.updateShaders(dt);
      },
      draw: () => {
        if (!this.devMode) {
          push.start();
          //love.graphics.setShader(shadowShader);
          this.assetManager.drawAssets();
          love.graphics.setShader();  // Reset shader to default
          push.finish();
        }
      },
      mousepressed: (x: number, y: number, button: number) => {
        if (!this.devMode) {
          this.assetManager.handleMousePressed(x, y, button);
        }
      },
      mousereleased: (x: number, y: number, button: number) => {
        if (!this.devMode) {
          this.assetManager.handleMouseReleased(x, y, button);
        }
      },
    };

    this.gameState = GameStates.BOARD;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;
    
    if (isEmpty(this.board)) {
      this.board = new Board(this, enemy ?? new Enemy(this));
      this.board.dealer.setup();
    }

    this.board.start();

    GameStateManager.setState(boardState);
  }

  private switchToWinScreen(): void {
    const winState: GameState = {
      update: (dt: number) => {
        this.winScreen?.drawScreen();
      },
    };

    this.gameState = GameStates.WIN_SCREEN;
    // We need some data from the board to show stats and loot cards, so we keep it
    // this.board = {}
    this.loseScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;

    if (isEmpty(this.winScreen)) {
      this.winScreen = new WinScreen(this);
    }

    GameStateManager.setState(winState);
  }

  private switchToLoseScreen(): void {
    const loseState: GameState = {
      update: (dt: number) => {
        this.loseScreen?.drawScreen();
      },
    };

    this.gameState = GameStates.LOSE_SCREEN;
    this.board = undefined;
    this.winScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;

    if (isEmpty(this.loseScreen)) {
      this.loseScreen = new LoseScreen();
    }

    GameStateManager.setState(loseState);
  }

  private switchToMap(): void {
    const mapState: GameState = {
      update: (dt: number) => {
        this.map.drawMap();
      },
      draw: () => {
        this.map.drawBackground();
      },
    };

    this.gameState = GameStates.MAP;

    this.board = undefined;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;

    GameStateManager.setState(mapState);
  }

  private switchToShop(): void {
    const shopState: GameState = {
      update: (dt: number) => {
        this.shop?.drawShop();
      },
    };

    this.gameState = GameStates.SHOP;

    this.board = undefined;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.levelUpScreen = undefined;
    this.perkScreen = undefined;

    if (isEmpty(this.shop)) {
      this.shop = new Shop(this);
      this.shop.setup();
    }

    GameStateManager.setState(shopState);
  }

  private switchToLevelUpScreen(): void {
    const levelUpState: GameState = {
      update: (dt: number) => {
        this.levelUpScreen?.drawScreen();
      },
    };

    this.gameState = GameStates.LEVEL_UP;

    this.board = undefined;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.shop = undefined;
    this.perkScreen = undefined;

    if (isEmpty(this.levelUpScreen)) {
      this.levelUpScreen = new LevelUpScreen(this);
      this.levelUpScreen.setup();
    }

    GameStateManager.setState(levelUpState);
  }

  private switchToPerkScreen(): void {
    const perkState: GameState = {
      update: (dt: number) => {
        this.perkScreen?.drawScreen();
      },
    };

    this.gameState = GameStates.PERKS;

    this.board = undefined;
    this.winScreen = undefined;
    this.loseScreen = undefined;
    this.shop = undefined;
    this.levelUpScreen = undefined;

    if (isEmpty(this.perkScreen)) {
      this.perkScreen = new PerkScreen(this);
    }

    GameStateManager.setState(perkState);
  }

  // TODO: this is, of course, an extended search that we could optimize if necessary
  getCard(id: string): Card | undefined {
    for (const card of this.player.hand) {
      if (card.id === id) {
        return card;
      }
    }

    for (const card of this.player.deck) {
      if (card.id === id) {
        return card;
      }
    }

    for (const card of this.player.discardPile) {
      if (card.id === id) {
        return card;
      }
    }

    const enemy = this.board?.enemy;
    if (isEmpty(enemy)) {
      return;
    }

    for (const card of enemy.hand) {
      if (card.id === id) {
        return card;
      }
    }

    for (const card of enemy.deck) {
      if (card.id === id) {
        return card;
      }
    }

    for (const card of enemy.discardPile) {
      if (card.id === id) {
        return card;
      }
    }
  }
}
