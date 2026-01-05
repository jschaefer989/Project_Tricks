local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local GameStates = ____Enums.GameStates
local CharacterTypes = ____Enums.CharacterTypes
local ____MainMenu = require("Screens.MainMenu")
local MainMenu = ____MainMenu.default
local ____NewGameMenu = require("Screens.NewGameMenu")
local NewGameMenu = ____NewGameMenu.default
local ____PauseMenu = require("Screens.PauseMenu")
local PauseMenu = ____PauseMenu.default
local ____Board = require("Screens.Board")
local Board = ____Board.default
local ____WinScreen = require("Screens.WinScreen")
local WinScreen = ____WinScreen.default
local ____LoseScreen = require("Screens.LoseScreen")
local LoseScreen = ____LoseScreen.default
local ____Settings = require("Settings")
local Settings = ____Settings.default
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local ____Player = require("Player")
local Player = ____Player.default
local ____Map = require("Screens.Map.Map")
local Map = ____Map.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____Shop = require("Screens.Shop")
local Shop = ____Shop.default
local ____LevelUpScreen = require("Screens.LevelUpScreen")
local LevelUpScreen = ____LevelUpScreen.default
local ____PerkScreen = require("Screens.PerkScreen")
local PerkScreen = ____PerkScreen.default
local push = require("Libraries.push")
local ____AssetManager = require("Assets.AssetManager")
local AssetManager = ____AssetManager.default
local ____TextManager = require("Assets.TextManager")
local TextManager = ____TextManager.default
local ____AnimationManager = require("Assets.Animations.AnimationManager")
local AnimationManager = ____AnimationManager.default
local ____MusicPlayer = require("Assets.Music.MusicPlayer")
local MusicPlayer = ____MusicPlayer.default
local ____Grass = require("Biomes.Grass")
local Grass = ____Grass.default
____exports.default = __TS__Class()
local GameManager = ____exports.default
GameManager.name = "GameManager"
function GameManager.prototype.____constructor(self)
    self.devMode = false
    self.gameState = GameStates.MAIN_MENU
    self.player = __TS__New(Player, self)
    self.settings = __TS__New(Settings)
    self.map = __TS__New(Map, self)
    self.assetManager = __TS__New(AssetManager, self)
    self.animationManager = __TS__New(AnimationManager, self)
    self.musicPlayer = __TS__New(MusicPlayer, self)
    self.biome = __TS__New(Grass)
    if not self.devMode then
        TextManager:setDefaultFont()
    end
end
function GameManager.prototype.getCharacter(self, characterType)
    repeat
        local ____switch5 = characterType
        local ____cond5 = ____switch5 == CharacterTypes.PLAYER
        if ____cond5 then
            return self.player
        end
        ____cond5 = ____cond5 or ____switch5 == CharacterTypes.ENEMY
        if ____cond5 then
            local ____opt_0 = self.board
            return ____opt_0 and ____opt_0.enemy
        end
    until true
end
function GameManager.prototype.switchBasedOnGameState(self, gameState, enemy)
    if gameState == nil then
        gameState = self.gameState
    end
    if enemy == nil then
        local ____opt_2 = self.board
        enemy = ____opt_2 and ____opt_2.enemy
    end
    self.assetManager = __TS__New(AssetManager, self)
    self.musicPlayer:play(gameState, self.biome)
    repeat
        local ____switch7 = gameState
        local ____cond7 = ____switch7 == GameStates.MAIN_MENU
        if ____cond7 then
            self:switchToMainMenu()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.NEW_GAME_MENU
        if ____cond7 then
            self:switchToNewGameMenu()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.BOARD
        if ____cond7 then
            self:switchToBoard(enemy)
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.PAUSE_MENU
        if ____cond7 then
            self:switchToPauseMenu()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.WIN_SCREEN
        if ____cond7 then
            self:switchToWinScreen()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.LOSE_SCREEN
        if ____cond7 then
            self:switchToLoseScreen()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.MAP
        if ____cond7 then
            self:switchToMap()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.SHOP
        if ____cond7 then
            self:switchToShop()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.LEVEL_UP
        if ____cond7 then
            self:switchToLevelUpScreen()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.PERKS
        if ____cond7 then
            self:switchToPerkScreen()
            break
        end
        do
            exhaustiveGuard(gameState)
        end
    until true
end
function GameManager.prototype.switchToMainMenu(self)
    local mainMenuState = {update = function(____, dt)
        local ____opt_4 = self.mainMenu
        if ____opt_4 ~= nil then
            ____opt_4:drawScreen()
        end
    end}
    self.gameState = GameStates.MAIN_MENU
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    self.shop = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
    if isEmpty(self.mainMenu) then
        self.mainMenu = __TS__New(MainMenu, self)
    end
    GameStateManager:setState(mainMenuState)
end
function GameManager.prototype.switchToNewGameMenu(self)
    local newGameMenuState = {update = function(____, dt)
        local ____opt_6 = self.newGameMenu
        if ____opt_6 ~= nil then
            ____opt_6:drawScreen()
        end
    end}
    self.gameState = GameStates.NEW_GAME_MENU
    if isEmpty(self.newGameMenu) then
        self.newGameMenu = __TS__New(NewGameMenu, self)
    end
    GameStateManager:setState(newGameMenuState)
end
function GameManager.prototype.switchToPauseMenu(self)
    local pauseMenuState = {update = function(____, dt)
        local ____opt_8 = self.pauseMenu
        if ____opt_8 ~= nil then
            ____opt_8:drawScreen()
        end
    end}
    if isEmpty(self.pauseMenu) then
        self.pauseMenu = __TS__New(PauseMenu, self)
    end
    GameStateManager:setState(pauseMenuState)
end
function GameManager.prototype.switchToBoard(self, enemy)
    local boardState = {
        update = function(____, dt)
            local ____opt_10 = self.board
            if ____opt_10 ~= nil then
                ____opt_10:drawBoard()
            end
            self.assetManager:handleMouseHover()
            self.animationManager:updateAnimations(dt)
        end,
        draw = function()
            if not self.devMode then
                push:start()
                self.assetManager:drawAssets()
                push:finish()
            end
        end,
        mousepressed = function(____, x, y, button)
            if not self.devMode then
                self.assetManager:handleMousePressed(x, y, button)
            end
        end,
        mousereleased = function(____, x, y, button)
            if not self.devMode then
                self.assetManager:handleMouseReleased(x, y, button)
            end
        end
    }
    self.gameState = GameStates.BOARD
    self.winScreen = nil
    self.loseScreen = nil
    self.shop = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
    if isEmpty(self.board) then
        self.board = __TS__New(
            Board,
            self,
            enemy or __TS__New(Enemy, self)
        )
        self.board.dealer:setup()
    end
    self.board:buildAssets()
    GameStateManager:setState(boardState)
end
function GameManager.prototype.switchToWinScreen(self)
    local winState = {update = function(____, dt)
        local ____opt_12 = self.winScreen
        if ____opt_12 ~= nil then
            ____opt_12:drawScreen()
        end
    end}
    self.gameState = GameStates.WIN_SCREEN
    self.loseScreen = nil
    self.shop = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
    if isEmpty(self.winScreen) then
        self.winScreen = __TS__New(WinScreen, self)
    end
    GameStateManager:setState(winState)
end
function GameManager.prototype.switchToLoseScreen(self)
    local loseState = {update = function(____, dt)
        local ____opt_14 = self.loseScreen
        if ____opt_14 ~= nil then
            ____opt_14:drawScreen()
        end
    end}
    self.gameState = GameStates.LOSE_SCREEN
    self.board = nil
    self.winScreen = nil
    self.shop = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
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
    self.shop = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
    GameStateManager:setState(mapState)
end
function GameManager.prototype.switchToShop(self)
    local shopState = {update = function(____, dt)
        local ____opt_16 = self.shop
        if ____opt_16 ~= nil then
            ____opt_16:drawShop()
        end
    end}
    self.gameState = GameStates.SHOP
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    self.levelUpScreen = nil
    self.perkScreen = nil
    if isEmpty(self.shop) then
        self.shop = __TS__New(Shop, self)
        self.shop:setup()
    end
    GameStateManager:setState(shopState)
end
function GameManager.prototype.switchToLevelUpScreen(self)
    local levelUpState = {update = function(____, dt)
        local ____opt_18 = self.levelUpScreen
        if ____opt_18 ~= nil then
            ____opt_18:drawScreen()
        end
    end}
    self.gameState = GameStates.LEVEL_UP
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    self.shop = nil
    self.perkScreen = nil
    if isEmpty(self.levelUpScreen) then
        self.levelUpScreen = __TS__New(LevelUpScreen, self)
        self.levelUpScreen:setup()
    end
    GameStateManager:setState(levelUpState)
end
function GameManager.prototype.switchToPerkScreen(self)
    local perkState = {update = function(____, dt)
        local ____opt_20 = self.perkScreen
        if ____opt_20 ~= nil then
            ____opt_20:drawScreen()
        end
    end}
    self.gameState = GameStates.PERKS
    self.board = nil
    self.winScreen = nil
    self.loseScreen = nil
    self.shop = nil
    self.levelUpScreen = nil
    if isEmpty(self.perkScreen) then
        self.perkScreen = __TS__New(PerkScreen, self)
    end
    GameStateManager:setState(perkState)
end
function GameManager.prototype.getCard(self, id)
    for ____, card in ipairs(self.player.hand) do
        if card.id == id then
            return card
        end
    end
    for ____, card in ipairs(self.player.deck) do
        if card.id == id then
            return card
        end
    end
    for ____, card in ipairs(self.player.discardPile) do
        if card.id == id then
            return card
        end
    end
    local ____opt_22 = self.board
    local enemy = ____opt_22 and ____opt_22.enemy
    if isEmpty(enemy) then
        return
    end
    for ____, card in ipairs(enemy.hand) do
        if card.id == id then
            return card
        end
    end
    for ____, card in ipairs(enemy.deck) do
        if card.id == id then
            return card
        end
    end
    for ____, card in ipairs(enemy.discardPile) do
        if card.id == id then
            return card
        end
    end
end
return ____exports
