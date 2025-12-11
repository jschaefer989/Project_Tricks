local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local GameStates = ____Enums.GameStates
local CharacterTypes = ____Enums.CharacterTypes
local ____MainMenu = require("MainMenu")
local MainMenu = ____MainMenu.default
local ____NewGameMenu = require("NewGameMenu")
local NewGameMenu = ____NewGameMenu.default
local ____PauseMenu = require("PauseMenu")
local PauseMenu = ____PauseMenu.default
local ____Board = require("Board")
local Board = ____Board.default
local ____WinScreen = require("WinScreen")
local WinScreen = ____WinScreen.default
local ____LoseScreen = require("LoseScreen")
local LoseScreen = ____LoseScreen.default
local ____Settings = require("Settings")
local Settings = ____Settings.default
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local ____Player = require("Player")
local Player = ____Player.default
local ____Map = require("Map")
local Map = ____Map.default
local ____Enemy = require("Enemy")
local Enemy = ____Enemy.default
local suit = require("Libraries.suit-master.suit")
local ____Draw = require("Draw")
local Draw = ____Draw.default
____exports.default = __TS__Class()
local GameManager = ____exports.default
GameManager.name = "GameManager"
function GameManager.prototype.____constructor(self)
    self.gameState = GameStates.MAIN_MENU
    self.player = __TS__New(Player)
    self.settings = __TS__New(Settings)
    self.mainMenu = nil
    self.newGameMenu = nil
    self.pauseMenu = nil
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    self.map = __TS__New(Map, self)
end
function GameManager.prototype.getCharacter(self, characterType)
    repeat
        local ____switch4 = characterType
        local ____cond4 = ____switch4 == CharacterTypes.PLAYER
        if ____cond4 then
            return self.player
        end
        ____cond4 = ____cond4 or ____switch4 == CharacterTypes.ENEMY
        if ____cond4 then
            local ____opt_0 = self.board
            return ____opt_0 and ____opt_0.enemy
        end
    until true
end
function GameManager.prototype.switchBasedOnGameState(self)
    repeat
        local ____switch6 = self.gameState
        local ____cond6 = ____switch6 == GameStates.MAIN_MENU
        if ____cond6 then
            self:switchToMainMenu()
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.NEW_GAME_MENU
        if ____cond6 then
            self:switchToNewGameMenu()
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.PLAYING
        if ____cond6 then
            local ____self_switchToBoard_4 = self.switchToBoard
            local ____opt_2 = self.board
            ____self_switchToBoard_4(self, ____opt_2 and ____opt_2.enemy)
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.PAUSE_MENU
        if ____cond6 then
            self:switchToPauseMenu()
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.WIN_SCREEN
        if ____cond6 then
            self:switchToWinScreen()
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.LOSE_SCREEN
        if ____cond6 then
            self:switchToLoseScreen()
            break
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.MAP
        if ____cond6 then
            self:switchToMap()
            break
        end
        do
            exhaustiveGuard(self.gameState)
        end
    until true
end
function GameManager.prototype.switchToMainMenu(self)
    local mainMenuState = {update = function(____, dt)
        local ____opt_5 = self.mainMenu
        if ____opt_5 ~= nil then
            ____opt_5:drawScreen()
        end
    end}
    self.gameState = GameStates.MAIN_MENU
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.mainMenu) then
        self.mainMenu = __TS__New(MainMenu, self)
    end
    GameStateManager:setState(mainMenuState)
end
function GameManager.prototype.switchToNewGameMenu(self)
    local newGameMenuState = {update = function(____, dt)
        local ____opt_7 = self.newGameMenu
        if ____opt_7 ~= nil then
            ____opt_7:drawScreen()
        end
    end}
    self.gameState = GameStates.NEW_GAME_MENU
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.newGameMenu) then
        self.newGameMenu = __TS__New(NewGameMenu, self)
    end
    GameStateManager:setState(newGameMenuState)
end
function GameManager.prototype.switchToPauseMenu(self)
    local pauseMenuState = {update = function(____, dt)
        local ____opt_9 = self.pauseMenu
        if ____opt_9 ~= nil then
            ____opt_9:drawScreen()
        end
    end}
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.pauseMenu) then
        self.pauseMenu = __TS__New(PauseMenu, self)
    end
    GameStateManager:setState(pauseMenuState)
end
function GameManager.prototype.switchToBoard(self, enemy)
    local boardState = {update = function(____, dt)
        local ____opt_11 = self.board
        if ____opt_11 ~= nil then
            ____opt_11:drawBoard()
        end
    end}
    self.gameState = GameStates.PLAYING
    self.winScreen = nil
    self.loseScreen = nil
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.board) then
        self.board = __TS__New(
            Board,
            self,
            enemy or __TS__New(Enemy)
        )
        self.board.dealer:setup()
    end
    GameStateManager:setState(boardState)
end
function GameManager.prototype.switchToWinScreen(self)
    local winState = {update = function(____, dt)
        local ____opt_13 = self.winScreen
        if ____opt_13 ~= nil then
            ____opt_13:drawScreen()
        end
    end}
    self.gameState = GameStates.WIN_SCREEN
    self.loseScreen = nil
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.winScreen) then
        self.winScreen = __TS__New(WinScreen, self)
    end
    local ____opt_15 = self.board
    if ____opt_15 ~= nil then
        ____opt_15.dealer:getLootCards()
    end
    GameStateManager:setState(winState)
end
function GameManager.prototype.switchToLoseScreen(self)
    local loseState = {update = function(____, dt)
        local ____opt_17 = self.loseScreen
        if ____opt_17 ~= nil then
            ____opt_17:drawScreen()
        end
    end}
    self.gameState = GameStates.LOSE_SCREEN
    self.board = nil
    self.winScreen = nil
    suit.theme.color.normal.fg = {1, 1, 1}
    if isEmpty(self.loseScreen) then
        self.loseScreen = __TS__New(LoseScreen)
    end
    GameStateManager:setState(loseState)
end
function GameManager.prototype.switchToMap(self)
    local mapState = {
        update = function(____, dt)
            self.map:drawMap()
        end,
        draw = function()
            self.map:drawBackground()
        end
    }
    self.gameState = GameStates.MAP
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    Draw:setThemeColors(0, 0, 0)
    GameStateManager:setState(mapState)
end
return ____exports
