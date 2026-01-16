local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Fonts = ____FontWithPosition.Fonts
local Format = ____FontWithPosition.Format
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local TextIds = ____Enums.TextIds
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
local ____DisabledStateCache = require("Assets.DisabledStateCache")
local DisabledStateCache = ____DisabledStateCache.default
____exports.PopupSizes = PopupSizes or ({})
____exports.PopupSizes.MESSAGE_BOX = "MESSAGE_BOX"
____exports.PopupSizes.MENU = "MENU"
____exports.default = __TS__Class()
local Popup = ____exports.default
Popup.name = "Popup"
function Popup.prototype.____constructor(self, gameManager, id, popupSize, title, associatedAssetIds, associatedTextIds, options)
    self.isActive = true
    self.associatedAssetIds = {}
    self.associatedTextIds = {}
    self.savedMusicVolume = 1
    self.pausedAnimationIds = {}
    self.pausedShaderIds = {}
    self.pausedSources = {}
    self.pausedTextIds = __TS__New(Map)
    self.gameManager = gameManager
    self.id = id
    self.popupSize = popupSize
    self.associatedAssetIds = associatedAssetIds
    self.associatedTextIds = associatedTextIds
    self.disabledStateCache = __TS__New(DisabledStateCache, self.gameManager)
    self.onClose = options and options.onClose
    self:buildCaches()
    self:disableAllAssets()
    self:disableAllText()
    self:lowerMusicVolume()
    self:pauseAllAnimations()
    self:pauseAllShaders()
    self.gameManager.assetManager.tooltipManager:hideTooltip()
    self.pausedSources = love.audio.pause()
    self:addTitle(title)
    self:buildPopup()
    local ____temp_4 = options and options.animateIn
    if ____temp_4 == nil then
        ____temp_4 = true
    end
    if ____temp_4 then
        self:startSlideAnimation()
    end
end
function Popup.prototype.close(self)
    self:restoreMusicVolume()
    self:resumeAllAnimations()
    self:resumeAllShaders()
    self:enableAllAssets()
    self:enableAllText()
    self:playPausedSounds()
    self:removeAssets()
    self:removeTexts()
    local ____opt_5 = self.onClose
    if ____opt_5 ~= nil then
        ____opt_5(self)
    end
end
function Popup.prototype.buildPopup(self)
    local popupAsset = __TS__New(
        Asset,
        self.gameManager,
        self:getPopupBackgroundId(),
        self:getPopupBackground(),
        (push:getWidth() - ____exports.default:getPopupWidth(self.popupSize)) / 2,
        ____exports.default:getTopOfPopup(self.popupSize),
        ____exports.default:getPopupWidth(self.popupSize),
        ____exports.default:getPopupHeight(self.popupSize)
    )
    self.gameManager.assetManager:addAsset(
        self:getPopupBackgroundId(),
        popupAsset
    )
    local ____self_associatedAssetIds_7 = self.associatedAssetIds
    ____self_associatedAssetIds_7[#____self_associatedAssetIds_7 + 1] = self:getPopupBackgroundId()
end
function Popup.prototype.getPopupBackground(self)
    repeat
        local ____switch7 = self.popupSize
        local ____cond7 = ____switch7 == ____exports.PopupSizes.MESSAGE_BOX
        if ____cond7 then
            return self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PopupMessageBox.png")
        end
        ____cond7 = ____cond7 or ____switch7 == ____exports.PopupSizes.MENU
        if ____cond7 then
            return self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PopupMenu.png")
        end
    until true
end
function Popup.prototype.startSlideAnimation(self)
    local startY = push:getHeight()
    for ____, id in ipairs(self.associatedAssetIds) do
        do
            local assets = self.gameManager.assetManager.assets:get(id)
            if isEmpty(assets) then
                goto __continue9
            end
            for ____, a in ipairs(assets) do
                local finalY = a.y
                a.y = startY
                self.gameManager.animationManager:startAnimation(
                    a.id,
                    __TS__New(
                        SlideAnimation,
                        self.gameManager,
                        a.id,
                        0.15,
                        0,
                        finalY - startY,
                        {a},
                        {bounceEffect = true}
                    )
                )
            end
        end
        ::__continue9::
    end
    for ____, id in ipairs(self.associatedTextIds) do
        do
            local text = self.gameManager.assetManager.textManager.texts:get(id)
            if isEmpty(text) then
                goto __continue14
            end
            local finalY = text.y
            text.y = startY
            self.gameManager.animationManager:startAnimation(
                text.id,
                __TS__New(
                    SlideAnimation,
                    self.gameManager,
                    text.id,
                    0.15,
                    0,
                    finalY - startY,
                    {text},
                    {bounceEffect = true}
                )
            )
        end
        ::__continue14::
    end
end
function Popup.prototype.buildCaches(self)
    for ____, id in __TS__Iterator(self.gameManager.animationManager.animations:keys()) do
        local ____self_pausedAnimationIds_8 = self.pausedAnimationIds
        ____self_pausedAnimationIds_8[#____self_pausedAnimationIds_8 + 1] = id
    end
    for ____, id in __TS__Iterator(self.gameManager.shaderManager.shaders:keys()) do
        local ____self_pausedShaderIds_9 = self.pausedShaderIds
        ____self_pausedShaderIds_9[#____self_pausedShaderIds_9 + 1] = id
    end
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.assets) do
        local baseId = ____value[1]
        local assets = ____value[2]
        do
            if __TS__ArrayIncludes(self.associatedAssetIds, baseId) then
                goto __continue22
            end
            self.disabledStateCache:cacheState(assets[1])
        end
        ::__continue22::
    end
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.textManager.texts) do
        local id = ____value[1]
        local font = ____value[2]
        do
            if __TS__ArrayIncludes(self.associatedTextIds, id) then
                goto __continue25
            end
            self.pausedTextIds:set(id, font.isDisabled)
        end
        ::__continue25::
    end
end
function Popup.prototype.addTitle(self, title)
    local titleFont = __TS__New(
        FontWithPosition,
        self:getPopupTitleId(),
        ____exports.default:getCenterOfPopup(self.popupSize),
        ____exports.default:getTopOfPopup(self.popupSize) + self:getTitleOffset(),
        title,
        {font = Fonts.FANTASY, size = 16, xLocation = Format.CENTER}
    )
    self.gameManager.assetManager.textManager:addText(
        self:getPopupTitleId(),
        titleFont
    )
    local ____self_associatedTextIds_10 = self.associatedTextIds
    ____self_associatedTextIds_10[#____self_associatedTextIds_10 + 1] = self:getPopupTitleId()
end
function Popup.prototype.getTitleOffset(self)
    repeat
        local ____switch30 = self.popupSize
        local ____cond30 = ____switch30 == ____exports.PopupSizes.MESSAGE_BOX
        if ____cond30 then
            return 13
        end
        ____cond30 = ____cond30 or ____switch30 == ____exports.PopupSizes.MENU
        if ____cond30 then
            return 17
        end
    until true
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
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.assets) do
        local id = ____value[1]
        local assets = ____value[2]
        do
            if __TS__ArrayIncludes(self.associatedAssetIds, id) then
                goto __continue38
            end
            for ____, asset in ipairs(assets) do
                asset:setDisabled(true, {useDisabledAnimation = false, showDisabledColor = true})
            end
        end
        ::__continue38::
    end
end
function Popup.prototype.disableAllText(self)
    for ____, ____value in __TS__Iterator(self.gameManager.assetManager.textManager.texts) do
        local id = ____value[1]
        local font = ____value[2]
        do
            if __TS__ArrayIncludes(self.associatedTextIds, id) then
                goto __continue44
            end
            font:setDisabled(true)
        end
        ::__continue44::
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
end
function Popup.prototype.resumeAllShaders(self)
    for ____, id in ipairs(self.pausedShaderIds) do
        local shader = self.gameManager.shaderManager.shaders:get(id)
        if not isEmpty(shader) then
            shader.isPaused = false
        end
    end
end
function Popup.prototype.enableAllAssets(self)
    self.disabledStateCache:restore(self.associatedAssetIds)
end
function Popup.prototype.enableAllText(self)
    for ____, ____value in __TS__Iterator(self.pausedTextIds) do
        local id = ____value[1]
        local isDisabled = ____value[2]
        do
            if __TS__ArrayIncludes(self.associatedTextIds, id) then
                goto __continue59
            end
            local font = self.gameManager.assetManager.textManager.texts:get(id)
            if not isEmpty(font) then
                font:setDisabled(isDisabled)
            end
        end
        ::__continue59::
    end
end
function Popup.prototype.playPausedSounds(self)
    for ____, source in ipairs(self.pausedSources) do
        do
            pcall(function()
                source:play()
            end)
        end
    end
end
function Popup.prototype.handleMousePressed(self, x, y, button)
    if not self.isActive then
        return false
    end
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return false
    end
    local asset = self.gameManager.assetManager:getAsset(
        self:getPopupBackgroundId(),
        self:getPopupBackgroundId()
    )
    if isEmpty(asset) then
        return false
    end
    if not asset:inAssetBounds(gameX, gameY) then
        return true
    end
    return false
end
function Popup.prototype.handleMouseReleased(self, x, y, button)
    if not self.isActive then
        return false
    end
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return false
    end
    local asset = self.gameManager.assetManager:getAsset(
        self:getPopupBackgroundId(),
        self:getPopupBackgroundId()
    )
    if isEmpty(asset) then
        return false
    end
    if not asset:inAssetBounds(gameX, gameY) then
        self.gameManager.popupManager:close()
        return true
    end
    return false
end
function Popup.prototype.drawPopup(self)
    local asset = self.gameManager.assetManager:getAsset(
        self:getPopupBackgroundId(),
        self:getPopupBackgroundId()
    )
    if asset ~= nil then
        asset:drawAsset()
    end
    for ____, id in ipairs(self.associatedAssetIds) do
        do
            if id == self:getPopupBackgroundId() then
                goto __continue78
            end
            local asset = self.gameManager.assetManager:getAssets(id)
            if isEmpty(asset) then
                goto __continue78
            end
            for ____, a in ipairs(asset) do
                a:drawAsset()
            end
        end
        ::__continue78::
    end
    for ____, id in ipairs(self.associatedTextIds) do
        do
            local text = self.gameManager.assetManager.textManager.texts:get(id)
            if isEmpty(text) then
                goto __continue84
            end
            text:printText()
        end
        ::__continue84::
    end
end
function Popup.prototype.removeAssets(self)
    self.gameManager.assetManager:removeAssets(self:getPopupBackgroundId())
    for ____, id in ipairs(self.associatedAssetIds) do
        self.gameManager.assetManager:removeAssets(id)
    end
end
function Popup.prototype.removeTexts(self)
    for ____, id in ipairs(self.associatedTextIds) do
        self.gameManager.assetManager.textManager:hideText(id)
    end
end
function Popup.getPopupWidth(self, popupSize)
    repeat
        local ____switch94 = popupSize
        local ____cond94 = ____switch94 == ____exports.PopupSizes.MESSAGE_BOX
        if ____cond94 then
            return 264
        end
        ____cond94 = ____cond94 or ____switch94 == ____exports.PopupSizes.MENU
        if ____cond94 then
            return 400
        end
        do
            exhaustiveGuard(popupSize)
        end
    until true
end
function Popup.getPopupHeight(self, popupSize)
    repeat
        local ____switch96 = popupSize
        local ____cond96 = ____switch96 == ____exports.PopupSizes.MESSAGE_BOX
        if ____cond96 then
            return 264
        end
        ____cond96 = ____cond96 or ____switch96 == ____exports.PopupSizes.MENU
        if ____cond96 then
            return 350
        end
        do
            exhaustiveGuard(popupSize)
        end
    until true
end
function Popup.getTopOfPopup(self, popupSize)
    return (push:getHeight() - ____exports.default:getPopupHeight(popupSize)) / 2 - 5
end
function Popup.getCenterOfPopup(self, popupSize)
    local popupWidth = ____exports.default:getPopupWidth(popupSize)
    return popupWidth / 2 + (push:getWidth() - popupWidth) / 2
end
function Popup.getBottomOfPopup(self, popupSize)
    return ____exports.default:getTopOfPopup(popupSize) + ____exports.default:getPopupHeight(popupSize)
end
function Popup.prototype.getPopupBackgroundId(self)
    return AssetIds.POPUP_BACKGROUND .. self.id
end
function Popup.prototype.getPopupTitleId(self)
    return TextIds.POPUP_TITLE .. self.id
end
return ____exports
