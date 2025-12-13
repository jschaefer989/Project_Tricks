local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
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
function Perk.prototype.save(self)
    return {perkType = self.perkType}
end
function Perk.load(self, gameManager, data)
    return __TS__New(____exports.default, gameManager, data.perkType)
end
function Perk.prototype.getPerkName(self)
    repeat
        local ____switch6 = self.perkType
        local ____cond6 = ____switch6 == Perks.EXTRA_CARD
        if ____cond6 then
            return "Extra Card"
        end
        ____cond6 = ____cond6 or ____switch6 == Perks.EXTRA_DISCARD
        if ____cond6 then
            return "Extra Discard"
        end
        ____cond6 = ____cond6 or ____switch6 == Perks.INCREASED_LOOT
        if ____cond6 then
            return "Increased Loot"
        end
        do
            exhaustiveGuard(self.perkType)
        end
    until true
end
return ____exports
