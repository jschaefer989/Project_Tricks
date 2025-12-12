local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Enums = require("Enums")
local Perks = ____Enums.Perks
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
____exports.default = __TS__Class()
local Perk = ____exports.default
Perk.name = "Perk"
function Perk.prototype.____constructor(self, gameManager, perkType)
    self.gameManager = gameManager
    self.perkType = perkType
end
function Perk.prototype.getPerkName(self)
    repeat
        local ____switch4 = self.perkType
        local ____cond4 = ____switch4 == Perks.EXTRA_CARD
        if ____cond4 then
            return "Extra Card"
        end
        ____cond4 = ____cond4 or ____switch4 == Perks.EXTRA_DISCARD
        if ____cond4 then
            return "Extra Discard"
        end
        ____cond4 = ____cond4 or ____switch4 == Perks.INCREASED_LOOT
        if ____cond4 then
            return "Increased Loot"
        end
        do
            exhaustiveGuard(self.perkType)
        end
    until true
end
return ____exports
