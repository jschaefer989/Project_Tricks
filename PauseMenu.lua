local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
local ____Save = require("Save")
local Save = ____Save.default
local panelW = 240
local labelY = 50
local btnW = 200
local btnH = 50
local labelHeight = 36
____exports.default = __TS__Class()
local PauseMenu = ____exports.default
PauseMenu.name = "PauseMenu"
function PauseMenu.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function PauseMenu.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelX = (screenW - panelW) / 2
    self:renderDisplayTitle(panelX)
    local continueBtnY = self:renderContinueButton(panelX)
    local saveBtnY = self:renderSaveButton(panelX, continueBtnY)
    self:renderQuitButton(panelX, saveBtnY)
end
function PauseMenu.prototype.renderDisplayTitle(self, panelX)
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Paused",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
end
function PauseMenu.prototype.renderContinueButton(self, panelX)
    local continueBtnY = labelY + labelHeight + 20
    suit.layout:reset(panelX, continueBtnY)
    local continueResult = suit.Button(
        "Continue",
        {},
        suit.layout:row(btnW, btnH)
    )
    if continueResult.hit then
        self.gameManager:switchBasedOnGameState()
    end
    return continueBtnY
end
function PauseMenu.prototype.renderSaveButton(self, panelX, continueBtnY)
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
    return saveBtnY
end
function PauseMenu.prototype.renderQuitButton(self, panelX, saveBtnY)
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
