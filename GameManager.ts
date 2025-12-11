/** @noSelfInFile */

import { GameStates, CharacterTypes } from "./Enums"
import MainMenu from "MainMenu"
import NewGameMenu from "NewGameMenu"
import PauseMenu from "PauseMenu"
import Board from "Board"
import WinScreen from "WinScreen"
import LoseScreen from "LoseScreen"
import Settings from "Settings"
import Character from "Character"
import { exhaustiveGuard, isEmpty } from "Helpers"
import * as GameStateManager from "Libraries.GameStateManager-main.gamestateManager"
import Player from "Player"
import Map from "Map"
import Enemy from "Enemy"
import * as suit from "Libraries.suit-master.suit"
import Draw from "Draw"

interface GameState {
    update: (dt: number) => void
    draw?: () => void
}

export default class GameManager {
    gameState: GameStates
    player: Player
    settings: Settings
    mainMenu?: MainMenu
    newGameMenu?: NewGameMenu
    pauseMenu?: PauseMenu
    board?: Board
    winScreen?: WinScreen
    loseScreen?: LoseScreen
    map: Map

    constructor() {
        this.gameState = GameStates.MAIN_MENU
        this.player = new Player()
        this.settings = new Settings()
        this.mainMenu = undefined
        this.newGameMenu = undefined
        this.pauseMenu = undefined
        this.board = undefined
        this.winScreen = undefined
        this.loseScreen = undefined
        this.map = new Map(this)
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
            case GameStates.NEW_GAME_MENU:
                this.switchToNewGameMenu()
                break
            case GameStates.PLAYING:
                this.switchToBoard(this.board?.enemy)
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
            case GameStates.MAP:
                this.switchToMap()
                break
            default:
                exhaustiveGuard(this.gameState)
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

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

        if (isEmpty(this.mainMenu)) {
            this.mainMenu = new MainMenu(this)
        }

        GameStateManager.setState(mainMenuState)
    }

    switchToNewGameMenu(): void {
        const newGameMenuState: GameState = {
            update: (dt: number) => {
                this.newGameMenu?.drawScreen()
            }
        }

        this.gameState = GameStates.NEW_GAME_MENU

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

        if (isEmpty(this.newGameMenu)) {
            this.newGameMenu = new NewGameMenu(this)
        }

        GameStateManager.setState(newGameMenuState)
    }

    switchToPauseMenu(): void {
        const pauseMenuState: GameState = {
            update: (dt: number) => {
                this.pauseMenu?.drawScreen()
            }
        }

        // Game state needs to be the previous state in the pause menu so we save correctly
        // this.gameState = GameStates.PAUSE_MENU

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

        if (isEmpty(this.pauseMenu)) {
            this.pauseMenu = new PauseMenu(this)
        }

        GameStateManager.setState(pauseMenuState)
    }

    switchToBoard(enemy?: Enemy): void {
        const boardState: GameState = {
            update: (dt: number) => {
                this.board?.drawBoard()
            }
        }

        this.gameState = GameStates.PLAYING
        this.winScreen = undefined
        this.loseScreen = undefined

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

        if (isEmpty(this.board)) {
            this.board = new Board(this, enemy ?? new Enemy())
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

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

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

        // Reset to white text for dark backgrounds
        suit.theme.color.normal.fg = [1, 1, 1]

        if (isEmpty(this.loseScreen)) {
            this.loseScreen = new LoseScreen()
        }

        GameStateManager.setState(loseState)
    }

    switchToMap(): void {
        const mapState: GameState = {
            update: (dt: number) => {
                this.map.drawMap()
            },
            draw: () => {
                this.map.drawBackground()
            }
        }

        this.gameState = GameStates.MAP

        this.board = undefined
        this.winScreen = undefined
        this.loseScreen = undefined

        // Set dark text color for labels to be readable on light backgrounds
        Draw.setThemeColors(0, 0, 0)

        GameStateManager.setState(mapState)
    }
}
