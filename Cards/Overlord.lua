local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local Ranks = ____Enums.Ranks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Overlord = ____exports.default
Overlord.name = "Overlord"
__TS__ClassExtends(Overlord, Card)
function Overlord.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        Ranks.OVERLORD,
        10,
        2,
        "Overlord"
    )
end
return ____exports
