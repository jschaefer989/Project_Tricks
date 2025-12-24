local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____TextManager = require("Assets.TextManager")
local TextManager = ____TextManager.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local FontWithPosition = ____exports.default
FontWithPosition.name = "FontWithPosition"
function FontWithPosition.prototype.____constructor(self, x, y, text, options)
    self.size = options and options.size
    self.filepath = options and options.filepath or TextManager:getDefaultFontFilepath()
    self.x = x
    self.y = y
    self.text = text
end
function FontWithPosition.prototype.printFont(self)
    local font = not isEmpty(self.size) and love.graphics.newFont(self.filepath, self.size) or love.graphics.newFont(self.filepath)
    love.graphics.setFont(font)
    local textW = font:getWidth(self.text)
    local textH = font:getHeight()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(
        self.text,
        math.floor(self.x - textW / 2) + 1,
        math.floor(self.y - textH / 2) + 1
    )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        self.text,
        math.floor(self.x - textW / 2),
        math.floor(self.y - textH / 2)
    )
end
return ____exports
