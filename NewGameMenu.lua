local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local NewGameMenu = ____exports.default
NewGameMenu.name = "NewGameMenu"
function NewGameMenu.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.nameInput = {text = "Player"}
end
function NewGameMenu.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 300
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "New Game",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local promptY = labelY + labelHeight + 20
    suit.layout:reset(panelX, promptY)
    suit.Label(
        "Player Name:",
        {align = "left"},
        suit.layout:row(panelW, 25)
    )
    local inputY = promptY + 30
    local inputW = 280
    local inputH = 40
    suit.layout:reset(panelX, inputY)
    suit.Input(
        self.nameInput,
        {},
        suit.layout:row(inputW, inputH)
    )
    local btnW = 200
    local btnH = 50
    local startBtnY = inputY + inputH + 30
    suit.layout:reset(panelX, startBtnY)
    local startResult = suit.Button(
        "Start Game",
        {},
        suit.layout:row(btnW, btnH)
    )
    if startResult.hit then
        local playerName = __TS__StringTrim(self.nameInput.text)
        if #playerName > 0 then
            self.gameManager.player.name = playerName
            self.gameManager:switchToBoard()
        end
    end
    local backBtnY = startBtnY + btnH + 10
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
return ____exports
