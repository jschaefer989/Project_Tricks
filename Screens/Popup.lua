local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
____exports.default = __TS__Class()
local Popup = ____exports.default
Popup.name = "Popup"
function Popup.prototype.____constructor(self, gameManager)
    self.isOpen = false
    self.associatedAssets = {}
    self.savedMusicVolume = 1
    self.pausedAnimationIds = {}
    self.pausedAssetIds = __TS__New(Map)
    self.pausedShaderIds = {}
    self.pausedSources = {}
    self.pausedTextIds = __TS__New(Map)
    self.popupBackground = love.graphics.newImage("Assets/Images/Popup.png")
    self.gameManager = gameManager
end
function Popup.prototype.open(self, associatedAssets)
    self.associatedAssets = associatedAssets
    self:buildCaches()
    self:pauseAllAnimations()
    self:pauseAllShaders()
    self:disableAllAssets()
    self:lowerMusicVolume()
    self:disableAllText()
    self.gameManager.assetManager.tooltipManager:hideTooltip()
    self.pausedSources = love.audio.pause()
    local popupWidth = 400
    local popupHeight = 350
    self.gameManager.assetManager:addAsset(
        AssetIds.POPUP_BACKGROUND,
        __TS__New(
            Asset,
            self.gameManager,
            AssetIds.POPUP_BACKGROUND,
            self.popupBackground,
            (push:getWidth() - popupWidth) / 2,
            (push:getHeight() - popupHeight) / 2,
            popupWidth,
            popupHeight
        )
    )
    self.isOpen = true
end
function Popup.prototype.close(self)
    self:restoreMusicVolume()
    self:resumeAllAnimations()
    self:resumeAllShaders()
    self:enableAllAssets()
    self:enableAllText()
    self:playPausedSounds()
    self.gameManager.assetManager:removeAssets(AssetIds.POPUP_BACKGROUND)
    self.isOpen = false
end
function Popup.prototype.buildCaches(self)
    for ____, id in __TS__Iterator(self.gameManager.animationManager.animations:keys()) do
        local ____self_pausedAnimationIds_0 = self.pausedAnimationIds
        ____self_pausedAnimationIds_0[#____self_pausedAnimationIds_0 + 1] = id
    end
    for ____, id in __TS__Iterator(self.gameManager.shaderManager.shaders:keys()) do
        local ____self_pausedShaderIds_1 = self.pausedShaderIds
        ____self_pausedShaderIds_1[#____self_pausedShaderIds_1 + 1] = id
    end
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.assets) do
        local baseId = ____value[1]
        local assets = ____value[2]
        self.pausedAssetIds:set(baseId, {isDisabled = assets[1].isDisabled, useDisabledAnimation = assets[1].useDisabledAnimation})
    end
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.textManager.texts) do
        local id = ____value[1]
        local font = ____value[2]
        self.pausedTextIds:set(id, font.isDisabled)
    end
end
function Popup.prototype.pauseAllAnimations(self)
    for ____, animation in __TS__Iterator(self.gameManager.animationManager.animations:values()) do
        animation.isPaused = true
    end
end
function Popup.prototype.pauseAllShaders(self)
    for ____, shader in __TS__Iterator(self.gameManager.shaderManager.shaders:values()) do
        shader.isPaused = true
    end
end
function Popup.prototype.disableAllAssets(self)
    for ____, assets in __TS__Iterator(self.gameManager.assetManager.assets:values()) do
        for ____, asset in ipairs(assets) do
            asset:setDisabled(true, {useDisabledAnimation = false, showDisabledColor = true})
        end
    end
end
function Popup.prototype.disableAllText(self)
    for ____, font in __TS__Iterator(self.gameManager.assetManager.textManager.texts:values()) do
        font:setDisabled(true)
    end
end
function Popup.prototype.lowerMusicVolume(self)
    self.savedMusicVolume = love.audio.getVolume()
    love.audio.setVolume(self.savedMusicVolume * 0.3)
end
function Popup.prototype.restoreMusicVolume(self)
    love.audio.setVolume(self.savedMusicVolume)
end
function Popup.prototype.resumeAllAnimations(self)
    for ____, id in ipairs(self.pausedAnimationIds) do
        local animation = self.gameManager.animationManager.animations:get(id)
        if not isEmpty(animation) then
            animation.isPaused = false
        end
    end
    self.pausedAnimationIds = {}
end
function Popup.prototype.resumeAllShaders(self)
    for ____, id in ipairs(self.pausedShaderIds) do
        local shader = self.gameManager.shaderManager.shaders:get(id)
        if not isEmpty(shader) then
            shader.isPaused = false
        end
    end
    self.pausedShaderIds = {}
end
function Popup.prototype.enableAllAssets(self)
    for ____, ____value in __TS__Iterator(self.pausedAssetIds) do
        local baseId = ____value[1]
        local disabledState = ____value[2]
        local assets = self.gameManager.assetManager:getAssets(baseId)
        if not isEmpty(assets) then
            for ____, asset in ipairs(assets) do
                asset:setDisabled(disabledState.isDisabled, {useDisabledAnimation = disabledState.useDisabledAnimation})
            end
        end
    end
    self.pausedAssetIds:clear()
end
function Popup.prototype.enableAllText(self)
    for ____, ____value in __TS__Iterator(self.pausedTextIds) do
        local id = ____value[1]
        local isDisabled = ____value[2]
        local font = self.gameManager.assetManager.textManager.texts:get(id)
        if not isEmpty(font) then
            font:setDisabled(isDisabled)
        end
    end
    self.pausedTextIds:clear()
end
function Popup.prototype.playPausedSounds(self)
    for ____, source in ipairs(self.pausedSources) do
        do
            pcall(function()
                source:play()
            end)
        end
    end
    self.pausedSources = {}
end
function Popup.prototype.drawPopup(self)
    if not self.gameManager.popup.isOpen then
        return
    end
    local asset = self.gameManager.assetManager:getAsset(AssetIds.POPUP_BACKGROUND, AssetIds.POPUP_BACKGROUND)
    if asset ~= nil then
        asset:drawAsset()
    end
    for ____, asset in ipairs(self.associatedAssets) do
        if __TS__InstanceOf(asset, Asset) then
            asset:drawAsset()
        elseif __TS__InstanceOf(asset, FontWithPosition) then
            asset:printText()
        end
    end
end
function Popup.prototype.handleMousePressed(self, x, y, button)
    if not self.gameManager.popup.isOpen then
        return false
    end
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return false
    end
    local asset = self.gameManager.assetManager:getAsset(AssetIds.POPUP_BACKGROUND, AssetIds.POPUP_BACKGROUND)
    if isEmpty(asset) then
        return false
    end
    if not asset:inAssetBounds(gameX, gameY) then
        return true
    end
    return false
end
function Popup.prototype.handleMouseReleased(self, x, y, button)
    if not self.gameManager.popup.isOpen then
        return false
    end
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return false
    end
    local asset = self.gameManager.assetManager:getAsset(AssetIds.POPUP_BACKGROUND, AssetIds.POPUP_BACKGROUND)
    if isEmpty(asset) then
        return false
    end
    if not asset:inAssetBounds(gameX, gameY) then
        self:close()
        return true
    end
    return false
end
return ____exports
