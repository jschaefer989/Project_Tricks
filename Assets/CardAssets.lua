local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Enums = require("Enums")
local Suits = ____Enums.Suits
local AssetIds = ____Enums.AssetIds
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local push = require("Libraries.push")
local padding = 20
____exports.default = __TS__Class()
local CardAssets = ____exports.default
CardAssets.name = "CardAssets"
function CardAssets.prototype.____constructor(self, gameManager)
    self.baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png")
    self.baseW = self.baseCard:getWidth()
    self.baseH = self.baseCard:getHeight()
    self.gameManager = gameManager
end
function CardAssets.prototype.addAsset(self, card, cardX, cardY, options)
    local assetId = (AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id
    self.gameManager.assetManager:addAsset(
        assetId,
        __TS__New(
            Asset,
            self.baseCard,
            cardX,
            cardY,
            card.onClick,
            self.baseW,
            self.baseH
        )
    )
    self:addSuitAsset(
        card,
        cardX,
        cardY,
        self.baseW,
        self.baseH
    )
end
function CardAssets.prototype.addSuitAsset(self, card, x, y, width, height)
    local suitImagePath = self:getSuitAssetPath(card.suit)
    self.gameManager.assetManager:addAsset(
        self:getSuitAssetId(card.suit, card, 0),
        __TS__New(
            Asset,
            love.graphics.newImage(suitImagePath),
            x + 10,
            y + 10,
            card.onClick,
            width,
            height
        )
    )
    local flippedX = x + width - 10
    local flippedY = y + height - 10
    self.gameManager.assetManager:addAsset(
        self:getSuitAssetId(card.suit, card, 1),
        __TS__New(
            Asset,
            love.graphics.newImage(suitImagePath),
            flippedX,
            flippedY,
            card.onClick,
            width,
            height,
            0,
            -1,
            -1
        )
    )
end
function CardAssets.prototype.getSuitAssetPath(self, suit)
    repeat
        local ____switch6 = suit
        local ____cond6 = ____switch6 == Suits.HEARTS
        if ____cond6 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond6 = ____cond6 or ____switch6 == Suits.BELLS
        if ____cond6 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond6 = ____cond6 or ____switch6 == Suits.ACORNS
        if ____cond6 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond6 = ____cond6 or ____switch6 == Suits.LEAVES
        if ____cond6 then
            return "Assets/Images/LeafSuit.png"
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
function CardAssets.prototype.getSuitAssetId(self, suit, card, orientation)
    repeat
        local ____switch8 = suit
        local ____cond8 = ____switch8 == Suits.HEARTS
        if ____cond8 then
            return (((AssetIds.HEART_SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
        end
        ____cond8 = ____cond8 or ____switch8 == Suits.BELLS
        if ____cond8 then
            return (((AssetIds.BELL_SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
        end
        ____cond8 = ____cond8 or ____switch8 == Suits.ACORNS
        if ____cond8 then
            return (((AssetIds.ACORN_SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
        end
        ____cond8 = ____cond8 or ____switch8 == Suits.LEAVES
        if ____cond8 then
            return (((AssetIds.LEAF_SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
function CardAssets.prototype.hideCardAssets(self, card)
    self.gameManager.assetManager.assets:delete((AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id)
    self.gameManager.assetManager.assets:delete(self:getSuitAssetId(card.suit, card, 0))
    self.gameManager.assetManager.assets:delete(self:getSuitAssetId(card.suit, card, 1))
end
function CardAssets.prototype.centerCards(self)
    local playerHand = self.gameManager.player.hand
    local cardCount = #playerHand
    local screenW = push:getWidth()
    local totalW = cardCount * self.baseW + math.max(0, cardCount - 1) * padding
    local startX = math.floor((screenW - totalW) / 2)
    local cardY = self:getCardPosition()
    do
        local i = 0
        while i < #playerHand do
            local card = playerHand[i + 1]
            local x = startX + i * (self.baseW + padding)
            self:addAsset(card, x, cardY)
            i = i + 1
        end
    end
end
function CardAssets.prototype.updateCardPosition(self, card, x, y)
    local assetManager = self.gameManager.assetManager
    local ____opt_0 = assetManager:getAsset((AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id)
    if ____opt_0 ~= nil then
        ____opt_0:updatePosition(x, y)
    end
    local ____opt_2 = assetManager:getAsset(self:getSuitAssetId(card.suit, card, 0))
    if ____opt_2 ~= nil then
        ____opt_2:updatePosition(x + 10, y + 10)
    end
    local ____opt_4 = assetManager:getAsset(self:getSuitAssetId(card.suit, card, 1))
    if ____opt_4 ~= nil then
        ____opt_4:updatePosition(x + self.baseW - 10, y + self.baseH - 10)
    end
end
function CardAssets.prototype.getCardPosition(self)
    local screenH = push:getHeight()
    return screenH / 2 + self.baseH / 2
end
function CardAssets.prototype.appendAsset(self, card)
    local playerHand = self.gameManager.player.hand
    local cardCount = #playerHand
    local screenW = push:getWidth()
    local totalW = cardCount * self.baseW + math.max(0, cardCount - 1) * padding
    local startX = math.floor((screenW - totalW) / 2)
    local cardY = self:getCardPosition()
    local x = startX + (cardCount - 1) * (self.baseW + padding)
    self:addAsset(card, x, cardY)
end
return ____exports
