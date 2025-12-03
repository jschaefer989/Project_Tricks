require "Character"
Player = Character:extend()

function Player:new()
    Player.super.new(self)
    self.name = "Player"
    self.money = 0
    self.experience = 0
    self.level = 1
    self.discards = 3
end

function Player:getCardPower()
    local power = 0
    for i, card in ipairs(self.hand) do
        if card.selected then
            power = power + card.power
        end
    end
    return power
end

function Player:getCardValue()
    local value = 0
    for i, card in ipairs(self.hand) do
        if card.selected then
            value = value + card.value
        end
    end
    return value
end

function Player:removeSelectedCardsFromHand()
    for i = #self.hand, 1, -1 do
        local card = self.hand[i]
        if card.selected then
            self:addToDiscards(card)
            table.remove(self.hand, i)
        end
    end
end

function Player:discard()
    local newHand = {}

    for i, card in ipairs(self.hand) do
        if card.selected then
            card.selected = false
            table.insert(self.discardPile, card)
        else
            table.insert(newHand, card)
        end
    end

    self.hand = newHand
end

function Player:anySelectedCards()
    for i, card in ipairs(self.hand) do
        if card.selected then
            return true
        end
    end
    return false
end

function Player:cashout(points)
    if points < 0 then return end
    self.money = self.money + points
end
