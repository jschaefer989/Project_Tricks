local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Card = require("Cards.Card")
local Card = ____Card.default
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Enums = require("Enums")
local Suits = ____Enums.Suits
local AssetIds = ____Enums.AssetIds
local Ranks = ____Enums.Ranks
local TrumpRanks = ____Enums.TrumpRanks
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local push = require("Libraries.push")
local ____Hoverable = require("Hoverable")
local Hoverable = ____Hoverable.default
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
    local assetId = ____exports.default:getCardAssetId(card)
    local hoverable = __TS__New(Hoverable, card.id)
    local baseCardAsset = __TS__New(
        Asset,
        assetId,
        self.baseCard,
        cardX,
        cardY,
        card.onClick,
        function(____, gameManager, asset) return Card:onHover(gameManager, asset) end,
        self.baseW,
        self.baseH
    )
    baseCardAsset:setHoverable(hoverable)
    self.gameManager.assetManager:addAsset(assetId, baseCardAsset)
    self:addSuitAsset(
        card,
        cardX,
        cardY,
        self.baseW,
        self.baseH,
        hoverable
    )
    self:addRankAsset(
        card,
        cardX,
        cardY,
        self.baseW,
        self.baseH,
        hoverable
    )
end
function CardAssets.getCardAssetId(self, card)
    return (AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id
end
function CardAssets.prototype.addSuitAsset(self, card, x, y, width, height, hoverable)
    local suitImagePath = ____exports.default:getSuitAssetPath(card.suit)
    local function onHoverCallback(____, gameManager, asset)
        return Card:onHover(gameManager, asset)
    end
    local normalAssetId = ____exports.default:getSuitAssetId(card, 0)
    local normalAsset = __TS__New(
        Asset,
        normalAssetId,
        love.graphics.newImage(suitImagePath),
        x + 10,
        y + 10,
        card.onClick,
        onHoverCallback,
        width,
        height
    )
    self.gameManager.assetManager:addAsset(normalAssetId, normalAsset)
    normalAsset:setHoverable(hoverable)
    local flippedX = x + width - 10
    local flippedY = y + height - 10
    local flippedAssetId = ____exports.default:getSuitAssetId(card, 1)
    local flippedAsset = __TS__New(
        Asset,
        flippedAssetId,
        love.graphics.newImage(suitImagePath),
        flippedX,
        flippedY,
        card.onClick,
        onHoverCallback,
        width,
        height,
        0,
        -1,
        -1
    )
    self.gameManager.assetManager:addAsset(flippedAssetId, flippedAsset)
    flippedAsset:setHoverable(hoverable)
end
function CardAssets.prototype.addRankAsset(self, card, x, y, width, height, hoverable)
    local rankImagePath = ____exports.default:getRankAssetPath(card.rank)
    local rankImage = love.graphics.newImage(rankImagePath)
    local rankW = rankImage:getWidth()
    local rankH = rankImage:getHeight()
    local assetId = ____exports.default:getRankAssetId(card, 0)
    local asset = __TS__New(
        Asset,
        assetId,
        rankImage,
        x + self.baseW / 2 - rankW / 2,
        y + self.baseH / 2 - rankH / 2,
        card.onClick,
        function(____, gameManager, asset) return Card:onHover(gameManager, asset) end,
        width,
        height
    )
    self.gameManager.assetManager:addAsset(assetId, asset)
    asset:setHoverable(hoverable)
end
function CardAssets.getSuitAssetPath(self, suit)
    repeat
        local ____switch11 = suit
        local ____cond11 = ____switch11 == Suits.HEARTS
        if ____cond11 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond11 = ____cond11 or ____switch11 == Suits.BELLS
        if ____cond11 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond11 = ____cond11 or ____switch11 == Suits.ACORNS
        if ____cond11 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond11 = ____cond11 or ____switch11 == Suits.LEAVES
        if ____cond11 then
            return "Assets/Images/LeafSuit.png"
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
function CardAssets.getSuitAssetId(self, card, orientation)
    return (((AssetIds.SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
end
function CardAssets.getRankAssetPath(self, rank)
    repeat
        local ____switch14 = rank
        local ____cond14 = ____switch14 == Ranks.BANNER
        if ____cond14 then
            return "Assets/Images/BannerRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.BARON
        if ____cond14 then
            return "Assets/Images/BaronRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.DEUCE
        if ____cond14 then
            return "Assets/Images/DeuceRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.JESTER
        if ____cond14 then
            return "Assets/Images/JesterRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.KING
        if ____cond14 then
            return "Assets/Images/KingRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.OVERLORD
        if ____cond14 then
            return "Assets/Images/OverlordRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.PRIEST
        if ____cond14 then
            return "Assets/Images/PriestRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.SERGEANT
        if ____cond14 then
            return "Assets/Images/SergeantRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.SOLDIER
        if ____cond14 then
            return "Assets/Images/SoldierRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Ranks.THIEF
        if ____cond14 then
            return "Assets/Images/ThiefRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.BARD
        if ____cond14 then
            return "Assets/Images/BardRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.CHOSEN
        if ____cond14 then
            return "Assets/Images/ChosenRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.DEVIL
        if ____cond14 then
            return "Assets/Images/DevilRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.DUKE
        if ____cond14 then
            return "Assets/Images/DukeRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.EMPEROR
        if ____cond14 then
            return "Assets/Images/EmperorRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.POPE
        if ____cond14 then
            return "Assets/Images/PopeRank.png"
        end
        ____cond14 = ____cond14 or ____switch14 == TrumpRanks.KNIGHT
        if ____cond14 then
            return "Assets/Images/KnightRank.png"
        end
        do
            exhaustiveGuard(rank)
        end
    until true
end
function CardAssets.getRankAssetId(self, card, orientation)
    return (((AssetIds.RANK .. "-") .. card.id) .. "-") .. tostring(orientation)
end
function CardAssets.prototype.hideCardAssets(self, card)
    self.gameManager.assetManager.assets:delete(____exports.default:getCardAssetId(card))
    self.gameManager.assetManager.assets:delete(____exports.default:getSuitAssetId(card, 0))
    self.gameManager.assetManager.assets:delete(____exports.default:getSuitAssetId(card, 1))
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
            self:updateCardPosition(card, x, cardY)
            i = i + 1
        end
    end
end
function CardAssets.prototype.updateCardPosition(self, card, x, y)
    local assetManager = self.gameManager.assetManager
    local ____opt_0 = assetManager:getAsset(____exports.default:getCardAssetId(card))
    if ____opt_0 ~= nil then
        ____opt_0:updatePosition(x, y)
    end
    local ____opt_2 = assetManager:getAsset(____exports.default:getSuitAssetId(card, 0))
    if ____opt_2 ~= nil then
        ____opt_2:updatePosition(x + 10, y + 10)
    end
    local ____opt_4 = assetManager:getAsset(____exports.default:getSuitAssetId(card, 1))
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
