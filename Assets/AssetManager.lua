local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local push = require("Libraries.push")
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____TextManager = require("Assets.TextManager")
local TextManager = ____TextManager.default
local ____WobbleAnimation = require("Assets.Animations.WobbleAnimation")
local WobbleAnimation = ____WobbleAnimation.default
local ____TooltipManager = require("Assets.TooltipManager")
local TooltipManager = ____TooltipManager.default
____exports.default = __TS__Class()
local AssetManager = ____exports.default
AssetManager.name = "AssetManager"
function AssetManager.prototype.____constructor(self, gameManager)
    self.assets = __TS__New(Map)
    self.tooltipManager = __TS__New(TooltipManager)
    self.textManager = __TS__New(TextManager)
    self.disabledSound = love.audio.newSource("Assets/Sounds/Disabled.wav", "static")
    self.gameManager = gameManager
end
function AssetManager.prototype.addAsset(self, id, asset)
    if self.assets:has(id) then
        local assets = self.assets:get(id)
        local ____opt_0 = assets
        if ____opt_0 ~= nil then
            assets[#assets + 1] = asset
        end
        return
    end
    self.assets:set(id, {asset})
end
function AssetManager.prototype.getAssets(self, baseId)
    return self.assets:get(baseId)
end
function AssetManager.prototype.getAsset(self, baseId, assetId)
    local ____opt_2 = self:getAssets(baseId)
    return ____opt_2 and __TS__ArrayFind(
        self:getAssets(baseId),
        function(____, asset) return asset.id == assetId end
    )
end
function AssetManager.prototype.hideAsset(self, id)
    self.assets:delete(id)
end
function AssetManager.prototype.disableAsset(self, baseId)
    local assets = self:getAssets(baseId)
    if not isEmpty(assets) then
        for ____, asset in ipairs(assets) do
            asset:setDisabled(true)
        end
    end
end
function AssetManager.prototype.enableAsset(self, baseId)
    local assets = self:getAssets(baseId)
    if not isEmpty(assets) then
        for ____, asset in ipairs(assets) do
            asset:setDisabled(false)
        end
    end
end
function AssetManager.prototype.drawAssets(self)
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue18
            end
            for ____, asset in ipairs(assets) do
                asset:drawAsset()
            end
        end
        ::__continue18::
    end
    self.textManager:drawText()
    self.tooltipManager:drawTooltips()
end
function AssetManager.prototype.handleMousePressed(self, x, y, button)
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue25
            end
            local asset = assets[1]
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
                for ____, a in ipairs(assets) do
                    a:setMousePressed(true)
                end
            end
        end
        ::__continue25::
    end
end
function AssetManager.prototype.handleMouseReleased(self, x, y, button)
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue33
            end
            local asset = assets[1]
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
                if asset.isDisabled then
                    self:handleDisabledAssetClick(assets)
                else
                    self:handleAssetClick(asset)
                end
            end
            for ____, a in ipairs(assets) do
                a:setMousePressed(false)
            end
        end
        ::__continue33::
    end
end
function AssetManager.prototype.handleDisabledAssetClick(self, assets)
    if self.gameManager.animationManager:hasWobbleAnimation() then
        return
    end
    if not self.disabledSound:isPlaying() then
        self.disabledSound:play()
    end
    self:triggerWobbleAnimation(assets)
end
function AssetManager.prototype.triggerWobbleAnimation(self, assets)
    for ____, assetToWobble in ipairs(assets) do
        local wobbleId = "wobble-" .. assetToWobble.id
        if not self.gameManager.animationManager.animations:has(wobbleId) then
            self.gameManager.animationManager.animations:set(
                wobbleId,
                __TS__New(WobbleAnimation, 10, {assetToWobble}, {animDuration = 0.5})
            )
        end
        if not isEmpty(assetToWobble.associatedTexts) then
            for ____, text in ipairs(assetToWobble.associatedTexts) do
                local wobbleTextId = "wobble-" .. tostring(text)
                if not self.gameManager.animationManager.animations:has(wobbleTextId) then
                    self.gameManager.animationManager.animations:set(
                        wobbleTextId,
                        __TS__New(WobbleAnimation, 10, {text}, {animDuration = 0.5})
                    )
                end
            end
        end
    end
end
function AssetManager.prototype.handleAssetClick(self, asset)
    local ____this_5
    ____this_5 = asset
    local ____opt_4 = ____this_5.onClick
    if ____opt_4 ~= nil then
        ____opt_4(____this_5)
    end
    local ____opt_6 = asset.clickSound
    if not (____opt_6 and ____opt_6:isPlaying()) then
        local ____opt_8 = asset.clickSound
        if ____opt_8 ~= nil then
            ____opt_8:play()
        end
    end
end
function AssetManager.prototype.handleMouseHover(self)
    local x, y = love.mouse.getPosition()
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue56
            end
            local asset = assets[1]
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
                if not asset.isHovered then
                    for ____, a in ipairs(assets) do
                        a:setHovered(true)
                    end
                    local ____opt_10 = asset.onHover
                    if ____opt_10 ~= nil then
                        ____opt_10(asset, asset)
                    end
                end
            elseif asset.isHovered then
                for ____, a in ipairs(assets) do
                    a:setHovered(false)
                end
                local ____opt_12 = asset.onUnhover
                if ____opt_12 ~= nil then
                    ____opt_12(asset, asset)
                end
            end
        end
        ::__continue56::
    end
end
return ____exports
