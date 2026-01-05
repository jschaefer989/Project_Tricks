local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local ____exports = {}
local ____Card = require("Cards.Card")
local Card = ____Card.default
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Enums = require("Enums")
local Suits = ____Enums.Suits
local AssetIds = ____Enums.AssetIds
local Ranks = ____Enums.Ranks
local EdelRanks = ____Enums.EdelRanks
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
function CardAssets.prototype.addAsset(self, card, cardX, cardY, includeClickHandler)
    if includeClickHandler == nil then
        includeClickHandler = true
    end
    local assetId = ____exports.default:getBaseAssetId(card)
    local baseCardAsset = __TS__New(
        Asset,
        assetId,
        self.baseCard,
        cardX,
        cardY,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = function(____, gameManager, asset) return Card:onHover(gameManager, asset) end
        }
    )
    self.gameManager.assetManager:addAsset(assetId, baseCardAsset)
    self:addSuitAsset(card, cardX, cardY, includeClickHandler)
    self:addRankAsset(card, cardX, cardY, includeClickHandler)
end
function CardAssets.getBaseAssetId(self, card)
    return (AssetIds.BASE_CARD_TEMPLATE .. "-") .. card.id
end
function CardAssets.prototype.addSuitAsset(self, card, x, y, includeClickHandler)
    if includeClickHandler == nil then
        includeClickHandler = true
    end
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
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = onHoverCallback
        }
    )
    self.gameManager.assetManager:addAsset(
        ____exports.default:getBaseAssetId(card),
        normalAsset
    )
    local flippedPosition = self:getFlippedSuitPosition(x, y)
    local flippedAssetId = ____exports.default:getSuitAssetId(card, 1)
    local flippedAsset = __TS__New(
        Asset,
        flippedAssetId,
        love.graphics.newImage(suitImagePath),
        flippedPosition.x,
        flippedPosition.y,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = onHoverCallback,
            orientation = 0,
            scaleX = -1,
            scaleY = -1
        }
    )
    self.gameManager.assetManager:addAsset(
        ____exports.default:getBaseAssetId(card),
        flippedAsset
    )
end
function CardAssets.prototype.getNormalSuitPosition(self, x, y)
    return {x = x + 10, y = y + 10}
end
function CardAssets.prototype.getFlippedSuitPosition(self, x, y)
    return {x = x + self.baseW - 10, y = y + self.baseH - 10}
end
function CardAssets.prototype.addRankAsset(self, card, x, y, includeClickHandler)
    if includeClickHandler == nil then
        includeClickHandler = true
    end
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
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = function(____, gameManager, asset) return Card:onHover(gameManager, asset) end
        }
    )
    self.gameManager.assetManager:addAsset(
        ____exports.default:getBaseAssetId(card),
        asset
    )
end
function CardAssets.prototype.getRankPosition(self, x, y, rankImage)
    local rankW = rankImage:getWidth()
    local rankH = rankImage:getHeight()
    return {x = x + self.baseW / 2 - rankW / 2, y = y + self.baseH / 2 - rankH / 2}
end
function CardAssets.getSuitAssetPath(self, suit)
    repeat
        local ____switch18 = suit
        local ____cond18 = ____switch18 == Suits.HEARTS
        if ____cond18 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.BELLS
        if ____cond18 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.ACORNS
        if ____cond18 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond18 = ____cond18 or ____switch18 == Suits.LEAVES
        if ____cond18 then
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
        local ____switch21 = rank
        local ____cond21 = ____switch21 == Ranks.BANNER
        if ____cond21 then
            return "Assets/Images/BannerRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.BARON
        if ____cond21 then
            return "Assets/Images/BaronRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.DEUCE
        if ____cond21 then
            return "Assets/Images/DeuceRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.JESTER
        if ____cond21 then
            return "Assets/Images/JesterRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.KING
        if ____cond21 then
            return "Assets/Images/KingRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.OVERLORD
        if ____cond21 then
            return "Assets/Images/OverlordRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.PRIEST
        if ____cond21 then
            return "Assets/Images/PriestRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.SERGEANT
        if ____cond21 then
            return "Assets/Images/SergeantRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.SOLDIER
        if ____cond21 then
            return "Assets/Images/SoldierRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == Ranks.THIEF
        if ____cond21 then
            return "Assets/Images/ThiefRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.BARD
        if ____cond21 then
            return "Assets/Images/BardRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.CHOSEN
        if ____cond21 then
            return "Assets/Images/ChosenRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.DEVIL
        if ____cond21 then
            return "Assets/Images/DevilRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.DUKE
        if ____cond21 then
            return "Assets/Images/DukeRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.EMPEROR
        if ____cond21 then
            return "Assets/Images/EmperorRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.POPE
        if ____cond21 then
            return "Assets/Images/PopeRank.png"
        end
        ____cond21 = ____cond21 or ____switch21 == EdelRanks.KNIGHT
        if ____cond21 then
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
    self.gameManager.assetManager:hideAsset(____exports.default:getBaseAssetId(card))
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
    local baseAssetId = ____exports.default:getBaseAssetId(card)
    local ____opt_0 = assetManager:getAsset(baseAssetId, baseAssetId)
    if ____opt_0 ~= nil then
        ____opt_0:updatePosition(x, y)
    end
    local ____opt_2 = assetManager:getAsset(
        baseAssetId,
        ____exports.default:getSuitAssetId(card, 0)
    )
    if ____opt_2 ~= nil then
        ____opt_2:updatePosition(x + 10, y + 10)
    end
    local ____opt_4 = assetManager:getAsset(
        baseAssetId,
        ____exports.default:getSuitAssetId(card, 1)
    )
    if ____opt_4 ~= nil then
        ____opt_4:updatePosition(x + self.baseW - 10, y + self.baseH - 10)
    end
    local rankAsset = self:getRankAsset(card)
    if isEmpty(rankAsset) then
        return
    end
    local rankPosition = self:getRankPosition(x, y, rankAsset.image)
    local ____opt_6 = assetManager:getAsset(
        baseAssetId,
        ____exports.default:getRankAssetId(card, 0)
    )
    if ____opt_6 ~= nil then
        ____opt_6:updatePosition(rankPosition.x, rankPosition.y)
    end
end
function CardAssets.prototype.getRankAsset(self, card)
    return self.gameManager.assetManager:getAsset(
        ____exports.default:getBaseAssetId(card),
        ____exports.default:getRankAssetId(card, 0)
    )
end
function CardAssets.prototype.getCardPosition(self, characterType)
    local screenH = push:getHeight()
    return screenH / 2 + self:getHeightModifier(characterType)
end
function CardAssets.prototype.getHeightModifier(self, characterType)
    repeat
        local ____switch33 = characterType
        local ____cond33 = ____switch33 == CharacterTypes.PLAYER
        if ____cond33 then
            local ____opt_8 = self.gameManager.board
            return not (____opt_8 and ____opt_8.showingEdelView) and -(self.baseH * 0.25) or self.baseH / 2
        end
        ____cond33 = ____cond33 or ____switch33 == CharacterTypes.ENEMY
        if ____cond33 then
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
    self:addAsset(card, x, cardPosition.y, characterType == CharacterTypes.PLAYER)
end
function CardAssets.prototype.getCardAssets(self, card)
    local baseAssetId = ____exports.default:getBaseAssetId(card)
    local suitAssetId0 = ____exports.default:getSuitAssetId(card, 0)
    local suitAssetId1 = ____exports.default:getSuitAssetId(card, 1)
    local rankAssetId = ____exports.default:getRankAssetId(card, 0)
    local baseAsset = self.gameManager.assetManager:getAsset(baseAssetId, baseAssetId)
    local suitAsset0 = self.gameManager.assetManager:getAsset(baseAssetId, suitAssetId0)
    local suitAsset1 = self.gameManager.assetManager:getAsset(baseAssetId, suitAssetId1)
    local rankAsset = self.gameManager.assetManager:getAsset(baseAssetId, rankAssetId)
    if isEmpty(baseAsset) or isEmpty(suitAsset0) or isEmpty(suitAsset1) or isEmpty(rankAsset) then
        error(
            __TS__New(Error, ("One or more assets for card " .. card.id) .. " are missing."),
            0
        )
    end
    return {baseAsset = baseAsset, suitAssets = {suitAsset0, suitAsset1}, rankAsset = rankAsset}
end
return ____exports
