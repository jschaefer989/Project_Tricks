local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enums = require("Enums")
local Ranks = ____Enums.Ranks
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Jester = ____exports.default
Jester.name = "Jester"
__TS__ClassExtends(Jester, Card)
function Jester.prototype.____constructor(self, gameManager, suit)
    Card.prototype.____constructor(
        self,
        gameManager,
        suit,
        Ranks.JESTER,
        1,
        0,
        "Jester"
    )
end
return ____exports
