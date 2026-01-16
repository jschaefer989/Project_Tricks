local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local Format = ____FontWithPosition.Format
local ____Tooltip = require("Assets.Tooltip")
local Tooltip = ____Tooltip.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
____exports.default = __TS__Class()
local TooltipManager = ____exports.default
TooltipManager.name = "TooltipManager"
function TooltipManager.prototype.____constructor(self, gameManager)
    self.tooltips = __TS__New(Map)
    self.gameManager = gameManager
end
function TooltipManager.prototype.drawTooltips(self)
    for ____, tooltips in __TS__Iterator(self.tooltips:values()) do
        do
            if isEmpty(tooltips) or #tooltips == 0 then
                goto __continue4
            end
            for ____, tooltip in ipairs(tooltips) do
                tooltip.asset:drawAsset()
                for ____, text in ipairs(tooltip.texts) do
                    text:printText()
                end
            end
        end
        ::__continue4::
    end
end
function TooltipManager.prototype.addTooltip(self, texts, associatedAsset)
    if associatedAsset.isDisabled or associatedAsset.isHidden then
        return
    end
    local padding = 10
    local tooltipWidth = 128
    local screenW = push:getWidth()
    local defaultX = associatedAsset.x + associatedAsset:getWidth() + padding
    local placeRight = defaultX + tooltipWidth <= screenW
    local tooltipX = placeRight and defaultX or math.max(padding, associatedAsset.x - padding - tooltipWidth)
    local tooltipY = associatedAsset.y
    for ____, text in ipairs(texts) do
        text.x = text.x + tooltipX
        text.y = text.y + tooltipY
        text.limit = tooltipWidth
        text.alignMode = Format.CENTER
    end
    local tooltipImage = self:getTooltipBackground(texts)
    if isEmpty(tooltipImage) then
        error(
            __TS__New(Error, "No tooltip background found for the given texts."),
            0
        )
    end
    self:addAsset(
        AssetIds.TOOLTIP_BACKGROUND,
        __TS__New(
            Asset,
            self.gameManager,
            AssetIds.TOOLTIP_BACKGROUND,
            tooltipImage,
            tooltipX,
            tooltipY,
            tooltipWidth,
            self:getTooltipHeight(texts)
        ),
        texts
    )
end
function TooltipManager.prototype.getTooltipBackground(self, texts)
    if #texts == 2 then
        return self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/TooltipTwo.png")
    end
    if #texts == 3 then
        return self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/TooltipThree.png")
    end
    return self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/TooltipThree.png")
end
function TooltipManager.prototype.getTooltipHeight(self, texts)
    if #texts == 3 then
        return 44
    end
    return 0
end
function TooltipManager.prototype.addAsset(self, id, asset, texts)
    if not self.tooltips:has(id) then
        self.tooltips:set(id, {})
    end
    local ____opt_0 = self.tooltips:get(id)
    if ____opt_0 ~= nil then
        local ____temp_1 = self.tooltips:get(id)
        ____temp_1[#____temp_1 + 1] = __TS__New(Tooltip, asset, texts)
    end
end
function TooltipManager.prototype.hideTooltip(self)
    self.tooltips:delete(AssetIds.TOOLTIP_BACKGROUND)
end
return ____exports
