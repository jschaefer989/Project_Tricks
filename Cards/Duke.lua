local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local TrumpRanks = ____Enums.TrumpRanks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Duke = ____exports.default
Duke.name = "Duke"
__TS__ClassExtends(Duke, Card)
function Duke.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        TrumpRanks.DUKE,
        9,
        5,
        "Duke"
    )
end
return ____exports
