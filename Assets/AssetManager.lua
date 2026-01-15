local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____TextManager = require("Assets.Fonts.TextManager")
local TextManager = ____TextManager.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
local ____WobbleAnimation = require("Assets.Animations.WobbleAnimation")
local WobbleAnimation = ____WobbleAnimation.default
local ____TooltipManager = require("Assets.TooltipManager")
local TooltipManager = ____TooltipManager.default
____exports.default = __TS__Class()
local AssetManager = ____exports.default
AssetManager.name = "AssetManager"
function AssetManager.prototype.____constructor(self, gameManager)
    self.assets = __TS__New(Map)
    self.textManager = __TS__New(TextManager)
    self.disabledSound = love.audio.newSource("Assets/Sounds/Disabled.wav", "static")
    self.buttonClickSound = love.audio.newSource("Assets/Sounds/ButtonClick.mp3", "static")
    self.disabledAssets = __TS__New(Map)
    self.universallyDisabled = false
    self.gameManager = gameManager
    self.tooltipManager = __TS__New(TooltipManager, gameManager)
end
function AssetManager.prototype.addAsset(self, id, asset)
    if self.assets:has(id) then
        local assets = self.assets:get(id)
        local ____opt_0 = assets
        if ____opt_0 ~= nil then
            assets[#assets + 1] = asset
        end
    else
        self.assets:set(id, {asset})
    end
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
function AssetManager.prototype.removeAssets(self, id)
    self.assets:delete(id)
end
function AssetManager.prototype.removeAsset(self, baseId, assetId)
    local assets = self:getAssets(baseId)
    if not isEmpty(assets) then
        local index = __TS__ArrayFindIndex(
            assets,
            function(____, asset) return asset.id == assetId end
        )
        if index ~= -1 then
            __TS__ArraySplice(assets, index, 1)
        end
    end
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
function AssetManager.prototype.hasAssets(self, baseId)
    return self.assets:has(baseId)
end
function AssetManager.prototype.hasAsset(self, baseId, assetId)
    local assets = self:getAssets(baseId)
    if isEmpty(assets) then
        return false
    end
    return __TS__ArraySome(
        assets,
        function(____, asset) return asset.id == assetId end
    )
end
function AssetManager.prototype.drawAssets(self)
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue27
            end
            for ____, asset in ipairs(assets) do
                asset:drawAsset()
            end
        end
        ::__continue27::
    end
    self.textManager:drawText()
    self.gameManager.popupManager:drawPopups()
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
                goto __continue34
            end
            local asset = assets[1]
            if asset.isHidden then
                goto __continue34
            end
            if asset:inAssetBounds(gameX, gameY) then
                for ____, a in ipairs(assets) do
                    a:setMousePressed(true)
                end
            end
        end
        ::__continue34::
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
                goto __continue43
            end
            local asset = assets[1]
            if asset.isHidden then
                goto __continue43
            end
            if asset:inAssetBounds(gameX, gameY) then
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
        ::__continue43::
    end
end
function AssetManager.prototype.handleDisabledAssetClick(self, assets)
    if self.universallyDisabled then
        return
    end
    if not assets[1].useDisabledAnimation then
        return
    end
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
        if not self.gameManager.animationManager.animations:has(assetToWobble.id) then
            self.gameManager.animationManager:startAnimation(
                assetToWobble.id,
                __TS__New(
                    WobbleAnimation,
                    self.gameManager,
                    assetToWobble.id,
                    0.5,
                    10,
                    {assetToWobble}
                )
            )
        end
        if not isEmpty(assetToWobble.associatedTexts) then
            for ____, text in ipairs(assetToWobble.associatedTexts) do
                if not self.gameManager.animationManager.animations:has(text.id) then
                    self.gameManager.animationManager:startAnimation(
                        text.id,
                        __TS__New(
                            WobbleAnimation,
                            self.gameManager,
                            text.id,
                            0.5,
                            10,
                            {text}
                        )
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
                goto __continue69
            end
            local asset = assets[1]
            if asset.isDisabled or asset.isHidden then
                goto __continue69
            end
            if asset:inAssetBounds(gameX, gameY) then
                if not asset.isHovered then
                    for ____, a in ipairs(assets) do
                        a:setHovered(true)
                    end
                    local ____opt_10 = asset.onHover
                    if ____opt_10 ~= nil then
                        ____opt_10(asset, asset)
                    end
                    local ____opt_12 = asset.hoverSound
                    if not (____opt_12 and ____opt_12:isPlaying()) then
                        local ____opt_14 = asset.hoverSound
                        if ____opt_14 ~= nil then
                            ____opt_14:play()
                        end
                    end
                end
            elseif asset.isHovered then
                for ____, a in ipairs(assets) do
                    a:setHovered(false)
                end
                local ____opt_16 = asset.onUnhover
                if ____opt_16 ~= nil then
                    ____opt_16(asset, asset)
                end
            end
        end
        ::__continue69::
    end
end
function AssetManager.prototype.disableAllClickableAssets(self, disable)
    self.universallyDisabled = disable
    for ____, baseAsset in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(baseAsset) then
                goto __continue82
            end
            if isEmpty(baseAsset[1].onClick) then
                goto __continue82
            end
            for ____, asset in ipairs(baseAsset) do
                do
                    if disable then
                        self.disabledAssets:set(asset.id, {isDisabled = asset.isDisabled, useDisabledAnimation = asset.useDisabledAnimation})
                        asset:setDisabled(true)
                        asset.useDisabledAnimation = false
                    elseif self.disabledAssets:has(asset.id) then
                        local cachedState = self.disabledAssets:get(asset.id)
                        if isEmpty(cachedState) then
                            goto __continue85
                        end
                        asset:setDisabled(cachedState.isDisabled)
                        asset.useDisabledAnimation = cachedState.useDisabledAnimation
                    end
                end
                ::__continue85::
            end
        end
        ::__continue82::
    end
    if not disable then
        self.disabledAssets:clear()
    end
end
return ____exports
