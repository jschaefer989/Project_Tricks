local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local ____exports = {}
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Enums = require("Enums")
local Perks = ____Enums.Perks
local suit = require("Libraries.suit-master.suit")
local ____Perk = require("Perk")
local Perk = ____Perk.default
____exports.default = __TS__Class()
local LevelUpScreen = ____exports.default
LevelUpScreen.name = "LevelUpScreen"
function LevelUpScreen.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.perks = {}
end
function LevelUpScreen.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 400
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Level Up!",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local btnW = 300
    local btnH = 50
    local perkStartY = labelY + labelHeight + 30
    local perkX = (screenW - btnW) / 2
    local perkPadding = 15
    local currentY = perkStartY
    for ____, perk in ipairs(self.perks) do
        suit.layout:reset(perkX, currentY)
        local perkResult = suit.Button(
            perk:getPerkName(),
            {},
            suit.layout:row(btnW, btnH)
        )
        if perkResult.hit then
            self:selectPerk(perk)
        end
        currentY = currentY + (btnH + perkPadding)
    end
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player)
end
function LevelUpScreen.prototype.selectPerk(self, perk)
    self.gameManager.player:addPerk(perk)
    self.gameManager.map:advanceToNextTier()
    self.gameManager:switchToMap()
end
function LevelUpScreen.prototype.getBaseLevelRequirement(self, perk)
    repeat
        local ____switch9 = perk
        local ____cond9 = ____switch9 == Perks.EXTRA_CARD
        if ____cond9 then
            return 2
        end
        ____cond9 = ____cond9 or ____switch9 == Perks.EXTRA_DISCARD
        if ____cond9 then
            return 2
        end
        ____cond9 = ____cond9 or ____switch9 == Perks.INCREASED_LOOT
        if ____cond9 then
            return 2
        end
    until true
end
function LevelUpScreen.prototype.setup(self)
    self:addAvailablePerks()
end
function LevelUpScreen.prototype.addAvailablePerks(self)
    for ____, perk in ipairs(__TS__ObjectValues(Perks)) do
        do
            if self.gameManager.player.level < self:getBaseLevelRequirement(perk) then
                goto __continue12
            end
            if self.gameManager.player:hasPerk(perk) then
                goto __continue12
            end
            local ____self_perks_0 = self.perks
            ____self_perks_0[#____self_perks_0 + 1] = __TS__New(Perk, self.gameManager, perk)
        end
        ::__continue12::
    end
end
return ____exports
