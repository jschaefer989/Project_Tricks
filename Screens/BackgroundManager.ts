import Asset from "Assets/Asset";
import { AssetIds, GameStates } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard, isEmpty } from "Helpers";
import * as push from "Libraries.push";
import { Image } from "love.graphics";

export default class BackgroundManager {
  gameManager: GameManager;

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  updateBackground(gameState: GameStates): void {
    const backgroundImage = this.getBackgroundImage(gameState);
    if (isEmpty(backgroundImage)) {
      return;
    }

    this.gameManager.assetManager.addAsset(
      AssetIds.BACKGROUND,
      new Asset(
        this.gameManager,
        AssetIds.BACKGROUND,
        backgroundImage,
        0,
        0,
        push.getWidth(),
        push.getHeight()
      )
    );
  }

  getBackgroundImage(gameState: GameStates): Image | undefined {
    switch (gameState) {
      case GameStates.MAIN_MENU:
        return;
      //return this.gameManager.assetManager.getImage("background_main_menu");
      case GameStates.BOARD:
        return love.graphics.newImage(
          this.gameManager.biome.boardBackgroundImagePath
        );
      case GameStates.WIN_SCREEN:
        return;
      //return this.gameManager.assetManager.getImage("background_win_screen");
      case GameStates.LOSE_SCREEN:
        return;
      //return this.gameManager.assetManager.getImage("background_lose_screen");
      case GameStates.MAP:
        return;
      //return this.gameManager.assetManager.getImage("background_map");
      case GameStates.SHOP:
        return;
      //return this.gameManager.assetManager.getImage("background_shop");
      case GameStates.LEVEL_UP:
        return;
      //return this.gameManager.assetManager.getImage("background_level_up");
      case GameStates.PERKS:
        return;
      //return this.gameManager.assetManager.getImage("background_perks");
      case GameStates.NEW_GAME_MENU:
        return;
      //return this.gameManager.assetManager.getImage("background_new_game_menu");
      default:
        exhaustiveGuard(gameState);
    }
  }
}
