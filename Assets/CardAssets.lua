local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
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
    self:addRankAsset(
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
        self:getSuitAssetId(card, 0),
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
        self:getSuitAssetId(card, 1),
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
function CardAssets.prototype.addRankAsset(self, card, x, y, width, height)
    local rankImagePath = self:getRankAssetPath(card.rank)
    local rankImage = love.graphics.newImage(rankImagePath)
    local rankW = rankImage:getWidth()
    local rankH = rankImage:getHeight()
    self.gameManager.assetManager:addAsset(
        self:getRankAssetId(card, 0),
        __TS__New(
            Asset,
            rankImage,
            x + self.baseW / 2 - rankW / 2,
            y + self.baseH / 2 - rankH / 2,
            card.onClick,
            width,
            height
        )
    )
end
function CardAssets.prototype.getSuitAssetPath(self, suit)
    repeat
        local ____switch7 = suit
        local ____cond7 = ____switch7 == Suits.HEARTS
        if ____cond7 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond7 = ____cond7 or ____switch7 == Suits.BELLS
        if ____cond7 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond7 = ____cond7 or ____switch7 == Suits.ACORNS
        if ____cond7 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond7 = ____cond7 or ____switch7 == Suits.LEAVES
        if ____cond7 then
            return "Assets/Images/LeafSuit.png"
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
function CardAssets.prototype.getSuitAssetId(self, card, orientation)
    return (((AssetIds.SUIT .. "-") .. card.id) .. "-") .. tostring(orientation)
end
function CardAssets.prototype.getRankAssetPath(self, rank)
    repeat
        local ____switch10 = rank
        local ____cond10 = ____switch10 == Ranks.BANNER
        if ____cond10 then
            return "Assets/Images/BannerRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.BARON
        if ____cond10 then
            return "Assets/Images/BaronRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.DEUCE
        if ____cond10 then
            return "Assets/Images/DeuceRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.JESTER
        if ____cond10 then
            return "Assets/Images/JesterRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.KING
        if ____cond10 then
            return "Assets/Images/KingRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.OVERLORD
        if ____cond10 then
            return "Assets/Images/OverlordRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.PRIEST
        if ____cond10 then
            return "Assets/Images/PriestRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.SERGEANT
        if ____cond10 then
            return "Assets/Images/SergeantRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.SOLDIER
        if ____cond10 then
            return "Assets/Images/SoldierRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == Ranks.THIEF
        if ____cond10 then
            return "Assets/Images/ThiefRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.BARD
        if ____cond10 then
            return "Assets/Images/BardRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.CHOSEN
        if ____cond10 then
            return "Assets/Images/ChosenRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.DEVIL
        if ____cond10 then
            return "Assets/Images/DevilRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.DUKE
        if ____cond10 then
            return "Assets/Images/DukeRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.EMPEROR
        if ____cond10 then
            return "Assets/Images/EmperorRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.POPE
        if ____cond10 then
            return "Assets/Images/PopeRank.png"
        end
        ____cond10 = ____cond10 or ____switch10 == TrumpRanks.KNIGHT
        if ____cond10 then
            return "Assets/Images/KnightRank.png"
        end
        do
            exhaustiveGuard(rank)
        end
    until true
end
function CardAssets.prototype.getRankAssetId(self, card, orientation)
    return (((AssetIds.RANK .. "-") .. card.id) .. "-") .. tostring(orientation)
end
function CardAssets.prototype.hideCardAssets(self, card)
    self.gameManager.assetManager.assets:delete((AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id)
    self.gameManager.assetManager.assets:delete(self:getSuitAssetId(card, 0))
    self.gameManager.assetManager.assets:delete(self:getSuitAssetId(card, 1))
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
    local ____opt_0 = assetManager:getAsset((AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id)
    if ____opt_0 ~= nil then
        ____opt_0:updatePosition(x, y)
    end
    local ____opt_2 = assetManager:getAsset(self:getSuitAssetId(card, 0))
    if ____opt_2 ~= nil then
        ____opt_2:updatePosition(x + 10, y + 10)
    end
    local ____opt_4 = assetManager:getAsset(self:getSuitAssetId(card, 1))
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
