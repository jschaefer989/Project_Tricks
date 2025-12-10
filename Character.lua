local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Character = ____exports.default
Character.name = "Character"
function Character.prototype.____constructor(self)
    self.deck = {}
    self.hand = {}
    self.discardPile = {}
    self.numberOfHeldCards = 5
end
function Character.prototype.addToHand(self, card)
    local ____self_hand_0 = self.hand
    ____self_hand_0[#____self_hand_0 + 1] = card
end
function Character.prototype.getCardFromHand(self, position)
    return self.hand[position + 1]
end
function Character.prototype.addToDeck(self, card)
    local ____self_deck_1 = self.deck
    ____self_deck_1[#____self_deck_1 + 1] = card
end
function Character.prototype.getCardFromDeck(self, position)
    return self.deck[position + 1]
end
function Character.prototype.addToDiscards(self, card)
    local ____self_discardPile_2 = self.discardPile
    ____self_discardPile_2[#____self_discardPile_2 + 1] = card
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
return ____exports
