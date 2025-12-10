local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local suit = require("Libraries.suit-master.suit")
local ____Save = require("Save")
local Save = ____Save.Save
____exports.default = __TS__Class()
local PauseMenu = ____exports.default
PauseMenu.name = "PauseMenu"
function PauseMenu.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function PauseMenu.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Paused",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local panelY = labelY + labelHeight
    local btnW = 200
    local btnH = 50
    local continueBtnY = panelY + 20
    suit.layout:reset(panelX, continueBtnY)
    local continueResult = suit.Button(
        "Continue",
        {},
        suit.layout:row(btnW, btnH)
    )
    if continueResult.hit then
        GameStateManager:revertState()
    end
    local saveBtnY = continueBtnY + btnH + 10
    suit.layout:reset(panelX, saveBtnY)
    local saveResult = suit.Button(
        "Save",
        {},
        suit.layout:row(btnW, btnH)
    )
    if saveResult.hit then
        Save:save(self.gameManager)
    end
    local quitBtnY = saveBtnY + btnH + 10
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
