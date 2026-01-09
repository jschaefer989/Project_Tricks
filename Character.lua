local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Character = ____exports.default
Character.name = "Character"
function Character.prototype.____constructor(self, gameManager, ____type)
    self.gameManager = gameManager
    self.type = ____type
    self.deck = {}
    self.hand = {}
    self.discardPile = {}
    self.numberOfHeldCards = 5
end
function Character.prototype.addToHand(self, card, index)
    if not isEmpty(index) and index >= 0 and index < #self.hand then
        __TS__ArraySplice(self.hand, index, 0, card)
    else
        local ____self_hand_0 = self.hand
        ____self_hand_0[#____self_hand_0 + 1] = card
    end
end
function Character.prototype.removeFromHand(self, card)
    do
        local index = 0
        while index < #self.hand do
            local otherCard = self.hand[index + 1]
            if card:isEqual(otherCard) then
                __TS__ArraySplice(self.hand, index, 1)
                break
            end
            index = index + 1
        end
    end
end
function Character.prototype.addToDeck(self, card)
    local ____self_deck_1 = self.deck
    ____self_deck_1[#____self_deck_1 + 1] = card
end
function Character.prototype.addToDiscards(self, card)
    local ____self_discardPile_2 = self.discardPile
    ____self_discardPile_2[#____self_discardPile_2 + 1] = card
end
function Character.prototype.addDiscardsToDeck(self)
    for ____, card in ipairs(self.discardPile) do
        self:addToDeck(card)
    end
    self.discardPile = {}
end
function Character.prototype.deselectAllCards(self)
    for ____, card in ipairs(self.hand) do
        card:onUnselect()
    end
end
function Character.prototype.getCardPower(self)
    local power = 0
    for ____, card in ipairs(self.hand) do
        power = power + card.power
    end
    return power
end
function Character.prototype.getCardValue(self)
    local value = 0
    for ____, card in ipairs(self.hand) do
        value = value + card.value
    end
    return value
end
function Character.prototype.removeAllCardsFromHand(self)
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
function Character.prototype.removeFromDeck(self, card)
    do
        local index = 0
        while index < #self.deck do
            local otherCard = self.deck[index + 1]
            if card:isEqual(otherCard) then
                __TS__ArraySplice(self.deck, index, 1)
            end
            index = index + 1
        end
    end
end
function Character.prototype.putHandBackInDeck(self)
    for ____, card in ipairs(self.hand) do
        self:addToDeck(card)
        if card.isSelected then
            card:onUnselect()
        end
    end
    self.hand = {}
end
return ____exports
