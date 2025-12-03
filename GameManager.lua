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
    self.settings = {}
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

function GameManager:switchToMainMenu()
    local mainMenuState = {
        update = function(dt)
            self.mainMenu:drawScreen()
        end,    
        draw = function()
            --push.start(push)
            suit.draw()
            --push.finish(push)
        end,
    }

    self.gameState = GameStates.MAIN_MENU
    self.settings = Settings()
    self.settings:load()
    self.mainMenu = MainMenu()
    GameStateManager:setState(mainMenuState)
end

function GameManager:switchToPauseMenu()
    local pauseMenuState = {
        update = function(dt)
            self.pauseMenu:drawScreen()
        end,    
        draw = function()
            --push.start(push)
            suit.draw()
            --push.finish(push)
        end,
    }

    self.gameState = GameStates.PAUSE_MENU
    self.pauseMenu = PauseMenu()
    GameStateManager:setState(pauseMenuState)
end

function GameManager:switchToBoard()
    local boardState = {
        update = function(dt)
            self.board:drawBoard()
        end,    
        draw = function()
            --push.start(push)
            suit.draw()
            --push.finish(push)
        end,
    }

    self.gameState = GameStates.PLAYING
    self.board = Board()
    self.board.dealer:setup()
    GameStateManager:setState(boardState)
end

function GameManager:switchToWinScreen()
    local winState = {
        update = function(dt)
            self.winScreen:drawScreen()
        end,    
        draw = function()
            --push.start(push)
            suit.draw()
            --push.finish(push)
        end,
    }

    self.gameState = GameStates.WIN_SCREEN
    self.winScreen = WinScreen()
    GameStateManager:setState(winState)
end

function GameManager:switchToLoseScreen()
    local loseState = {
        update = function(dt)
            self.loseScreen:drawScreen()
        end,    
        draw = function()
            --push.start(push)
            suit.draw()
            --push.finish(push)
        end,
    }

    self.gameState = GameStates.LOSE_SCREEN
    self.loseScreen = LoseScreen()
    GameStateManager:setState(loseState)
end
