/** @noSelfInFile */
import { GameStates } from "./Enums";
import MainMenu from "MainMenu";
import NewGameMenu from "NewGameMenu";
import PauseMenu from "PauseMenu";
import Board from "Board";
import WinScreen from "WinScreen";
import LoseScreen from "LoseScreen";
import Settings from "Settings";
import Character from "Character";
import Player from "Player";
import Map from "Map";
import Enemy from "Enemy";
import Shop from "Shop";
export default class GameManager {
    gameState: GameStates;
    player: Player;
    settings: Settings;
    mainMenu?: MainMenu;
    newGameMenu?: NewGameMenu;
    pauseMenu?: PauseMenu;
    board?: Board;
    winScreen?: WinScreen;
    loseScreen?: LoseScreen;
    map: Map;
    shop?: Shop;
    constructor();
    getCharacter(characterType: string): Character | undefined;
    switchBasedOnGameState(): void;
    switchToMainMenu(): void;
    switchToNewGameMenu(): void;
    switchToPauseMenu(): void;
    switchToBoard(enemy?: Enemy): void;
    switchToWinScreen(): void;
    switchToLoseScreen(): void;
    switchToMap(): void;
    switchToShop(): void;
}
