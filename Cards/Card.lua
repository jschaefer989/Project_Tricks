local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____Hoverable = require("Hoverable")
local Hoverable = ____Hoverable.default
____exports.default = __TS__Class()
local Card = ____exports.default
Card.name = "Card"
__TS__ClassExtends(Card, Hoverable)
function Card.prototype.____constructor(self, gameManager, suit, rank, power, value, name, isTrump)
    local id = (((suit .. "_") .. rank) .. "_") .. tostring(love.math.random(1000))
    Hoverable.prototype.____constructor(self, id)
    self.isSelected = false
    self.isTrump = false
    self.isHovered = false
    self.gameManager = gameManager
    self.suit = suit
    self.rank = rank
    self.power = power
    self.value = value
    self.cost = self:getCost()
    local ____isTrump_0 = isTrump
    if ____isTrump_0 == nil then
        ____isTrump_0 = false
    end
    self.isTrump = ____isTrump_0
    self.name = name
    self.id = id
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
function Card.prototype.onClick(self)
    if self.isSelected then
        self.isSelected = false
        self:onUnselect()
    else
        self.isSelected = true
        self:onSelect()
    end
end
function Card.prototype.onSelect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_1, ____playerPower_2 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_1[____playerPower_2] = ____self_gameManager_board_1[____playerPower_2] + self.power
    local ____self_gameManager_board_3, ____playerValue_4 = self.gameManager.board, "playerValue"
    ____self_gameManager_board_3[____playerValue_4] = ____self_gameManager_board_3[____playerValue_4] + self.value
end
function Card.prototype.onUnselect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____self_gameManager_board_5, ____playerPower_6 = self.gameManager.board, "playerPower"
    ____self_gameManager_board_5[____playerPower_6] = ____self_gameManager_board_5[____playerPower_6] - self.power
    local ____self_gameManager_board_7, ____playerValue_8 = self.gameManager.board, "playerValue"
    ____self_gameManager_board_7[____playerValue_8] = ____self_gameManager_board_7[____playerValue_8] - self.value
end
function Card.onHover(self, gameManager, asset)
    local tooltipMaxWidth = 200
    local padding = 20
    local bgPadding = 8
    local cardId = __TS__StringSplit(asset.id, "-")[2]
    local card = gameManager:getCard(cardId)
    local font = love.graphics.getFont()
    if isEmpty(card) or isEmpty(font) then
        return
    end
    local screenW = love.graphics.getWidth()
    local defaultX = asset.x + asset.width + padding
    local placeRight = defaultX + tooltipMaxWidth <= screenW - padding
    local tooltipX = placeRight and defaultX or math.max(padding, asset.x - padding - tooltipMaxWidth)
    local tooltipY = asset.y
    local lineHeight = font:getHeight()
    local bgX = tooltipX - bgPadding
    local bgY = tooltipY - bgPadding
    local bgW = tooltipMaxWidth + bgPadding * 2
    local bgH = lineHeight * 4 + bgPadding * 2
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle(
        "fill",
        bgX,
        bgY,
        bgW,
        bgH
    )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle(
        "line",
        bgX,
        bgY,
        bgW,
        bgH
    )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(
        card.name,
        tooltipX,
        tooltipY,
        tooltipMaxWidth,
        "left"
    )
    love.graphics.printf(
        card.suit,
        tooltipX,
        tooltipY,
        tooltipMaxWidth,
        "right"
    )
    love.graphics.printf(
        "Power: " .. tostring(card.power),
        tooltipX,
        tooltipY + 20,
        tooltipMaxWidth,
        "left"
    )
    love.graphics.printf(
        "Value: " .. tostring(card.value),
        tooltipX,
        tooltipY + 40,
        tooltipMaxWidth,
        "left"
    )
end
return ____exports
