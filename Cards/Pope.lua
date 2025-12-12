local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local TrumpRanks = ____Enums.TrumpRanks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Pope = ____exports.default
Pope.name = "Pope"
__TS__ClassExtends(Pope, Card)
function Pope.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        TrumpRanks.POPE,
        14,
        4,
        "Pope"
    )
end
return ____exports
