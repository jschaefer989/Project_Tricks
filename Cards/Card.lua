local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Card = ____exports.default
Card.name = "Card"
function Card.prototype.____constructor(self, gameManager, suit, rank, power, value, name, isTrump)
    if isTrump == nil then
        isTrump = false
    end
    self.gameManager = gameManager
    self.suit = suit
    self.rank = rank
    self.power = power
    self.value = value
    self.cost = self:getCost()
    self.isSelected = false
    self.isTrump = isTrump
    self.name = name
    self.id = (self.suit .. "-") .. self.rank
end
function Card.prototype.isEqual(self, otherCard)
    return self.id == otherCard.id
end
function Card.prototype.getCost(self)
    local cost = 0
    cost = cost + self:getBaseCost()
    return cost
end
function Card.prototype.getBaseCost(self)
    return self.power * 10 + self.value * 5
end
function Card.prototype.save(self)
    return {
        id = self.id,
        suit = self.suit,
        rank = self.rank,
        power = self.power,
        value = self.value,
        isSelected = self.isSelected,
        cost = self.cost,
        isTrump = self.isTrump,
        name = self.name
    }
end
function Card.load(self, gameManager, data)
    local card = __TS__New(
        ____exports.default,
        gameManager,
        data.suit,
        data.rank,
        data.power,
        data.value,
        data.name,
        data.isTrump
    )
    card.id = data.id
    card.isSelected = data.isSelected
    card.cost = data.cost
    return card
end
function Card.prototype.onSelect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_0, ____playerPower_1 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_0[____playerPower_1] = ____self_gameManager_board_0[____playerPower_1] + self.power
    local ____self_gameManager_board_2, ____playerValue_3 = self.gameManager.board, "playerValue"
    ____self_gameManager_board_2[____playerValue_3] = ____self_gameManager_board_2[____playerValue_3] + self.value
end
function Card.prototype.onUnselect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_4, ____playerPower_5 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_4[____playerPower_5] = ____self_gameManager_board_4[____playerPower_5] - self.power
    local ____self_gameManager_board_6, ____playerValue_7 = self.gameManager.board, "playerValue"
    ____self_gameManager_board_6[____playerValue_7] = ____self_gameManager_board_6[____playerValue_7] - self.value
end
return ____exports
