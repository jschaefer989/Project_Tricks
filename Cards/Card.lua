local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
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
function Card.prototype.onSelect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_0, ____playerPower_1 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_0[____playerPower_1] = ____self_gameManager_board_0[____playerPower_1] + self.power
end
function Card.prototype.onUnselect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_2, ____playerPower_3 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_2[____playerPower_3] = ____self_gameManager_board_2[____playerPower_3] - self.power
end
return ____exports
