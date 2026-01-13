local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local ____IconAsset = require("Assets.IconAsset")
local IconAsset = ____IconAsset.default
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local ____Enums = require("Enums")
local AnimationIds = ____Enums.AnimationIds
local AssetIds = ____Enums.AssetIds
local Suits = ____Enums.Suits
local TextIds = ____Enums.TextIds
____exports.default = __TS__Class()
local Card = ____exports.default
Card.name = "Card"
function Card.prototype.____constructor(self, gameManager, suit, rank, power, value, name, rankAssetPath, edelConstructionOptions)
    self.isSelected = false
    self.id = (((suit .. "_") .. rank) .. "_") .. tostring(love.math.random(1000))
    self.gameManager = gameManager
    self.suit = suit
    self.rank = rank
    self.power = power
    self.value = value
    self.cost = self:getCost()
    self.rankAssetPath = rankAssetPath
    self.name = name
    if edelConstructionOptions then
        self.edelName = edelConstructionOptions.edelName
        self.edelPower = edelConstructionOptions.edelPower
        self.edelValue = edelConstructionOptions.edelValue
        self.edelRankAssetPath = edelConstructionOptions.edelRankAssetPath
    end
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
    return self:getPower() * 10 + self:getValue() * 5
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
        name = self.name
    }
end
function Card.load(self, gameManager, data)
    local CardGenerator = require("Cards.CardGenerator").default
    local card = CardGenerator:getNewCard(gameManager, data.rank, data.suit)
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
    self.gameManager.board:addPlayerPower(self:getPower())
    self.gameManager.board:addPlayerValue(self:getValue())
    local ____opt_0 = self.gameManager.board
    local slideAssets = ____opt_0 and ____opt_0.cardAssets:getCardAssetList(self)
    self.gameManager.animationManager.animations:set(
        AnimationIds.CARD_SELECT .. self.id,
        __TS__New(
            SlideAnimation,
            0.15,
            0,
            -20,
            slideAssets
        )
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
    self.gameManager.board:addPlayerPower(-self:getPower())
    self.gameManager.board:addPlayerValue(-self:getValue())
    local ____opt_4 = self.gameManager.board
    local slideAssets = ____opt_4 and ____opt_4.cardAssets:getCardAssetList(self)
    self.gameManager.animationManager.animations:set(
        AnimationIds.CARD_SELECT .. self.id,
        __TS__New(
            SlideAnimation,
            0.15,
            0,
            20,
            slideAssets
        )
    )
    local ____opt_6 = self.gameManager.board
    if ____opt_6 ~= nil then
        ____opt_6:updatePrimaryButtonStates()
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
                (self:getName() .. " of ") .. ____exports.default:getSuitName(self.suit)
            ),
            __TS__New(
                FontWithPosition,
                TextIds.TOOLTIP_CARD_POWER,
                5,
                20,
                tostring(self:getPower()),
                {icon = IconAsset:getPowerIconAsset(self.gameManager, AssetIds.TOOLTIP_POWER_ICON)}
            ),
            __TS__New(
                FontWithPosition,
                TextIds.TOOLTIP_CARD_VALUE,
                5,
                30,
                tostring(self:getValue()),
                {icon = IconAsset:getValueIconAsset(self.gameManager, AssetIds.TOOLTIP_VALUE_ICON)}
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
        local ____switch19 = suit
        local ____cond19 = ____switch19 == Suits.HEARTS
        if ____cond19 then
            return "Hearts"
        end
        ____cond19 = ____cond19 or ____switch19 == Suits.ACORNS
        if ____cond19 then
            return "Acorns"
        end
        ____cond19 = ____cond19 or ____switch19 == Suits.LEAVES
        if ____cond19 then
            return "Leaves"
        end
        ____cond19 = ____cond19 or ____switch19 == Suits.BELLS
        if ____cond19 then
            return "Bells"
        end
        do
            exhaustiveGuard(suit)
        end
    until true
end
function Card.prototype.getPower(self)
    return self.isEdel and not isEmpty(self.edelPower) and self.edelPower or self.power
end
function Card.prototype.getValue(self)
    return self.isEdel and not isEmpty(self.edelValue) and self.edelValue or self.value
end
function Card.prototype.getName(self)
    return self.isEdel and not isEmpty(self.edelName) and self.edelName or self.name
end
function Card.prototype.getRankAssetPath(self)
    return self.isEdel and not isEmpty(self.edelRankAssetPath) and self.edelRankAssetPath or self.rankAssetPath
end
__TS__SetDescriptor(
    Card.prototype,
    "isEdel",
    {get = function(self)
        local ____opt_8 = self.gameManager.board
        local ____temp_14 = not (____opt_8 and ____opt_8.showingEdelView)
        if ____temp_14 then
            local ____opt_12 = self.gameManager.board
            local ____opt_10 = ____opt_12 and ____opt_12.edelCard
            ____temp_14 = (____opt_10 and ____opt_10.suit) == self.suit
        end
        return ____temp_14 and self.edelName ~= self.name
    end},
    true
)
return ____exports
