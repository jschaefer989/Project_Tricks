local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local ____ShimmerShader = require("Shaders.ShimmerShader")
local ShimmerShader = ____ShimmerShader.default
local ____WobbleAnimation = require("Assets.Animations.WobbleAnimation")
local WobbleAnimation = ____WobbleAnimation.default
local disabledColor = {0.5, 0.5, 0.5, 1}
local normalColor = {1, 1, 1, 1}
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, gameManager, id, image, x, y, width, height, constructionOptions)
    self.quads = {}
    self.isDisabled = false
    self.useDisabledAnimation = true
    self.showDisabledColor = true
    self.isHovered = false
    self.isPressed = false
    self.color = {1, 1, 1, 1}
    self.isHidden = false
    self.gameManager = gameManager
    self.id = id
    self.image = image
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.onClick = constructionOptions and constructionOptions.onClick
    self.onHover = constructionOptions and constructionOptions.onHover
    self.onUnhover = constructionOptions and constructionOptions.onUnhover
    self.orientation = constructionOptions and constructionOptions.orientation or 0
    self.scaleX = constructionOptions and constructionOptions.scaleX or 1
    self.scaleY = constructionOptions and constructionOptions.scaleY or 1
    self.offsetX = constructionOptions and constructionOptions.offsetX or 0
    self.offsetY = constructionOptions and constructionOptions.offsetY or 0
    self.quads = constructionOptions and constructionOptions.quads or ({})
    local ____temp_20 = constructionOptions and constructionOptions.isDisabled
    if ____temp_20 == nil then
        ____temp_20 = false
    end
    self.isDisabled = ____temp_20
    local ____temp_23 = constructionOptions and constructionOptions.useDisabledAnimation
    if ____temp_23 == nil then
        ____temp_23 = true
    end
    self.useDisabledAnimation = ____temp_23
    local ____temp_26 = constructionOptions and constructionOptions.showDisabledColor
    if ____temp_26 == nil then
        ____temp_26 = true
    end
    self.showDisabledColor = ____temp_26
    self.clickSound = constructionOptions and constructionOptions.clickSound
    self.hoverSound = constructionOptions and constructionOptions.hoverSound
    self.associatedTexts = constructionOptions and constructionOptions.associatedTexts
    self.hoverEffect = constructionOptions and constructionOptions.hoverEffect or ({HoverEffects.NONE})
    self.mousePressEffect = constructionOptions and constructionOptions.mousePressEffect or ({MousePressEffects.NONE})
end
function Asset.prototype.drawAsset(self)
    if self.isHidden then
        return
    end
    love.graphics.setColor(self.color)
    self.gameManager.shaderManager:applyShaders(self)
    if #self.quads > 0 then
        for ____, quad in ipairs(self.quads) do
            love.graphics.draw(
                self.image,
                quad.quad,
                self.x + quad.x,
                self.y + quad.y,
                self.orientation,
                self.scaleX,
                self.scaleY,
                self.offsetX,
                self.offsetY
            )
        end
    else
        love.graphics.draw(
            self.image,
            self.x,
            self.y,
            self.orientation,
            self.scaleX,
            self.scaleY,
            self.offsetX,
            self.offsetY
        )
    end
    self.gameManager.shaderManager:removeShaders()
    love.graphics.setColor(1, 1, 1, 1)
end
function Asset.prototype.updatePosition(self, x, y)
    self.x = x
    self.y = y
end
function Asset.prototype.setHovered(self, hovered)
    if self.gameManager.assetManager.universallyDisabled then
        return
    end
    self.isHovered = hovered
    self:handleHoverEffects(hovered)
end
function Asset.prototype.handleHoverEffects(self, hovered)
    for ____, effect in ipairs(self.hoverEffect) do
        repeat
            local ____switch14 = effect
            local ____cond14 = ____switch14 == HoverEffects.NONE
            if ____cond14 then
                break
            end
            ____cond14 = ____cond14 or ____switch14 == HoverEffects.CHANGE_COLOR
            if ____cond14 then
                self:setColor()
                break
            end
            ____cond14 = ____cond14 or ____switch14 == HoverEffects.SCALE_UP
            if ____cond14 then
                self:scaleUp(hovered)
                break
            end
            ____cond14 = ____cond14 or ____switch14 == HoverEffects.SHIFT_UP
            if ____cond14 then
                self:shiftUp(hovered)
                break
            end
            ____cond14 = ____cond14 or ____switch14 == HoverEffects.SHIMMER
            if ____cond14 then
                self:shimmer(hovered)
                break
            end
            ____cond14 = ____cond14 or ____switch14 == HoverEffects.WOBBLE
            if ____cond14 then
                self:wobble(hovered)
                break
            end
            do
                exhaustiveGuard(effect)
            end
        until true
    end
end
function Asset.prototype.setMousePressed(self, pressed)
    local wasPressed = self.isPressed
    if self.gameManager.assetManager.universallyDisabled and not wasPressed then
        return
    end
    self.isPressed = pressed
    self:handleMousePressEffects(pressed, wasPressed)
end
function Asset.prototype.handleMousePressEffects(self, pressed, wasPressed)
    for ____, effect in ipairs(self.mousePressEffect) do
        repeat
            local ____switch20 = effect
            local ____cond20 = ____switch20 == MousePressEffects.NONE
            if ____cond20 then
                break
            end
            ____cond20 = ____cond20 or ____switch20 == MousePressEffects.DARKEN
            if ____cond20 then
                self:setColor()
                break
            end
            ____cond20 = ____cond20 or ____switch20 == MousePressEffects.SCALE_DOWN
            if ____cond20 then
                self:scaleDown(pressed)
                break
            end
            ____cond20 = ____cond20 or ____switch20 == MousePressEffects.SHIFT_DOWN
            if ____cond20 then
                self:shiftDown(pressed, wasPressed)
                break
            end
            do
                exhaustiveGuard(effect)
            end
        until true
    end
end
function Asset.prototype.setDisabled(self, disabled, options)
    self.isDisabled = disabled
    local ____temp_39 = options and options.useDisabledAnimation
    if ____temp_39 == nil then
        ____temp_39 = true
    end
    self.useDisabledAnimation = ____temp_39
    if disabled then
        if not self.showDisabledColor and not (options and options.showDisabledColor) then
            return
        end
        self.color = disabledColor
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text:setDisabled(true)
            end
        end
    else
        self.color = normalColor
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text:setDisabled(false)
            end
        end
    end
end
function Asset.prototype.setColor(self)
    if self.isDisabled then
        self.color = disabledColor
    elseif self.isPressed then
        self.color = {0.7, 0.6, 0.4, 1}
    elseif self.isHovered then
        self.color = {1, 0.9, 0.7, 1}
    else
        self.color = normalColor
    end
end
function Asset.prototype.getWidth(self)
    return self.width
end
function Asset.prototype.getHeight(self)
    return self.height
end
function Asset.prototype.scaleDown(self, pressed)
    if pressed then
        self.scaleX = self.scaleX * 0.95
        self.scaleY = self.scaleY * 0.95
    else
        self.scaleX = self.scaleX / 0.95
        self.scaleY = self.scaleY / 0.95
    end
end
function Asset.prototype.scaleUp(self, hovered)
    if hovered then
        local imgWidth = self:getWidth()
        local imgHeight = self:getHeight()
        local oldWidth = imgWidth * self.scaleX
        local oldHeight = imgHeight * self.scaleY
        self.scaleX = self.scaleX * 1.05
        self.scaleY = self.scaleY * 1.05
        local newWidth = imgWidth * self.scaleX
        local newHeight = imgHeight * self.scaleY
        self.offsetX = self.offsetX + (newWidth - oldWidth) / 2
        self.offsetY = self.offsetY + (newHeight - oldHeight) / 2
    else
        local imgWidth = self:getWidth()
        local imgHeight = self:getHeight()
        local oldWidth = imgWidth * self.scaleX
        local oldHeight = imgHeight * self.scaleY
        self.scaleX = self.scaleX / 1.05
        self.scaleY = self.scaleY / 1.05
        local newWidth = imgWidth * self.scaleX
        local newHeight = imgHeight * self.scaleY
        self.offsetX = self.offsetX + (newWidth - oldWidth) / 2
        self.offsetY = self.offsetY + (newHeight - oldHeight) / 2
    end
end
function Asset.prototype.shiftDown(self, pressed, wasPressed)
    if pressed then
        self.offsetY = self.offsetY - 3
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text.y = text.y + 3
            end
        end
    elseif wasPressed then
        self.offsetY = self.offsetY + 3
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text.y = text.y - 3
            end
        end
    end
end
function Asset.prototype.shiftUp(self, hovered)
    if hovered then
        self.offsetY = self.offsetY + 3
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text.y = text.y - 3
            end
        end
    elseif not hovered then
        self.offsetY = self.offsetY - 3
        if not isEmpty(self.associatedTexts) then
            for ____, text in ipairs(self.associatedTexts) do
                text.y = text.y + 3
            end
        end
    end
end
function Asset.prototype.shimmer(self, hovered)
    if not hovered then
        return
    end
    self.gameManager.shaderManager:addShader(
        self.id,
        __TS__New(
            ShimmerShader,
            self.gameManager,
            function() return not self.isHovered end,
            {self}
        )
    )
end
function Asset.prototype.wobble(self, hovered)
    if not hovered then
        return
    end
    if not self.gameManager.animationManager.animations:has(self.id) then
        self.gameManager.animationManager:startAnimation(
            self.id,
            __TS__New(
                WobbleAnimation,
                self.gameManager,
                self.id,
                0.2,
                2,
                {self}
            )
        )
    end
end
function Asset.prototype.inAssetBounds(self, gameX, gameY)
    return gameX >= self.x and gameX <= self.x + self:getWidth() and gameY >= self.y and gameY <= self.y + self:getHeight()
end
return ____exports
