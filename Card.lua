local object = require('Libraries.classic-master.classic')
Card = object:extend()

function Card:new(suit, rank)
    self.suit = suit
    self.rank = rank
    self.power = self:getPower(suit, rank)
    self.value = self:getValue(rank)
    self.selected = false
end

function Card:getPower(suit, rank)
    -- Handle trump cards
    if rank == Ranks.QUEEN or rank == Ranks.JACK or suit == Suits.DIAMONDS then
        if rank == Ranks.QUEEN then
            if suit == Suits.HEARTS then
                return 19
            elseif suit == Suits.SPADES then
                return 18
            elseif suit == Suits.CLUBS then
                return 17
            elseif suit == Suits.DIAMONDS then
                return 16
            end
        elseif rank == Ranks.JACK then
            if suit == Suits.HEARTS then
                return 15
            elseif suit == Suits.SPADES then
                return 14
            elseif suit == Suits.CLUBS then
                return 13
            elseif suit == Suits.DIAMONDS then
                return 12
            end
        elseif suit == Suits.DIAMONDS then
            if rank == Ranks.ACE then
                return 11
            elseif rank == Ranks.TEN then
                return 10
            elseif rank == Ranks.KING then
                return 9
            elseif rank == Ranks.NINE then
                return 8
            elseif rank == Ranks.EIGHT then
                return 7
            elseif rank == Ranks.SEVEN then
                return 6
            end
        end
    -- Other cards have the samee power regardless of suit
    else
        if rank == Ranks.ACE then
            return 5
        elseif rank == Ranks.TEN then
            return 4
        elseif rank == Ranks.KING then
            return 3
        elseif rank == Ranks.NINE then
            return 2
        elseif rank == Ranks.EIGHT then
            return 1
        elseif rank == Ranks.SEVEN then
            return 0
        end
    end
end

function Card:getValue(rank)
    if rank == Ranks.ACE then
        return 11
    elseif rank == Ranks.TEN then
        return 10
    elseif rank == Ranks.KING then
        return 4
    elseif rank == Ranks.QUEEN then
        return 3
    elseif rank == Ranks.JACK then
        return 2
    else
        return 0
    end
end