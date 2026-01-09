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
local EdelRanks = ____Enums.EdelRanks
local CharacterTypes = ____Enums.CharacterTypes
local HoverEffects = ____Enums.HoverEffects
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
____exports.padding = 5
____exports.cardWidth = 70
____exports.cardHeight = 96
____exports.default = __TS__Class()
local CardAssets = ____exports.default
CardAssets.name = "CardAssets"
function CardAssets.prototype.____constructor(self, gameManager)
    self.baseCard = love.graphics.newImage("Assets/Images/BaseCardTemplate.png")
    self.cardClick = love.audio.newSource("Assets/Sounds/CardClick.wav", "static")
    self.gameManager = gameManager
end
function CardAssets.prototype.addAsset(self, card, cardX, cardY, includeClickHandler)
    if includeClickHandler == nil then
        includeClickHandler = true
    end
    local assetId = ____exports.default:getBaseAssetId(card)
    local baseCardAsset = __TS__New(
        Asset,
        self.gameManager,
        assetId,
        self.baseCard,
        cardX,
        cardY,
        ____exports.cardWidth,
        ____exports.cardHeight,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = function(____, asset) return card:onHover(asset) end,
            onUnhover = function(____, asset) return card:onUnhover(asset) end,
            hoverEffect = includeClickHandler and ({HoverEffects.SHIMMER}) or ({HoverEffects.NONE}),
            clickSound = includeClickHandler and self.cardClick or nil,
            isDisabled = true,
            useDisabledAnimation = false
        }
    )
    self.gameManager.assetManager:addAsset(assetId, baseCardAsset, true)
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
    local function onHoverCallback(____, asset)
        return card:onHover(asset)
    end
    local normalAssetId = ____exports.default:getSuitAssetId(card, 0)
    local normalPosition = self:getNormalSuitPosition(x, y)
    local normalAsset = __TS__New(
        Asset,
        self.gameManager,
        normalAssetId,
        love.graphics.newImage(suitImagePath),
        normalPosition.x,
        normalPosition.y,
        16,
        16,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = onHoverCallback,
            onUnhover = function(____, asset) return card:onUnhover(asset) end,
            hoverEffect = includeClickHandler and ({HoverEffects.SHIMMER}) or ({HoverEffects.NONE}),
            clickSound = includeClickHandler and self.cardClick or nil,
            isDisabled = true,
            useDisabledAnimation = false
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
        self.gameManager,
        flippedAssetId,
        love.graphics.newImage(suitImagePath),
        flippedPosition.x,
        flippedPosition.y,
        16,
        16,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = onHoverCallback,
            onUnhover = function(____, asset) return card:onUnhover(asset) end,
            orientation = 0,
            hoverEffect = includeClickHandler and ({HoverEffects.SHIMMER}) or ({HoverEffects.NONE}),
            scaleX = -1,
            scaleY = -1,
            clickSound = includeClickHandler and self.cardClick or nil,
            isDisabled = true,
            useDisabledAnimation = false
        }
    )
    self.gameManager.assetManager:addAsset(
        ____exports.default:getBaseAssetId(card),
        flippedAsset
    )
end
function CardAssets.prototype.getNormalSuitPosition(self, x, y)
    return {x = x + ____exports.padding + 1, y = y + ____exports.padding + 1}
end
function CardAssets.prototype.getFlippedSuitPosition(self, x, y)
    return {x = x + ____exports.cardWidth - ____exports.padding - 1, y = y + ____exports.cardHeight - ____exports.padding - 1}
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
        self.gameManager,
        assetId,
        rankImage,
        rankPosition.x,
        rankPosition.y,
        64,
        64,
        {
            onClick = includeClickHandler and (function() return card:onClick() end) or nil,
            onHover = function(____, asset) return card:onHover(asset) end,
            onUnhover = function(____, asset) return card:onUnhover(asset) end,
            hoverEffect = includeClickHandler and ({HoverEffects.SHIMMER}) or ({HoverEffects.NONE}),
            clickSound = includeClickHandler and self.cardClick or nil,
            isDisabled = true,
            useDisabledAnimation = false
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
    return {x = x + ____exports.cardWidth / 2 - rankW / 2, y = y + ____exports.cardHeight / 2 - rankH / 2}
end
function CardAssets.getSuitAssetPath(self, suit)
    repeat
        local ____switch22 = suit
        local ____cond22 = ____switch22 == Suits.HEARTS
        if ____cond22 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond22 = ____cond22 or ____switch22 == Suits.BELLS
        if ____cond22 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond22 = ____cond22 or ____switch22 == Suits.ACORNS
        if ____cond22 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond22 = ____cond22 or ____switch22 == Suits.LEAVES
        if ____cond22 then
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
        local ____switch25 = rank
        local ____cond25 = ____switch25 == Ranks.BANNER
        if ____cond25 then
            return "Assets/Images/BannerRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.BARON
        if ____cond25 then
            return "Assets/Images/BaronRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.DEUCE
        if ____cond25 then
            return "Assets/Images/DeuceRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.JESTER
        if ____cond25 then
            return "Assets/Images/JesterRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.KING
        if ____cond25 then
            return "Assets/Images/KingRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.OVERLORD
        if ____cond25 then
            return "Assets/Images/OverlordRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.PRIEST
        if ____cond25 then
            return "Assets/Images/PriestRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.SERGEANT
        if ____cond25 then
            return "Assets/Images/SergeantRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.SOLDIER
        if ____cond25 then
            return "Assets/Images/SoldierRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == Ranks.THIEF
        if ____cond25 then
            return "Assets/Images/ThiefRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.BARD
        if ____cond25 then
            return "Assets/Images/BardRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.CHOSEN
        if ____cond25 then
            return "Assets/Images/ChosenRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.DEVIL
        if ____cond25 then
            return "Assets/Images/DevilRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.DUKE
        if ____cond25 then
            return "Assets/Images/DukeRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.EMPEROR
        if ____cond25 then
            return "Assets/Images/EmperorRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.POPE
        if ____cond25 then
            return "Assets/Images/PopeRank.png"
        end
        ____cond25 = ____cond25 or ____switch25 == EdelRanks.KNIGHT
        if ____cond25 then
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
function CardAssets.prototype.removeCardAssets(self, card)
    self.gameManager.assetManager:removeAssets(____exports.default:getBaseAssetId(card))
end
function CardAssets.prototype.hideCardAssets(self, card)
    local assetsForCard = self:getCardAssets(card)
    if isEmpty(assetsForCard.baseAsset) then
        return
    end
    assetsForCard.baseAsset.isHidden = true
    for ____, suitAsset in ipairs(assetsForCard.suitAssets) do
        if not isEmpty(suitAsset) then
            suitAsset.isHidden = true
        end
    end
    if not isEmpty(assetsForCard.rankAsset) then
        assetsForCard.rankAsset.isHidden = true
    end
end
function CardAssets.prototype.getRankAsset(self, card)
    return self.gameManager.assetManager:getAsset(
        ____exports.default:getBaseAssetId(card),
        ____exports.default:getRankAssetId(card, 0)
    )
end
function CardAssets.prototype.getHandYCoordinate(self, characterType)
    local screenH = push:getHeight()
    return screenH / 2 + self:getHeightModifier(characterType)
end
function CardAssets.prototype.getHeightModifier(self, characterType)
    repeat
        local ____switch37 = characterType
        local ____cond37 = ____switch37 == CharacterTypes.PLAYER
        if ____cond37 then
            local ____opt_0 = self.gameManager.board
            return not (____opt_0 and ____opt_0.showingEdelView) and -(____exports.cardHeight * 0.25) or ____exports.cardHeight / 2
        end
        ____cond37 = ____cond37 or ____switch37 == CharacterTypes.ENEMY
        if ____cond37 then
            return -(____exports.cardHeight * 1.5)
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
    local totalW = cardCount * ____exports.cardWidth + math.max(0, cardCount - 1) * ____exports.padding
    return {
        x = math.floor((screenW - totalW) / 2),
        y = self:getHandYCoordinate(characterType)
    }
end
function CardAssets.prototype.appendAsset(self, card, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardPosition = self:determineCardStartingPosition(characterType)
    local x = cardPosition.x + (#character.hand - 1) * (____exports.cardWidth + ____exports.padding)
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
    return {baseAsset = baseAsset, suitAssets = {suitAsset0, suitAsset1}, rankAsset = rankAsset}
end
function CardAssets.prototype.getCardAssetList(self, card)
    local ____temp_2 = self:getCardAssets(card)
    local baseAsset = ____temp_2.baseAsset
    local suitAssets = ____temp_2.suitAssets
    local rankAsset = ____temp_2.rankAsset
    local assets = {}
    if not isEmpty(baseAsset) then
        assets[#assets + 1] = baseAsset
    end
    if not isEmpty(rankAsset) then
        assets[#assets + 1] = rankAsset
    end
    if not isEmpty(suitAssets[1]) then
        assets[#assets + 1] = suitAssets[1]
    end
    if not isEmpty(suitAssets[2]) then
        assets[#assets + 1] = suitAssets[2]
    end
    return assets
end
function CardAssets.prototype.disableAllCards(self, disable)
    if isEmpty(self.gameManager.board) then
        return
    end
    for ____, card in ipairs(self.gameManager.board:getAllCardsInPlay()) do
        for ____, asset in ipairs(self:getCardAssetList(card)) do
            asset.isDisabled = disable
        end
    end
end
return ____exports
