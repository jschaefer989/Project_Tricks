local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local LoseScreen = ____exports.default
LoseScreen.name = "LoseScreen"
function LoseScreen.prototype.____constructor(self)
end
function LoseScreen.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Game Over",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local btnW = 200
    local btnH = 50
    local btnY = labelY + labelHeight + 20
    suit.layout:reset(panelX, btnY)
    local btnResult = suit.Button(
        "Quit",
        {},
        suit.layout:row(btnW, btnH)
    )
    if btnResult.hit then
        love.event.quit()
    end
end
return ____exports
