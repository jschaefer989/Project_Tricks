local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, id, image, x, y, onClick, onHover, orientation, scaleX, scaleY, offsetX, offsetY)
    self.isDisabled = false
    self.id = id
    self.image = image
    self.x = x
    self.y = y
    self.onClick = onClick or (function()
    end)
    self.onHover = onHover
    self.orientation = orientation or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
    self.offsetX = offsetX or 0
    self.offsetY = offsetY or 0
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
function Asset.prototype.setDisabled(self, disabled)
    self.isDisabled = disabled
end
function Asset.prototype.setHoverable(self, hoverable)
    self.hoverable = hoverable
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
