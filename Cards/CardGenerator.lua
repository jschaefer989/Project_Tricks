local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local Ranks = ____Enums.Ranks
local Suits = ____Enums.Suits
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local getRandomElementFromEnum = ____Helpers.getRandomElementFromEnum
local ____Banner = require("Cards.Banner")
local Banner = ____Banner.default
local ____Baron = require("Cards.Baron")
local Baron = ____Baron.default
local ____Deuce = require("Cards.Deuce")
local Deuce = ____Deuce.default
local ____Jester = require("Cards.Jester")
local Jester = ____Jester.default
local ____King = require("Cards.King")
local King = ____King.default
local ____Overlord = require("Cards.Overlord")
local Overlord = ____Overlord.default
local ____Priest = require("Cards.Priest")
local Priest = ____Priest.default
local ____Sergeant = require("Cards.Sergeant")
local Sergeant = ____Sergeant.default
local ____Soldier = require("Cards.Soldier")
local Soldier = ____Soldier.default
local ____Thief = require("Cards.Thief")
local Thief = ____Thief.default
____exports.default = __TS__Class()
local CardGenerator = ____exports.default
CardGenerator.name = "CardGenerator"
function CardGenerator.prototype.____constructor(self)
end
function CardGenerator.getNewCard(self, gameManager, rank, suit)
    repeat
        local ____switch4 = rank
        local ____cond4 = ____switch4 == Ranks.BANNER
        if ____cond4 then
            return __TS__New(Banner, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.BARON
        if ____cond4 then
            return __TS__New(Baron, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.DEUCE
        if ____cond4 then
            return __TS__New(Deuce, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.JESTER
        if ____cond4 then
            return __TS__New(Jester, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.KING
        if ____cond4 then
            return __TS__New(King, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.OVERLORD
        if ____cond4 then
            return __TS__New(Overlord, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.PRIEST
        if ____cond4 then
            return __TS__New(Priest, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.SERGEANT
        if ____cond4 then
            return __TS__New(Sergeant, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.THIEF
        if ____cond4 then
            return __TS__New(Thief, gameManager, suit)
        end
        ____cond4 = ____cond4 or ____switch4 == Ranks.SOLDIER
        if ____cond4 then
            return __TS__New(Soldier, gameManager, suit)
        end
        do
            exhaustiveGuard(rank)
        end
    until true
end
function CardGenerator.getRandomCard(self, gameManager)
    local suit = getRandomElementFromEnum(Suits)
    local rank = getRandomElementFromEnum(Ranks)
    return ____exports.default:getNewCard(gameManager, rank, suit)
end
return ____exports
