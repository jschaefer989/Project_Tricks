local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
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
function Character.prototype.addToHand(self, card)
    local ____self_hand_0 = self.hand
    ____self_hand_0[#____self_hand_0 + 1] = card
    local ____opt_1 = self.gameManager.board
    if ____opt_1 ~= nil then
        ____opt_1.cardAssets:appendAsset(card, self.type)
    end
end
function Character.prototype.getCardFromHand(self, position)
    return self.hand[position + 1]
end
function Character.prototype.addToDeck(self, card)
    local ____self_deck_3 = self.deck
    ____self_deck_3[#____self_deck_3 + 1] = card
    local ____opt_4 = self.gameManager.board
    if ____opt_4 ~= nil then
        ____opt_4.cardAssets:removeCardAssets(card)
    end
end
function Character.prototype.getCardFromDeck(self, position)
    return self.deck[position + 1]
end
function Character.prototype.addToDiscards(self, card)
    local ____self_discardPile_6 = self.discardPile
    ____self_discardPile_6[#____self_discardPile_6 + 1] = card
    local ____opt_7 = self.gameManager.board
    if ____opt_7 ~= nil then
        ____opt_7.cardAssets:removeCardAssets(card)
    end
end
function Character.prototype.getCardFromDiscards(self, position)
    return self.discardPile[position + 1]
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
    local board = self.gameManager.board
    for ____, card in ipairs(self.hand) do
        local ____self_deck_9 = self.deck
        ____self_deck_9[#____self_deck_9 + 1] = card
        if board ~= nil then
            board.cardAssets:removeCardAssets(card)
        end
    end
    self.hand = {}
end
return ____exports
