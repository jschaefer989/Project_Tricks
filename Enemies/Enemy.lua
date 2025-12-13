local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____Card = require("Cards.Card")
local Card = ____Card.default
local ____Character = require("Character")
local Character = ____Character.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
____exports.default = __TS__Class()
local Enemy = ____exports.default
Enemy.name = "Enemy"
__TS__ClassExtends(Enemy, Character)
function Enemy.prototype.____constructor(self, level, enemyType, experience, name, numberOfHeldCards, numberOfCardsInDeck)
    Character.prototype.____constructor(self)
    self.numberOfHeldCards = numberOfHeldCards or 3
    self.numberOfCardsInDeck = numberOfCardsInDeck or 9
    self.level = level or 1
    self.enemyType = enemyType or EnemyTypes.KOBOLD
    self.experience = experience or 0
    self.name = name or "Enemy"
end
function Enemy.prototype.load(self, gameManager, data)
    self.gameManager = gameManager
    self.hand = data and data.hand and __TS__ArrayMap(
        data.hand,
        function(____, cardData) return Card:load(gameManager, cardData) end
    ) or ({})
    self.deck = data and data.deck and __TS__ArrayMap(
        data.deck,
        function(____, cardData) return Card:load(gameManager, cardData) end
    ) or ({})
    self.discardPile = data and data.discardPile and __TS__ArrayMap(
        data.discardPile,
        function(____, cardData) return Card:load(gameManager, cardData) end
    ) or ({})
    self.level = data and data.level or 1
    self.numberOfHeldCards = data and data.numberOfHeldCards or 3
    self.numberOfCardsInDeck = data and data.numberOfCardsInDeck or 9
    self.enemyType = data and data.enemyType or EnemyTypes.KOBOLD
    self.experience = data and data.experience or 0
end
function Enemy.prototype.save(self)
    return {
        hand = __TS__ArrayMap(
            self.hand,
            function(____, card) return card:save() end
        ),
        deck = __TS__ArrayMap(
            self.deck,
            function(____, card) return card:save() end
        ),
        discardPile = __TS__ArrayMap(
            self.discardPile,
            function(____, card) return card:save() end
        ),
        level = self.level,
        numberOfHeldCards = self.numberOfHeldCards,
        numberOfCardsInDeck = self.numberOfCardsInDeck,
        enemyType = self.enemyType,
        experience = self.experience
    }
end
return ____exports
