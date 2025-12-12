local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local Ranks = ____Enums.Ranks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Thief = ____exports.default
Thief.name = "Thief"
__TS__ClassExtends(Thief, Card)
function Thief.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        Ranks.THIEF,
        5,
        4,
        "Thief"
    )
end
return ____exports
