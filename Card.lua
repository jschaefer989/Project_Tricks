local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local ____Enums = require("Enums")
local Ranks = ____Enums.Ranks
local Suits = ____Enums.Suits
____exports.default = __TS__Class()
local Card = ____exports.default
Card.name = "Card"
function Card.prototype.____constructor(self, suit, rank)
    self.suit = suit
    self.rank = rank
    self.power = self:getPower(suit, rank)
    self.value = self:getValue(rank)
    self.selected = false
    self.cost = self:getCost()
end
function Card.prototype.isEqual(self, otherCard)
    return self.suit == otherCard.suit and self.rank == otherCard.rank
end
function Card.prototype.getPower(self, suit, rank)
    if rank == Ranks.QUEEN or rank == Ranks.JACK or suit == Suits.DIAMONDS then
        if rank == Ranks.QUEEN then
            repeat
                local ____switch7 = suit
                local ____cond7 = ____switch7 == Suits.CLUBS
                if ____cond7 then
                    return 19
                end
                ____cond7 = ____cond7 or ____switch7 == Suits.SPADES
                if ____cond7 then
                    return 18
                end
                ____cond7 = ____cond7 or ____switch7 == Suits.HEARTS
                if ____cond7 then
                    return 17
                end
                ____cond7 = ____cond7 or ____switch7 == Suits.DIAMONDS
                if ____cond7 then
                    return 16
                end
            until true
        elseif rank == Ranks.JACK then
            repeat
                local ____switch9 = suit
                local ____cond9 = ____switch9 == Suits.CLUBS
                if ____cond9 then
                    return 15
                end
                ____cond9 = ____cond9 or ____switch9 == Suits.SPADES
                if ____cond9 then
                    return 14
                end
                ____cond9 = ____cond9 or ____switch9 == Suits.HEARTS
                if ____cond9 then
                    return 13
                end
                ____cond9 = ____cond9 or ____switch9 == Suits.DIAMONDS
                if ____cond9 then
                    return 12
                end
            until true
        elseif suit == Suits.DIAMONDS then
            repeat
                local ____switch11 = rank
                local ____cond11 = ____switch11 == Ranks.ACE
                if ____cond11 then
                    return 11
                end
                ____cond11 = ____cond11 or ____switch11 == Ranks.TEN
                if ____cond11 then
                    return 10
                end
                ____cond11 = ____cond11 or ____switch11 == Ranks.KING
                if ____cond11 then
                    return 9
                end
                ____cond11 = ____cond11 or ____switch11 == Ranks.NINE
                if ____cond11 then
                    return 8
                end
                ____cond11 = ____cond11 or ____switch11 == Ranks.EIGHT
                if ____cond11 then
                    return 7
                end
                ____cond11 = ____cond11 or ____switch11 == Ranks.SEVEN
                if ____cond11 then
                    return 6
                end
            until true
        end
    end
    repeat
        local ____switch12 = rank
        local ____cond12 = ____switch12 == Ranks.ACE
        if ____cond12 then
            return 5
        end
        ____cond12 = ____cond12 or ____switch12 == Ranks.TEN
        if ____cond12 then
            return 4
        end
        ____cond12 = ____cond12 or ____switch12 == Ranks.KING
        if ____cond12 then
            return 3
        end
        ____cond12 = ____cond12 or ____switch12 == Ranks.QUEEN
        if ____cond12 then
            return 2
        end
        ____cond12 = ____cond12 or ____switch12 == Ranks.JACK
        if ____cond12 then
            return 1
        end
        do
            return 0
        end
    until true
end
function Card.prototype.getValue(self, rank)
    repeat
        local ____switch14 = rank
        local ____cond14 = ____switch14 == Ranks.ACE
        if ____cond14 then
            return 11
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.TEN
        if ____cond14 then
            return 10
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.KING
        if ____cond14 then
            return 4
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.QUEEN
        if ____cond14 then
            return 3
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.JACK
        if ____cond14 then
            return 2
        end
        do
            return 0
        end
    until true
end
function Card.prototype.getCost(self)
    local cost = 0
    cost = cost + self:getBaseCost()
    return cost
end
function Card.prototype.getBaseCost(self)
    local cost = 10
    repeat
        local ____switch17 = self.rank
        local ____cond17 = ____switch17 == Ranks.SEVEN
        if ____cond17 then
            cost = cost * 1
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.EIGHT
        if ____cond17 then
            cost = cost * 1
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.NINE
        if ____cond17 then
            cost = cost * 1
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.KING
        if ____cond17 then
            cost = cost + 2
            cost = cost * 2
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.TEN
        if ____cond17 then
            cost = cost * 3
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.JACK
        if ____cond17 then
            cost = cost * 3
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.QUEEN
        if ____cond17 then
            cost = cost * 4
            break
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.ACE
        if ____cond17 then
            cost = cost * 4
            break
        end
        do
            exhaustiveGuard(self.rank)
        end
    until true
    repeat
        local ____switch18 = self.suit
        local ____cond18 = ____switch18 == Suits.DIAMONDS
        if ____cond18 then
            cost = cost * 2
            break
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.CLUBS
        if ____cond18 then
            cost = cost * 1
            break
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.HEARTS
        if ____cond18 then
            cost = cost * 1
            break
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.SPADES
        if ____cond18 then
            cost = cost * 1
            break
        end
    until true
    return cost
end
return ____exports
