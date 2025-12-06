require "Player"
require "Enemy"
require "Board"
require "Enums"
require "WinScreen"
require "LoseScreen"
require "MainMenu"
require "PauseMenu"

local suit = require('Libraries.suit-master')
GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local object = require('Libraries.classic-master.classic')
GameManager = object:extend()

function GameManager:new()
    self.gameState = GameStates.MAIN_MENU
    self.mainMenu = {}
    self.pauseMenu = {}
    self.board = {}
    self.winScreen = {}
    self.loseScreen = {}
end

function GameManager:getCharacter(characterType)
    if characterType == CharacterTypes.PLAYER then
        return Player
    elseif characterType == CharacterTypes.ENEMY then
        return self.board.enemy
    end
end

function GameManager:switchBasedOnGameState()
    if self.gameState == GameStates.MAIN_MENU then
        self:switchToMainMenu()
    elseif self.gameState == GameStates.PLAYING then
        self:switchToBoard()
    elseif self.gameState == GameStates.PAUSE_MENU then
        self:switchToPauseMenu()
    elseif self.gameState == GameStates.WIN_SCREEN then
        self:switchToWinScreen()
    elseif self.gameState == GameStates.LOSE_SCREEN then
        self:switchToLoseScreen()
    end
end

function GameManager:switchToMainMenu()
    local mainMenuState = {
        update = function(dt)
            self.mainMenu:drawScreen()
        end,    
    }

    self.gameState = GameStates.MAIN_MENU
    self.board = {}
    self.winScreen = {}
    self.loseScreen = {}

    if isEmpty(self.mainMenu) then
         self.mainMenu = MainMenu()
    end

    GameStateManager:setState(mainMenuState)
end

function GameManager:switchToPauseMenu()
    local pauseMenuState = {
        update = function(dt)
            self.pauseMenu:drawScreen()
        end,
    }

    -- Game state needs to be the previous state in the pause menu so we save correctly
    --self.gameState = GameStates.PAUSE_MENU
    if isEmpty(self.pauseMenu) then
        self.pauseMenu = PauseMenu()
    end

    GameStateManager:setState(pauseMenuState)
end

function GameManager:switchToBoard()
    local boardState = {
        update = function(dt)
            self.board:drawBoard()
        end,
    }

    self.gameState = GameStates.PLAYING
    self.winScreen = {}
    self.loseScreen = {}

    if isEmpty(self.board) then
        self.board = Board()
        self.board.dealer:setup()
    end

    GameStateManager:setState(boardState)
end

function GameManager:switchToWinScreen()
    local winState = {
        update = function(dt)
            self.winScreen:drawScreen()
        end,
    }

    self.gameState = GameStates.WIN_SCREEN
    -- We need some data from the board to show stats and loot cards, so we keep it
    --self.board = {}
    self.loseScreen = {}

    if isEmpty(self.winScreen) then
        self.winScreen = WinScreen()
    end

    self.board.dealer:getLootCards()

    GameStateManager:setState(winState)
end

function GameManager:switchToLoseScreen()
    local loseState = {
        update = function(dt)
            self.loseScreen:drawScreen()
        end,
    }

    self.gameState = GameStates.LOSE_SCREEN
    self.board = {}
    self.winScreen = {}

    if isEmpty(self.loseScreen) then
        self.loseScreen = LoseScreen()
    end
    GameStateManager:setState(loseState)
end
