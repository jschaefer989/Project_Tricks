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
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, gameManager, id, image, x, y, width, height, constructionOptions)
    self.quads = {}
    self.isDisabled = false
    self.useDisabledAnimation = true
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
    self.isHovered = hovered
    self:handleHoverEffects(hovered)
end
function Asset.prototype.handleHoverEffects(self, hovered)
    for ____, effect in ipairs(self.hoverEffect) do
        repeat
            local ____switch13 = effect
            local ____cond13 = ____switch13 == HoverEffects.NONE
            if ____cond13 then
                break
            end
            ____cond13 = ____cond13 or ____switch13 == HoverEffects.CHANGE_COLOR
            if ____cond13 then
                self:setColor()
                break
            end
            ____cond13 = ____cond13 or ____switch13 == HoverEffects.SCALE_UP
            if ____cond13 then
                self:scaleUp(hovered)
                break
            end
            ____cond13 = ____cond13 or ____switch13 == HoverEffects.SHIFT_UP
            if ____cond13 then
                self:shiftUp(hovered)
                break
            end
            ____cond13 = ____cond13 or ____switch13 == HoverEffects.SHIMMER
            if ____cond13 then
                self:shimmer(hovered)
                break
            end
            ____cond13 = ____cond13 or ____switch13 == HoverEffects.WOBBLE
            if ____cond13 then
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
    self.isPressed = pressed
    self:handleMousePressEffects(pressed, wasPressed)
end
function Asset.prototype.handleMousePressEffects(self, pressed, wasPressed)
    for ____, effect in ipairs(self.mousePressEffect) do
        repeat
            local ____switch18 = effect
            local ____cond18 = ____switch18 == MousePressEffects.NONE
            if ____cond18 then
                break
            end
            ____cond18 = ____cond18 or ____switch18 == MousePressEffects.DARKEN
            if ____cond18 then
                self:setColor()
                break
            end
            ____cond18 = ____cond18 or ____switch18 == MousePressEffects.SCALE_DOWN
            if ____cond18 then
                self:scaleDown(pressed)
                break
            end
            ____cond18 = ____cond18 or ____switch18 == MousePressEffects.SHIFT_DOWN
            if ____cond18 then
                self:shiftDown(pressed, wasPressed)
                break
            end
            do
                exhaustiveGuard(effect)
            end
        until true
    end
end
function Asset.prototype.setDisabled(self, disabled)
    self.isDisabled = disabled
    self:setColor()
end
function Asset.prototype.setColor(self)
    if self.isDisabled then
        self.color = {0.5, 0.5, 0.5, 1}
    elseif self.isPressed then
        self.color = {0.7, 0.6, 0.4, 1}
    elseif self.isHovered then
        self.color = {1, 0.9, 0.7, 1}
    else
        self.color = {1, 1, 1, 1}
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
    local wobbleId = "wobble-hover-" .. self.id
    if not self.gameManager.animationManager.animations:has(wobbleId) then
        self.gameManager.animationManager:startAnimation(
            wobbleId,
            __TS__New(WobbleAnimation, 0.2, 2, {self})
        )
    end
end
return ____exports
