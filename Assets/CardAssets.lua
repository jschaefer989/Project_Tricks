local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
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
local CharacterTypes = ____Enums.CharacterTypes
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
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
    local assetId = ____exports.default:getCardAssetId(card)
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
    baseCardAsset:setHoverable(card)
    self.gameManager.assetManager:addAsset(assetId, baseCardAsset)
    self:addSuitAsset(
        card,
        cardX,
        cardY,
        self.baseW,
        self.baseH,
        card
    )
    self:addRankAsset(
        card,
        cardX,
        cardY,
        self.baseW,
        self.baseH,
        card
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
    local normalPosition = self:getNormalSuitPosition(x, y)
    local normalAsset = __TS__New(
        Asset,
        normalAssetId,
        love.graphics.newImage(suitImagePath),
        normalPosition.x,
        normalPosition.y,
        card.onClick,
        onHoverCallback,
        width,
        height
    )
    self.gameManager.assetManager:addAsset(normalAssetId, normalAsset)
    normalAsset:setHoverable(hoverable)
    local flippedPosition = self:getFlippedSuitPosition(x, y)
    local flippedAssetId = ____exports.default:getSuitAssetId(card, 1)
    local flippedAsset = __TS__New(
        Asset,
        flippedAssetId,
        love.graphics.newImage(suitImagePath),
        flippedPosition.x,
        flippedPosition.y,
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
function CardAssets.prototype.getNormalSuitPosition(self, x, y)
    return {x = x + 10, y = y + 10}
end
function CardAssets.prototype.getFlippedSuitPosition(self, x, y)
    return {x = x + self.baseW - 10, y = y + self.baseH - 10}
end
function CardAssets.prototype.addRankAsset(self, card, x, y, width, height, hoverable)
    local rankImagePath = ____exports.default:getRankAssetPath(card.rank)
    local rankImage = love.graphics.newImage(rankImagePath)
    local assetId = ____exports.default:getRankAssetId(card, 0)
    local rankPosition = self:getRankPosition(x, y, rankImage)
    local asset = __TS__New(
        Asset,
        assetId,
        rankImage,
        rankPosition.x,
        rankPosition.y,
        card.onClick,
        function(____, gameManager, asset) return Card:onHover(gameManager, asset) end,
        width,
        height
    )
    self.gameManager.assetManager:addAsset(assetId, asset)
    asset:setHoverable(hoverable)
end
function CardAssets.prototype.getRankPosition(self, x, y, rankImage)
    local rankW = rankImage:getWidth()
    local rankH = rankImage:getHeight()
    return {x = x + self.baseW / 2 - rankW / 2, y = y + self.baseH / 2 - rankH / 2}
end
function CardAssets.getSuitAssetPath(self, suit)
    repeat
        local ____switch14 = suit
        local ____cond14 = ____switch14 == Suits.HEARTS
        if ____cond14 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Suits.BELLS
        if ____cond14 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Suits.ACORNS
        if ____cond14 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond14 = ____cond14 or ____switch14 == Suits.LEAVES
        if ____cond14 then
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
        local ____switch17 = rank
        local ____cond17 = ____switch17 == Ranks.BANNER
        if ____cond17 then
            return "Assets/Images/BannerRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.BARON
        if ____cond17 then
            return "Assets/Images/BaronRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.DEUCE
        if ____cond17 then
            return "Assets/Images/DeuceRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.JESTER
        if ____cond17 then
            return "Assets/Images/JesterRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.KING
        if ____cond17 then
            return "Assets/Images/KingRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.OVERLORD
        if ____cond17 then
            return "Assets/Images/OverlordRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.PRIEST
        if ____cond17 then
            return "Assets/Images/PriestRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.SERGEANT
        if ____cond17 then
            return "Assets/Images/SergeantRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.SOLDIER
        if ____cond17 then
            return "Assets/Images/SoldierRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == Ranks.THIEF
        if ____cond17 then
            return "Assets/Images/ThiefRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.BARD
        if ____cond17 then
            return "Assets/Images/BardRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.CHOSEN
        if ____cond17 then
            return "Assets/Images/ChosenRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.DEVIL
        if ____cond17 then
            return "Assets/Images/DevilRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.DUKE
        if ____cond17 then
            return "Assets/Images/DukeRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.EMPEROR
        if ____cond17 then
            return "Assets/Images/EmperorRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.POPE
        if ____cond17 then
            return "Assets/Images/PopeRank.png"
        end
        ____cond17 = ____cond17 or ____switch17 == TrumpRanks.KNIGHT
        if ____cond17 then
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
    local assets = self.gameManager.assetManager.assets
    assets:delete(____exports.default:getCardAssetId(card))
    assets:delete(____exports.default:getSuitAssetId(card, 0))
    assets:delete(____exports.default:getSuitAssetId(card, 1))
    assets:delete(____exports.default:getRankAssetId(card, 0))
end
function CardAssets.prototype.centerCards(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardCount = #character.hand
    local screenW = push:getWidth()
    local totalW = cardCount * self.baseW + math.max(0, cardCount - 1) * padding
    local startX = math.floor((screenW - totalW) / 2)
    local cardY = self:getCardPosition(characterType)
    do
        local i = 0
        while i < #character.hand do
            local card = character.hand[i + 1]
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
    local rankAsset = self:getRankAsset(card)
    if isEmpty(rankAsset) then
        return
    end
    local rankPosition = self:getRankPosition(x, y, rankAsset.image)
    local ____opt_6 = assetManager:getAsset(____exports.default:getRankAssetId(card, 0))
    if ____opt_6 ~= nil then
        ____opt_6:updatePosition(rankPosition.x, rankPosition.y)
    end
end
function CardAssets.prototype.getRankAsset(self, card)
    return self.gameManager.assetManager:getAsset(____exports.default:getRankAssetId(card, 0))
end
function CardAssets.prototype.getCardPosition(self, characterType)
    local screenH = push:getHeight()
    return screenH / 2 + self:getHeightModifier(characterType)
end
function CardAssets.prototype.getHeightModifier(self, characterType)
    repeat
        local ____switch29 = characterType
        local ____cond29 = ____switch29 == CharacterTypes.PLAYER
        if ____cond29 then
            return self.baseH / 2
        end
        ____cond29 = ____cond29 or ____switch29 == CharacterTypes.ENEMY
        if ____cond29 then
            return -(self.baseH * 1.5)
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function CardAssets.prototype.determineCardStartingPosition(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return {x = 0, y = 0}
    end
    local cardCount = #character.hand
    local screenW = push:getWidth()
    local totalW = cardCount * self.baseW + math.max(0, cardCount - 1) * padding
    return {
        x = math.floor((screenW - totalW) / 2),
        y = self:getCardPosition(characterType)
    }
end
function CardAssets.prototype.appendAsset(self, card, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardPosition = self:determineCardStartingPosition(characterType)
    local x = cardPosition.x + (#character.hand - 1) * (self.baseW + padding)
    self:addAsset(card, x, cardPosition.y)
end
return ____exports
