/** @noSelfInFile */

import { GameStates, CharacterTypes } from "./Enums"
import MainMenu from "MainMenu"
import PauseMenu from "PauseMenu"
import Board from "Board"
import WinScreen from "WinScreen"
import LoseScreen from "LoseScreen"
import Settings from "Settings"
import Character from "Character"
import { isEmpty } from "Helpers"
import * as GameStateManager from "Libraries.GameStateManager-main.gamestateManager"
import Player from "Player"

interface GameState {
    update: (dt: number) => void
}

export default class GameManager {
    gameState: GameStates
    player: Player
    settings: Settings
    mainMenu?: MainMenu
    pauseMenu?: PauseMenu
    board?: Board
    winScreen?: WinScreen
    loseScreen?: LoseScreen

    constructor() {
        this.gameState = GameStates.MAIN_MENU
        this.player = new Player()
        this.settings = new Settings()
        this.mainMenu = undefined
        this.pauseMenu = undefined
        this.board = undefined
        this.winScreen = undefined
        this.loseScreen = undefined
    }

    getCharacter(characterType: string): Character | undefined {
        switch (characterType) {
            case CharacterTypes.PLAYER:
                return this.player
            case CharacterTypes.ENEMY:
                return this.board?.enemy
        }
    }

    switchBasedOnGameState(): void {
        switch (this.gameState) {
            case GameStates.MAIN_MENU:
                this.switchToMainMenu()
                break
            case GameStates.PLAYING:
                this.switchToBoard()
                break
            case GameStates.PAUSE_MENU:
                this.switchToPauseMenu()
                break
            case GameStates.WIN_SCREEN:
                this.switchToWinScreen()
                break
            case GameStates.LOSE_SCREEN:
                this.switchToLoseScreen()
                break
        }
    }

    switchToMainMenu(): void {
        const mainMenuState: GameState = {
            update: (dt: number) => {
                this.mainMenu?.drawScreen()
            }
        }

        this.gameState = GameStates.MAIN_MENU
        this.board = undefined
        this.winScreen = undefined
        this.loseScreen = undefined

        if (isEmpty(this.mainMenu)) {
            this.mainMenu = new MainMenu(this)
        }

        GameStateManager.setState(mainMenuState)
    }

    switchToPauseMenu(): void {
        const pauseMenuState: GameState = {
            update: (dt: number) => {
                this.pauseMenu?.drawScreen()
            }
        }

        // Game state needs to be the previous state in the pause menu so we save correctly
        // this.gameState = GameStates.PAUSE_MENU
        if (isEmpty(this.pauseMenu)) {
            this.pauseMenu = new PauseMenu(this)
        }

        GameStateManager.setState(pauseMenuState)
    }

    switchToBoard(): void {
        const boardState: GameState = {
            update: (dt: number) => {
                this.board?.drawBoard()
            }
        }

        this.gameState = GameStates.PLAYING
        this.winScreen = undefined
        this.loseScreen = undefined

        if (isEmpty(this.board)) {
            this.board = new Board(this)
            this.board.dealer.setup()
        }

        GameStateManager.setState(boardState)
    }

    switchToWinScreen(): void {
        const winState: GameState = {
            update: (dt: number) => {
                this.winScreen?.drawScreen()
            }
        }

        this.gameState = GameStates.WIN_SCREEN
        // We need some data from the board to show stats and loot cards, so we keep it
        // this.board = {}
        this.loseScreen = undefined

        if (isEmpty(this.winScreen)) {
            this.winScreen = new WinScreen(this)
        }

        this.board?.dealer.getLootCards()

        GameStateManager.setState(winState)
    }

    switchToLoseScreen(): void {
        const loseState: GameState = {
            update: (dt: number) => {
                this.loseScreen?.drawScreen()
            }
        }

        this.gameState = GameStates.LOSE_SCREEN
        this.board = undefined
        this.winScreen = undefined

        if (isEmpty(this.loseScreen)) {
            this.loseScreen = new LoseScreen()
        }

        GameStateManager.setState(loseState)
    }
}
