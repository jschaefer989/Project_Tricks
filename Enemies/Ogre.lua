local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
____exports.default = __TS__Class()
local Ogre = ____exports.default
Ogre.name = "Ogre"
__TS__ClassExtends(Ogre, Enemy)
function Ogre.prototype.____constructor(self, level, numberOfHeldCards, numberOfCardsInDeck)
    Enemy.prototype.____constructor(
        self,
        level,
        EnemyTypes.OGRE,
        30 * level,
        "Ogre",
        numberOfHeldCards,
        numberOfCardsInDeck
    )
end
return ____exports
