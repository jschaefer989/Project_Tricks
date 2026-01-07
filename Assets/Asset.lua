local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Enums = require("Enums")
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, id, image, x, y, width, height, constructionOptions)
    self.isDisabled = false
    self.isHovered = false
    self.isPressed = false
    self.color = {1, 1, 1, 1}
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
    local ____temp_18 = constructionOptions and constructionOptions.isDisabled
    if ____temp_18 == nil then
        ____temp_18 = false
    end
    self.isDisabled = ____temp_18
    self.clickSound = constructionOptions and constructionOptions.clickSound
    self.associatedTexts = constructionOptions and constructionOptions.associatedTexts
    self.hoverEffect = constructionOptions and constructionOptions.hoverEffect or ({HoverEffects.NONE})
    self.mousePressEffect = constructionOptions and constructionOptions.mousePressEffect or ({MousePressEffects.NONE})
end
function Asset.prototype.drawAsset(self)
    love.graphics.setColor(self.color)
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
            local ____switch8 = effect
            local ____cond8 = ____switch8 == HoverEffects.NONE
            if ____cond8 then
                break
            end
            ____cond8 = ____cond8 or ____switch8 == HoverEffects.CHANGE_COLOR
            if ____cond8 then
                self:setColor()
                break
            end
            ____cond8 = ____cond8 or ____switch8 == HoverEffects.SCALE_UP
            if ____cond8 then
                self:scaleUp(hovered)
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
            local ____switch13 = effect
            local ____cond13 = ____switch13 == MousePressEffects.NONE
            if ____cond13 then
                break
            end
            ____cond13 = ____cond13 or ____switch13 == MousePressEffects.DARKEN
            if ____cond13 then
                self:setColor()
                break
            end
            ____cond13 = ____cond13 or ____switch13 == MousePressEffects.SCALE_DOWN
            if ____cond13 then
                self:scaleDown(pressed)
                break
            end
            ____cond13 = ____cond13 or ____switch13 == MousePressEffects.SHIFT_DOWN
            if ____cond13 then
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
return ____exports
