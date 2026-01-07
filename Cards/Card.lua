local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AnimationIds = ____Enums.AnimationIds
local Suits = ____Enums.Suits
local AssetIds = ____Enums.AssetIds
local TextIds = ____Enums.TextIds
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local ____IconAsset = require("Assets.IconAsset")
local IconAsset = ____IconAsset.default
____exports.default = __TS__Class()
local Card = ____exports.default
Card.name = "Card"
function Card.prototype.____constructor(self, gameManager, suit, rank, power, value, name, isEdel)
    self.isSelected = false
    self.isEdel = false
    local id = (((suit .. "_") .. rank) .. "_") .. tostring(love.math.random(1000))
    self.gameManager = gameManager
    self.suit = suit
    self.rank = rank
    self.power = power
    self.value = value
    self.cost = self:getCost()
    local ____isEdel_0 = isEdel
    if ____isEdel_0 == nil then
        ____isEdel_0 = false
    end
    self.isEdel = ____isEdel_0
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
        isEdel = self.isEdel,
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
        data.isEdel
    )
    card.id = data.id
    card.isSelected = data.isSelected
    card.cost = data.cost
    return card
end
function Card.prototype.onClick(self)
    if self.isSelected then
        self:onUnselect()
    else
        self:onSelect()
    end
end
function Card.prototype.onSelect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    self.isSelected = true
    self.gameManager.board:addPlayerPower(self.power)
    self.gameManager.board:addPlayerValue(self.value)
    local ____temp_1 = self.gameManager.board.cardAssets:getCardAssets(self)
    local baseAsset = ____temp_1.baseAsset
    local suitAssets = ____temp_1.suitAssets
    local rankAsset = ____temp_1.rankAsset
    local suitAssetNormal = suitAssets[1]
    local suitAssetFlipped = suitAssets[2]
    local animationAssets = {}
    local baseId = AnimationIds.CARD_BASE_SELECT .. self.id
    if not isEmpty(baseAsset) and not self.gameManager.animationManager.animations:has(baseId) then
        animationAssets[#animationAssets + 1] = baseAsset
    end
    local suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT .. self.id
    if not isEmpty(suitAssetNormal) and not self.gameManager.animationManager.animations:has(suitNormalId) then
        animationAssets[#animationAssets + 1] = suitAssetNormal
    end
    local suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT .. self.id
    if not isEmpty(suitAssetFlipped) and not self.gameManager.animationManager.animations:has(suitFlippedId) then
        animationAssets[#animationAssets + 1] = suitAssetFlipped
    end
    local rankAssetId = AnimationIds.CARD_RANK_SELECT .. self.id
    if not isEmpty(rankAsset) and not self.gameManager.animationManager.animations:has(rankAssetId) then
        animationAssets[#animationAssets + 1] = rankAsset
    end
    self.gameManager.animationManager.animations:set(
        baseId,
        __TS__New(SlideAnimation, 0, -20, animationAssets)
    )
    local ____opt_2 = self.gameManager.board
    if ____opt_2 ~= nil then
        ____opt_2:updatePrimaryButtonStates()
    end
end
function Card.prototype.onUnselect(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    self.isSelected = false
    self.gameManager.board:addPlayerPower(-self.power)
    self.gameManager.board:addPlayerValue(-self.value)
    local ____temp_4 = self.gameManager.board.cardAssets:getCardAssets(self)
    local baseAsset = ____temp_4.baseAsset
    local suitAssets = ____temp_4.suitAssets
    local rankAsset = ____temp_4.rankAsset
    local suitAssetNormal = suitAssets[1]
    local suitAssetFlipped = suitAssets[2]
    local animationAssets = {}
    local baseId = AnimationIds.CARD_BASE_SELECT .. self.id
    if not isEmpty(baseAsset) and not self.gameManager.animationManager.animations:has(baseId) then
        animationAssets[#animationAssets + 1] = baseAsset
    end
    local suitNormalId = AnimationIds.CARD_SUIT_NORMAL_SELECT .. self.id
    if not isEmpty(suitAssetNormal) and not self.gameManager.animationManager.animations:has(suitNormalId) then
        animationAssets[#animationAssets + 1] = suitAssetNormal
    end
    local suitFlippedId = AnimationIds.CARD_SUIT_FLIPPED_SELECT .. self.id
    if not isEmpty(suitAssetFlipped) and not self.gameManager.animationManager.animations:has(suitFlippedId) then
        animationAssets[#animationAssets + 1] = suitAssetFlipped
    end
    local rankAssetId = AnimationIds.CARD_RANK_SELECT .. self.id
    if not isEmpty(rankAsset) and not self.gameManager.animationManager.animations:has(rankAssetId) then
        animationAssets[#animationAssets + 1] = rankAsset
    end
    self.gameManager.animationManager.animations:set(
        baseId,
        __TS__New(SlideAnimation, 0, 20, animationAssets)
    )
    local ____opt_5 = self.gameManager.board
    if ____opt_5 ~= nil then
        ____opt_5:updatePrimaryButtonStates()
    end
end
function Card.prototype.onHover(self, asset)
    self.gameManager.assetManager.tooltipManager:addTooltip(
        {
            __TS__New(
                FontWithPosition,
                TextIds.TOOLTIP_CARD_NAME,
                5,
                10,
                (self.name .. " of ") .. ____exports.default:getSuitName(self.suit)
            ),
            __TS__New(
                FontWithPosition,
                TextIds.TOOLTIP_CARD_POWER,
                5,
                20,
                tostring(self.power),
                {icon = IconAsset:getPowerIconAsset(AssetIds.TOOLTIP_POWER_ICON)}
            ),
            __TS__New(
                FontWithPosition,
                TextIds.TOOLTIP_CARD_VALUE,
                5,
                30,
                tostring(self.value),
                {icon = IconAsset:getValueIconAsset(AssetIds.TOOLTIP_VALUE_ICON)}
            )
        },
        asset
    )
end
function Card.prototype.onUnhover(self, asset)
    self.gameManager.assetManager.tooltipManager:hideTooltip()
end
function Card.getSuitName(self, suit)
    repeat
        local ____switch26 = suit
        local ____cond26 = ____switch26 == Suits.HEARTS
        if ____cond26 then
            return "Hearts"
        end
        ____cond26 = ____cond26 or ____switch26 == Suits.ACORNS
        if ____cond26 then
            return "Acorns"
        end
        ____cond26 = ____cond26 or ____switch26 == Suits.LEAVES
        if ____cond26 then
            return "Leaves"
        end
        ____cond26 = ____cond26 or ____switch26 == Suits.BELLS
        if ____cond26 then
            return "Bells"
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
return ____exports
