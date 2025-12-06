local object = require('Libraries.classic-master.classic')
Character = object:extend()

function Character:new()
    self.deck = { }
    self.hand = { }
    self.discardPile = { }
    self.numberOfHeldCards = 5
end

function Character:addToHand(card)
    table.insert(self.hand, card)
end

function Character:getCardFromHand(position)
    return self.hand[position]
end

function Character:addToDeck(card)
    table.insert(self.deck, card)
end

function Character:getCardFromDeck(position)
    return self.deck[position]
end 

function Character:addToDiscards(card)
    table.insert(self.discardPile, card)
end

function Character:getCardFromDiscards(position)
    return self.discardPile[position]
end

function Character:addDiscardsToDeck()
    for i, card in ipairs(self.discardPile) do
        self:addToDeck(card)
    end
    self.discardPile = {}
end
