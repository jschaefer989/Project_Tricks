local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
____exports.default = __TS__Class()
local Tatzelwurm = ____exports.default
Tatzelwurm.name = "Tatzelwurm"
__TS__ClassExtends(Tatzelwurm, Enemy)
function Tatzelwurm.prototype.____constructor(self, level, numberOfHeldCards, numberOfCardsInDeck)
    Enemy.prototype.____constructor(
        self,
        level,
        EnemyTypes.TATZELWURM,
        50 * level,
        "Tatzelwurm",
        numberOfHeldCards,
        numberOfCardsInDeck
    )
end
return ____exports
