local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____Perk = require("Perk")
local Perk = ____Perk.default
local ____Card = require("Cards.Card")
local Card = ____Card.default
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
    self.hand = __TS__ArrayMap(
        data.hand,
        function(____, cardData) return Card:load(self.gameManager, cardData) end
    )
    self.deck = __TS__ArrayMap(
        data.deck,
        function(____, cardData) return Card:load(self.gameManager, cardData) end
    )
    self.discardPile = __TS__ArrayMap(
        data.discardPile,
        function(____, cardData) return Card:load(self.gameManager, cardData) end
    )
    self.perks = __TS__ArrayMap(
        data.perks,
        function(____, perkData) return Perk:load(self.gameManager, perkData) end
    )
end
function Player.prototype.save(self)
    return {
        name = self.name,
        money = self.money,
        experience = self.experience,
        level = self.level,
        discards = self.discards,
        numberOfLootCards = self.numberOfLootCards,
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
        perks = __TS__ArrayMap(
            self.perks,
            function(____, perk) return perk:save() end
        )
    }
end
function Player.prototype.setup(self)
    if #self.deck == 0 then
        Dealer:initializePlayerDeck(self.gameManager)
    end
end
function Player.prototype.removeSelectedCardsFromHand(self)
    do
        local i = #self.hand - 1
        while i >= 0 do
            local card = self.hand[i + 1]
            if card.isSelected then
                card.isSelected = false
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
        if card.isSelected then
            card.isSelected = false
            card:onUnselect()
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
        if card.isSelected then
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
        local ____switch38 = self.level
        local ____cond38 = ____switch38 == 1
        if ____cond38 then
            return 100
        end
        ____cond38 = ____cond38 or ____switch38 == 2
        if ____cond38 then
            return 150
        end
        ____cond38 = ____cond38 or ____switch38 == 3
        if ____cond38 then
            return 250
        end
        ____cond38 = ____cond38 or ____switch38 == 4
        if ____cond38 then
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
function Player.prototype.unselectCards(self)
    for ____, card in ipairs(self.hand) do
        if card.isSelected then
            card.isSelected = false
            card:onUnselect()
        end
    end
end
return ____exports
