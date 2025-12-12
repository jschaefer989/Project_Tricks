local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Character = require("Character")
local Character = ____Character.default
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
____exports.default = __TS__Class()
local Player = ____exports.default
Player.name = "Player"
__TS__ClassExtends(Player, Character)
function Player.prototype.____constructor(self, gameManager)
    Character.prototype.____constructor(self)
    self.gameManager = gameManager
    self.name = "Player"
    self.money = 0
    self.experience = 0
    self.level = 1
    self.discards = 3
    self.numberOfLootCards = 3
    self.perks = {}
end
function Player.prototype.load(self, data)
    self.name = data.name
    self.money = data.money
    self.experience = data.experience
    self.level = data.level
    self.discards = data.discards
    self.numberOfLootCards = data.numberOfLootCards
    self.hand = data.hand
    self.deck = data.deck
    self.discardPile = data.discardPile
    self.perks = data.perks
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
        discardPile = self.discardPile,
        perks = self.perks
    }
end
function Player.prototype.setup(self)
    if #self.deck == 0 then
        Dealer:initializePlayerDeck(self.gameManager)
    end
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
                card.selected = false
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
function Player.prototype.hasPerk(self, perkType)
    for ____, perk in ipairs(self.perks) do
        if perk.perkType == perkType then
            return true
        end
    end
    return false
end
function Player.prototype.addPerk(self, perk)
    local ____self_perks_1 = self.perks
    ____self_perks_1[#____self_perks_1 + 1] = perk
end
function Player.prototype.gatherExperience(self, exp)
    self.experience = self.experience + exp
    if self.experience >= self:getNextLevelExperience() then
        self:levelUp()
        return true
    end
    return false
end
function Player.prototype.getNextLevelExperience(self)
    repeat
        local ____switch41 = self.level
        local ____cond41 = ____switch41 == 1
        if ____cond41 then
            return 100
        end
        ____cond41 = ____cond41 or ____switch41 == 2
        if ____cond41 then
            return 150
        end
        ____cond41 = ____cond41 or ____switch41 == 3
        if ____cond41 then
            return 250
        end
        ____cond41 = ____cond41 or ____switch41 == 4
        if ____cond41 then
            return 500
        end
        do
            return 1000
        end
    until true
end
function Player.prototype.levelUp(self)
    self.experience = 0
    self.level = self.level + 1
end
return ____exports
