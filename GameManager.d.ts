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
    constructor();
    getCharacter(characterType: string): Character | undefined;
    switchBasedOnGameState(): void;
    switchToMainMenu(): void;
    switchToNewGameMenu(): void;
    switchToPauseMenu(): void;
    switchToBoard(): void;
    switchToWinScreen(): void;
    switchToLoseScreen(): void;
}
