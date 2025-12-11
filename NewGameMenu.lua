local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
local panelW = 300
local titleY = 50
local labelHeight = 36
local inputW = 280
local inputH = 40
local btnW = 200
local btnH = 50
____exports.default = __TS__Class()
local NewGameMenu = ____exports.default
NewGameMenu.name = "NewGameMenu"
function NewGameMenu.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.nameInput = {text = "Player", forcefocus = true}
end
function NewGameMenu.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelX = (screenW - panelW) / 2
    self:renderDisplayTitle(panelX)
    local labelY = self:renderPlayerNameLabel(panelX)
    local inputY = labelY + 30
    self:renderPlayerNameField(panelX, inputY)
    local startBtnY = self:renderStartButton(panelX, inputY)
    self:renderBackButton(panelX, startBtnY)
end
function NewGameMenu.prototype.renderDisplayTitle(self, panelX)
    suit.layout:reset(panelX, titleY)
    suit.Label(
        "New Game",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
end
function NewGameMenu.prototype.renderPlayerNameLabel(self, panelX)
    local promptY = titleY + labelHeight + 20
    suit.layout:reset(panelX, promptY)
    suit.Label(
        "Player Name:",
        {align = "left"},
        suit.layout:row(panelW, 25)
    )
    return promptY
end
function NewGameMenu.prototype.renderPlayerNameField(self, panelX, inputY)
    suit.layout:reset(panelX, inputY)
    local inputResult = suit.Input(
        self.nameInput,
        {},
        suit.layout:row(inputW, inputH)
    )
    if inputResult.submitted then
        self:handleStartGame()
    end
end
function NewGameMenu.prototype.renderStartButton(self, panelX, inputY)
    local startBtnY = inputY + inputH + 30
    suit.layout:reset(panelX, startBtnY)
    local startResult = suit.Button(
        "Start Game",
        {},
        suit.layout:row(btnW, btnH)
    )
    if startResult.hit then
        self:handleStartGame()
    end
    return startBtnY
end
function NewGameMenu.prototype.renderBackButton(self, panelX, startBtnY)
    local backBtnY = startBtnY + btnH + 20
    suit.layout:reset(panelX, backBtnY)
    local backResult = suit.Button(
        "Back",
        {},
        suit.layout:row(btnW, btnH)
    )
    if backResult.hit then
        self.gameManager:switchToMainMenu()
    end
end
function NewGameMenu.prototype.handleStartGame(self)
    local playerName = __TS__StringTrim(self.nameInput.text)
    if #playerName > 0 then
        self.gameManager.player.name = playerName
        self.gameManager.map:generateNewMap()
        self.gameManager:switchToMap()
    end
end
return ____exports
