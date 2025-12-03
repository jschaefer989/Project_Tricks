require "Character"
Enemy = Character:extend()

function Enemy:new(numberOfHeldCards, numberOfCardsInDeck)
    Enemy.super.new(self)
    self.numberOfHeldCards = numberOfHeldCards or 3
    self.numberOfCardsInDeck = numberOfCardsInDeck or 9
end

function Enemy:getCardPower()
    local power = 0
    for i, card in ipairs(self.hand) do
        power = power + card.power
    end
    return power
end

function Enemy:getCardValue()
    local value = 0
    for i, card in ipairs(self.hand) do
        value = value + card.value
    end
    return value
end

function Enemy:removeAllCardsFromHand()
    for i = #self.hand, 1, -1 do
        local card = self.hand[i]
        self:addToDiscards(card)
        table.remove(self.hand, i)
    end
end
