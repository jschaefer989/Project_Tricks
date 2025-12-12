local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local ____exports = {}
local ____Enums = require("Enums")
local Suits = ____Enums.Suits
local Ranks = ____Enums.Ranks
local CharacterTypes = ____Enums.CharacterTypes
local ____Helpers = require("Helpers")
local getRandomElementFromArray = ____Helpers.getRandomElementFromArray
local getRandomElementFromEnum = ____Helpers.getRandomElementFromEnum
local isEmpty = ____Helpers.isEmpty
local ____Card = require("Cards.Card")
local Card = ____Card.default
____exports.default = __TS__Class()
local Dealer = ____exports.default
Dealer.name = "Dealer"
function Dealer.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.lootCards = {}
end
function Dealer.prototype.setup(self)
    if #self.gameManager.player.deck == 0 then
        ____exports.default:initializePlayerDeck(self.gameManager)
    end
    self.gameManager.player:deselectAllCards()
    self:initializeEnemyDeck()
    ____exports.default:dealCards(self.gameManager, CharacterTypes.PLAYER)
    ____exports.default:dealCards(self.gameManager, CharacterTypes.ENEMY)
end
function Dealer.initializePlayerDeck(self, gameManager)
    for ____, suit in ipairs(__TS__ObjectValues(Suits)) do
        for ____, rank in ipairs(__TS__ObjectValues(Ranks)) do
            gameManager.player:addToDeck(__TS__New(Card, suit, rank))
        end
    end
    ____exports.default:shuffle(gameManager, CharacterTypes.PLAYER)
end
function Dealer.shuffle(self, gameManager, characterType)
    local character = gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    do
        local i = #character.deck - 1
        while i >= 1 do
            local j = math.floor(math.random() * (i + 1))
            local temp = character.deck[i + 1]
            character.deck[i + 1] = character.deck[j + 1]
            character.deck[j + 1] = temp
            i = i - 1
        end
    end
end
function Dealer.dealCards(self, gameManager, characterType)
    local character = gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardsToDeal = character.numberOfHeldCards - #character.hand
    do
        local i = 0
        while i < cardsToDeal do
            local card = table.remove(character.deck)
            if card then
                character:addToHand(card)
            end
            i = i + 1
        end
    end
end
function Dealer.getRandomCard(self)
    local suit = getRandomElementFromEnum(Suits)
    local rank = getRandomElementFromEnum(Ranks)
    return __TS__New(Card, suit, rank)
end
function Dealer.prototype.initializeEnemyDeck(self)
    if not self.gameManager.board or not self.gameManager.board.enemy then
        return
    end
    do
        local i = 0
        while i < self.gameManager.board.enemy.numberOfCardsInDeck do
            self.gameManager.board.enemy:addToDeck(____exports.default:getRandomCard())
            i = i + 1
        end
    end
    ____exports.default:shuffle(self.gameManager, CharacterTypes.ENEMY)
end
function Dealer.prototype.getLootCards(self)
    if not self.gameManager.board or not self.gameManager.board.enemy then
        return {}
    end
    self.lootCards = {}
    do
        local i = 0
        while i < self.gameManager.player.numberOfLootCards do
            local card = getRandomElementFromArray(self.gameManager.board.enemy.discardPile)
            if card and not self:hasLootCard(card) then
                self:addLootCard(card)
            else
                i = i - 1
            end
            i = i + 1
        end
    end
    return self.lootCards
end
function Dealer.prototype.addLootCard(self, card)
    local ____self_lootCards_0 = self.lootCards
    ____self_lootCards_0[#____self_lootCards_0 + 1] = card
end
function Dealer.prototype.hasLootCard(self, card)
    for ____, lootCard in ipairs(self.lootCards) do
        if lootCard:isEqual(card) then
            return true
        end
    end
    return false
end
function Dealer.prototype.deselectLootCards(self)
    for ____, card in ipairs(self.lootCards) do
        card.selected = false
    end
end
function Dealer.prototype.addLootCardsToPlayer(self)
    for ____, card in ipairs(self.lootCards) do
        if card.selected then
            self.gameManager.player:addToDeck(card)
        end
    end
end
return ____exports
