local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local CharacterTypes = ____Enums.CharacterTypes
local HoverEffects = ____Enums.HoverEffects
local Suits = ____Enums.Suits
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local normalColor = ____Asset.normalColor
____exports.padding = 5
____exports.cardWidth = 70
____exports.cardHeight = 96
____exports.default = __TS__Class()
local CardAssets = ____exports.default
CardAssets.name = "CardAssets"
function CardAssets.prototype.____constructor(self, gameManager, board)
    self.cardClick = love.audio.newSource("Assets/Sounds/CardClick.wav", "static")
    self.hoverSound = love.audio.newSource("Assets/Sounds/CardHover.wav", "static")
    self.cardAssetConstructionOptions = function(____, includeClickHandler, card) return {
        onClick = includeClickHandler and (function() return card:onClick() end) or nil,
        onHover = function(____, asset) return card:onHover(asset) end,
        onUnhover = function(____, asset) return card:onUnhover(asset) end,
        clickSound = includeClickHandler and self.cardClick or nil,
        hoverSound = includeClickHandler and self.hoverSound or nil,
        isDisabled = true,
        useDisabledAnimation = false,
        showDisabledColor = false
    } end
    self.gameManager = gameManager
    self.board = board
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
        card.isEdel and self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/EdelCard.png") or self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/BaseCardTemplate.png"),
        cardX,
        cardY,
        ____exports.cardWidth,
        ____exports.cardHeight,
        __TS__ObjectAssign(
            {hoverEffect = includeClickHandler and ({HoverEffects.SHIMMER, HoverEffects.WOBBLE}) or ({HoverEffects.NONE})},
            self:cardAssetConstructionOptions(includeClickHandler, card)
        )
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
    local normalAssetId = ____exports.default:getSuitAssetId(card, 0)
    local normalPosition = self:getNormalSuitPosition(x, y)
    local normalAsset = __TS__New(
        Asset,
        self.gameManager,
        normalAssetId,
        self.gameManager.assetManager.assetLoader:loadImage(suitImagePath),
        normalPosition.x,
        normalPosition.y,
        16,
        16,
        __TS__ObjectAssign(
            {hoverEffect = includeClickHandler and ({HoverEffects.WOBBLE}) or ({HoverEffects.NONE})},
            self:cardAssetConstructionOptions(includeClickHandler, card)
        )
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
        self.gameManager.assetManager.assetLoader:loadImage(suitImagePath),
        flippedPosition.x,
        flippedPosition.y,
        16,
        16,
        __TS__ObjectAssign(
            {hoverEffect = includeClickHandler and ({HoverEffects.WOBBLE}) or ({HoverEffects.NONE}), orientation = 0, scaleX = -1, scaleY = -1},
            self:cardAssetConstructionOptions(includeClickHandler, card)
        )
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
    local rankImage = self.gameManager.assetManager.assetLoader:loadImage(card:getRankAssetPath())
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
        __TS__ObjectAssign(
            {hoverEffect = includeClickHandler and ({HoverEffects.WOBBLE}) or ({HoverEffects.NONE})},
            self:cardAssetConstructionOptions(includeClickHandler, card)
        )
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
        local ____switch15 = suit
        local ____cond15 = ____switch15 == Suits.HEARTS
        if ____cond15 then
            return "Assets/Images/HeartSuit.png"
        end
        ____cond15 = ____cond15 or ____switch15 == Suits.BELLS
        if ____cond15 then
            return "Assets/Images/BellSuit.png"
        end
        ____cond15 = ____cond15 or ____switch15 == Suits.ACORNS
        if ____cond15 then
            return "Assets/Images/AcornSuit.png"
        end
        ____cond15 = ____cond15 or ____switch15 == Suits.LEAVES
        if ____cond15 then
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
        local ____switch28 = characterType
        local ____cond28 = ____switch28 == CharacterTypes.PLAYER
        if ____cond28 then
            return not self.board.showingEdelView and -(____exports.cardHeight * 0.25) or ____exports.cardHeight / 2
        end
        ____cond28 = ____cond28 or ____switch28 == CharacterTypes.ENEMY
        if ____cond28 then
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
    local ____temp_0 = self:getCardAssets(card)
    local baseAsset = ____temp_0.baseAsset
    local suitAssets = ____temp_0.suitAssets
    local rankAsset = ____temp_0.rankAsset
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
            if disable then
                asset.isDisabled = true
            else
                asset.isDisabled = false
                asset.color = normalColor
            end
        end
    end
end
function CardAssets.prototype.redrawCard(self, card)
    local ____temp_1 = self:getCardAssets(card)
    local baseAsset = ____temp_1.baseAsset
    if isEmpty(baseAsset) then
        return
    end
    self.gameManager.assetManager:removeAssets(____exports.default:getBaseAssetId(card))
    self:addAsset(card, baseAsset.x, baseAsset.y)
end
function CardAssets.prototype.repositionCard(self, card, x, y)
    local ____temp_2 = self:getCardAssets(card)
    local baseAsset = ____temp_2.baseAsset
    if isEmpty(baseAsset) then
        return
    end
    local assets = self:getCardAssetList(card)
    if isEmpty(assets) then
        return
    end
    for ____, asset in ipairs(assets) do
        local offsetFromBase = asset.x - baseAsset.x
        asset.x = x + offsetFromBase
    end
end
return ____exports
