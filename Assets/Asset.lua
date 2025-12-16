local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Asset = ____exports.default
Asset.name = "Asset"
function Asset.prototype.____constructor(self, image, x, y, onClick, width, height, orientation, scaleX, scaleY, offsetX, offsetY)
    self.disabled = false
    self.hidden = false
    self.image = image
    self.x = x
    self.y = y
    self.onClick = onClick or (function()
    end)
    self.width = width or 0
    self.height = height or 0
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
function Asset.prototype.updateWidth(self, width)
    self.width = width
end
function Asset.prototype.updateHeight(self, height)
    self.height = height
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
    self.disabled = disabled
end
function Asset.prototype.setHidden(self, hidden)
    self.hidden = hidden
end
return ____exports
