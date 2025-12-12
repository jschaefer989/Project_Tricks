local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
local ____Save = require("Save")
local Save = ____Save.default
____exports.default = __TS__Class()
local MainMenu = ____exports.default
MainMenu.name = "MainMenu"
function MainMenu.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function MainMenu.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Tricks",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local btnW = 200
    local btnH = 50
    local continueBtnY = labelY + labelHeight + 20
    local saveExists = love.filesystem.getInfo("savegame.json")
    if saveExists then
        suit.layout:reset(panelX, continueBtnY)
        local continueResult = suit.Button(
            "Continue",
            {},
            suit.layout:row(btnW, btnH)
        )
        if continueResult.hit then
            Save:load(self.gameManager)
            self.gameManager:switchBasedOnGameState()
        end
    end
    local newGameBtnY = saveExists and continueBtnY + btnH + 10 or continueBtnY
    suit.layout:reset(panelX, newGameBtnY)
    local newGameResult = suit.Button(
        "New Game",
        {},
        suit.layout:row(btnW, btnH)
    )
    if newGameResult.hit then
        self.gameManager:switchToNewGameMenu()
    end
    local quitBtnY = newGameBtnY + btnH + 10
    suit.layout:reset(panelX, quitBtnY)
    local quitResult = suit.Button(
        "Quit",
        {},
        suit.layout:row(btnW, btnH)
    )
    if quitResult.hit then
        love.event.quit()
    end
end
return ____exports
