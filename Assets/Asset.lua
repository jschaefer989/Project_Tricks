local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
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
end
function Asset.prototype.updatePosition(self, x, y)
    self.x = x
    self.y = y
end
function Asset.prototype.updateOrientation(self, orientation)
    self.orientation = orientation
end
function Asset.prototype.updateScale(self, scaleX, scaleY)
    self.scaleX = scaleX
    self.scaleY = scaleY
end
function Asset.prototype.updateOffset(self, offsetX, offsetY)
    self.offsetX = offsetX
    self.offsetY = offsetY
end
function Asset.prototype.setHovered(self, hovered)
    self.isHovered = hovered
end
function Asset.prototype.setDisabled(self, disabled)
    self.isDisabled = disabled
    self.color = disabled and ({0.5, 0.5, 0.5, 1}) or ({1, 1, 1, 1})
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
