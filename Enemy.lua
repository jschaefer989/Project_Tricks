local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Character = require("Character")
local Character = ____Character.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
____exports.default = __TS__Class()
local Enemy = ____exports.default
Enemy.name = "Enemy"
__TS__ClassExtends(Enemy, Character)
function Enemy.prototype.____constructor(self, numberOfHeldCards, numberOfCardsInDeck, level, enemyType)
    Character.prototype.____constructor(self)
    self.numberOfHeldCards = numberOfHeldCards or 3
    self.numberOfCardsInDeck = numberOfCardsInDeck or 9
    self.level = level or 1
    self.enemyType = enemyType or EnemyTypes.GOBLIN
end
function Enemy.prototype.load(self, data)
    self.hand = data and data.hand or ({})
    self.deck = data and data.deck or ({})
    self.discardPile = data and data.discardPile or ({})
    self.level = data and data.level or 1
    self.numberOfHeldCards = data and data.numberOfHeldCards or 3
    self.numberOfCardsInDeck = data and data.numberOfCardsInDeck or 9
    self.enemyType = data and data.enemyType or EnemyTypes.GOBLIN
end
function Enemy.prototype.save(self)
    return {
        hand = self.hand,
        deck = self.deck,
        discardPile = self.discardPile,
        level = self.level,
        numberOfHeldCards = self.numberOfHeldCards,
        numberOfCardsInDeck = self.numberOfCardsInDeck,
        enemyType = self.enemyType
    }
end
function Enemy.prototype.getCardPower(self)
    local power = 0
    for ____, card in ipairs(self.hand) do
        power = power + card.power
    end
    return power
end
function Enemy.prototype.getCardValue(self)
    local value = 0
    for ____, card in ipairs(self.hand) do
        value = value + card.value
    end
    return value
end
function Enemy.prototype.removeAllCardsFromHand(self)
    do
        local i = #self.hand - 1
        while i >= 0 do
            local card = self.hand[i + 1]
            self:addToDiscards(card)
            __TS__ArraySplice(self.hand, i, 1)
            i = i - 1
        end
    end
end
function Enemy.prototype.getEnemyName(self)
    repeat
        local ____switch15 = self.enemyType
        local ____cond15 = ____switch15 == EnemyTypes.GOBLIN
        if ____cond15 then
            return "Goblin"
        end
        ____cond15 = ____cond15 or ____switch15 == EnemyTypes.ORC
        if ____cond15 then
            return "Orc"
        end
        ____cond15 = ____cond15 or ____switch15 == EnemyTypes.TROLL
        if ____cond15 then
            return "Troll"
        end
        ____cond15 = ____cond15 or ____switch15 == EnemyTypes.DRAGON
        if ____cond15 then
            return "Dragon"
        end
        do
            return "Unknown"
        end
    until true
end
return ____exports
