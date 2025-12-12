local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local TrumpRanks = ____Enums.TrumpRanks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Knight = ____exports.default
Knight.name = "Knight"
__TS__ClassExtends(Knight, Card)
function Knight.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        TrumpRanks.KNIGHT,
        7,
        0,
        "Knight"
    )
end
return ____exports
