local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Enums = require("Enums")
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, id, image, x, y, constructionOptions)
    self.isDisabled = false
    self.isHovered = false
    self.color = {1, 1, 1, 1}
    self.id = id
    self.image = image
    self.x = x
    self.y = y
    self.onClick = constructionOptions and constructionOptions.onClick
    self.onHover = constructionOptions and constructionOptions.onHover
    self.orientation = constructionOptions and constructionOptions.orientation or 0
    self.scaleX = constructionOptions and constructionOptions.scaleX or 1
    self.scaleY = constructionOptions and constructionOptions.scaleY or 1
    self.offsetX = constructionOptions and constructionOptions.offsetX or 0
    self.offsetY = constructionOptions and constructionOptions.offsetY or 0
    local ____temp_16 = constructionOptions and constructionOptions.isDisabled
    if ____temp_16 == nil then
        ____temp_16 = false
    end
    self.isDisabled = ____temp_16
    self.clickSound = constructionOptions and constructionOptions.clickSound
    self.associatedTexts = constructionOptions and constructionOptions.associatedTexts
    self.hoverEffect = constructionOptions and constructionOptions.hoverEffect or HoverEffects.NONE
    self.mousePressEffect = constructionOptions and constructionOptions.mousePressEffect or MousePressEffects.NONE
end
function Asset.prototype.updatePosition(self, x, y)
    self.x = x
    self.y = y
end
function Asset.prototype.setHovered(self, hovered)
    self.isHovered = hovered
    repeat
        local ____switch5 = self.hoverEffect
        local ____cond5 = ____switch5 == HoverEffects.NONE
        if ____cond5 then
            break
        end
        ____cond5 = ____cond5 or ____switch5 == HoverEffects.CHANGE_COLOR
        if ____cond5 then
            self:setColor()
            break
        end
        ____cond5 = ____cond5 or ____switch5 == HoverEffects.SCALE_UP
        if ____cond5 then
            if hovered then
                local imgWidth = self.image:getWidth()
                local imgHeight = self.image:getHeight()
                local oldWidth = imgWidth * self.scaleX
                local oldHeight = imgHeight * self.scaleY
                self.scaleX = self.scaleX + 0.2
                self.scaleY = self.scaleY + 0.2
                local newWidth = imgWidth * self.scaleX
                local newHeight = imgHeight * self.scaleY
                self.offsetX = self.offsetX + (newWidth - oldWidth) / 2
                self.offsetY = self.offsetY + (newHeight - oldHeight) / 2
            else
                local imgWidth = self.image:getWidth()
                local imgHeight = self.image:getHeight()
                local oldWidth = imgWidth * self.scaleX
                local oldHeight = imgHeight * self.scaleY
                self.scaleX = self.scaleX - 0.2
                self.scaleY = self.scaleY - 0.2
                local newWidth = imgWidth * self.scaleX
                local newHeight = imgHeight * self.scaleY
                self.offsetX = self.offsetX + (newWidth - oldWidth) / 2
                self.offsetY = self.offsetY + (newHeight - oldHeight) / 2
            end
            break
        end
        do
            exhaustiveGuard(self.hoverEffect)
        end
    until true
end
function Asset.prototype.setDisabled(self, disabled)
    self.isDisabled = disabled
    self:setColor()
end
function Asset.prototype.setColor(self)
    if self.isDisabled then
        self.color = {0.5, 0.5, 0.5, 1}
    elseif self.isHovered then
        self.color = {0.8, 0.8, 1, 1}
    else
        self.color = {1, 1, 1, 1}
    end
end
function Asset.prototype.getWidth(self)
    local imgWidth = self.image:getWidth()
    return imgWidth * math.abs(self.scaleX)
end
function Asset.prototype.getHeight(self)
    local imgHeight = self.image:getHeight()
    return imgHeight * math.abs(self.scaleY)
end
return ____exports
