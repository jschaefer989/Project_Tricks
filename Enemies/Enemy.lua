local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Character = require("Character")
local Character = ____Character.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
____exports.default = __TS__Class()
local Enemy = ____exports.default
Enemy.name = "Enemy"
__TS__ClassExtends(Enemy, Character)
function Enemy.prototype.____constructor(self, numberOfHeldCards, numberOfCardsInDeck, level, enemyType, experience)
    Character.prototype.____constructor(self)
    self.numberOfHeldCards = numberOfHeldCards or 3
    self.numberOfCardsInDeck = numberOfCardsInDeck or 9
    self.level = level or 1
    self.enemyType = enemyType or EnemyTypes.GOBLIN
    self.experience = experience or self:getExpeierenceReward()
end
function Enemy.prototype.load(self, data)
    self.hand = data and data.hand or ({})
    self.deck = data and data.deck or ({})
    self.discardPile = data and data.discardPile or ({})
    self.level = data and data.level or 1
    self.numberOfHeldCards = data and data.numberOfHeldCards or 3
    self.numberOfCardsInDeck = data and data.numberOfCardsInDeck or 9
    self.enemyType = data and data.enemyType or EnemyTypes.GOBLIN
    self.experience = data and data.experience or self:getExpeierenceReward()
end
function Enemy.prototype.save(self)
    return {
        hand = self.hand,
        deck = self.deck,
        discardPile = self.discardPile,
        level = self.level,
        numberOfHeldCards = self.numberOfHeldCards,
        numberOfCardsInDeck = self.numberOfCardsInDeck,
        enemyType = self.enemyType,
        experience = self.experience
    }
end
function Enemy.prototype.getEnemyName(self)
    repeat
        local ____switch6 = self.enemyType
        local ____cond6 = ____switch6 == EnemyTypes.GOBLIN
        if ____cond6 then
            return "Goblin"
        end
        ____cond6 = ____cond6 or ____switch6 == EnemyTypes.ORC
        if ____cond6 then
            return "Orc"
        end
        ____cond6 = ____cond6 or ____switch6 == EnemyTypes.TROLL
        if ____cond6 then
            return "Troll"
        end
        ____cond6 = ____cond6 or ____switch6 == EnemyTypes.DRAGON
        if ____cond6 then
            return "Dragon"
        end
        do
            exhaustiveGuard(self.enemyType)
        end
    until true
end
function Enemy.prototype.getExpeierenceReward(self)
    repeat
        local ____switch8 = self.enemyType
        local ____cond8 = ____switch8 == EnemyTypes.GOBLIN
        if ____cond8 then
            return 10 * self.level
        end
        ____cond8 = ____cond8 or ____switch8 == EnemyTypes.ORC
        if ____cond8 then
            return 20 * self.level
        end
        ____cond8 = ____cond8 or ____switch8 == EnemyTypes.TROLL
        if ____cond8 then
            return 30 * self.level
        end
        ____cond8 = ____cond8 or ____switch8 == EnemyTypes.DRAGON
        if ____cond8 then
            return 50 * self.level
        end
        do
            exhaustiveGuard(self.enemyType)
        end
    until true
end
return ____exports
