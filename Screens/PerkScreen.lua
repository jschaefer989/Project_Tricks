local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local PerkScreen = ____exports.default
PerkScreen.name = "PerkScreen"
function PerkScreen.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function PerkScreen.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 400
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Perks",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local perkStartY = labelY + labelHeight + 30
    local perkHeight = 30
    local perkPadding = 10
    local currentY = perkStartY
    if #self.gameManager.player.perks == 0 then
        suit.layout:reset(panelX, currentY)
        suit.Label(
            "No perks yet",
            {align = "center"},
            suit.layout:row(panelW, perkHeight)
        )
    else
        for ____, perk in ipairs(self.gameManager.player.perks) do
            suit.layout:reset(panelX, currentY)
            suit.Label(
                "• " .. perk:getPerkName(),
                {align = "left"},
                suit.layout:row(panelW, perkHeight)
            )
            currentY = currentY + (perkHeight + perkPadding)
        end
    end
    local backBtnY = currentY + 30
    local btnW = 200
    local btnH = 50
    local backBtnX = (screenW - btnW) / 2
    suit.layout:reset(backBtnX, backBtnY)
    local backResult = suit.Button(
        "Back",
        {},
        suit.layout:row(btnW, btnH)
    )
    if backResult.hit then
        self.gameManager:switchBasedOnGameState()
    end
end
return ____exports
