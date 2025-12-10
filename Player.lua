local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Character = require("Character")
local Character = ____Character.default
____exports.default = __TS__Class()
local Player = ____exports.default
Player.name = "Player"
__TS__ClassExtends(Player, Character)
function Player.prototype.____constructor(self)
    Character.prototype.____constructor(self)
    self.name = "Player"
    self.money = 0
    self.experience = 0
    self.level = 1
    self.discards = 3
    self.numberOfLootCards = 3
end
function Player.prototype.load(self, data)
    self.name = data.name or "Player"
    self.money = data.money or 0
    self.experience = data.experience or 0
    self.level = data.level or 1
    self.discards = data.discards or 3
    self.numberOfLootCards = data.numberOfLootCards or 3
    self.hand = data.hand or ({})
    self.deck = data.deck or ({})
    self.discardPile = data.discardPile or ({})
end
function Player.prototype.save(self)
    return {
        name = self.name,
        money = self.money,
        experience = self.experience,
        level = self.level,
        discards = self.discards,
        numberOfLootCards = self.numberOfLootCards,
        hand = self.hand,
        deck = self.deck,
        discardPile = self.discardPile
    }
end
function Player.prototype.getCardPower(self)
    local power = 0
    for ____, card in ipairs(self.hand) do
        if card.selected then
            power = power + card.power
        end
    end
    return power
end
function Player.prototype.getCardValue(self)
    local value = 0
    for ____, card in ipairs(self.hand) do
        if card.selected then
            value = value + card.value
        end
    end
    return value
end
function Player.prototype.removeSelectedCardsFromHand(self)
    do
        local i = #self.hand - 1
        while i >= 0 do
            local card = self.hand[i + 1]
            if card.selected then
                self:addToDiscards(card)
                __TS__ArraySplice(self.hand, i, 1)
            end
            i = i - 1
        end
    end
end
function Player.prototype.discard(self)
    local newHand = {}
    for ____, card in ipairs(self.hand) do
        if card.selected then
            card.selected = false
            local ____self_discardPile_0 = self.discardPile
            ____self_discardPile_0[#____self_discardPile_0 + 1] = card
        else
            newHand[#newHand + 1] = card
        end
    end
    self.hand = newHand
end
function Player.prototype.anySelectedCards(self)
    for ____, card in ipairs(self.hand) do
        if card.selected then
            return true
        end
    end
    return false
end
function Player.prototype.cashout(self, points)
    if points < 0 then
        return
    end
    self.money = self.money + points
end
function Player.prototype.deselectAllCards(self)
    for ____, card in ipairs(self.hand) do
        card.selected = false
    end
end
return ____exports
