local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____TextManager = require("Assets.TextManager")
local TextManager = ____TextManager.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.Format = Format or ({})
____exports.Format.LEFT = 0
____exports.Format[____exports.Format.LEFT] = "LEFT"
____exports.Format.CENTER = 1
____exports.Format[____exports.Format.CENTER] = "CENTER"
____exports.Format.RIGHT = 2
____exports.Format[____exports.Format.RIGHT] = "RIGHT"
____exports.default = __TS__Class()
local FontWithPosition = ____exports.default
FontWithPosition.name = "FontWithPosition"
function FontWithPosition.prototype.____constructor(self, x, y, text, options)
    self.size = options and options.size
    self.filepath = options and options.filepath or TextManager:getDefaultFontFilepath()
    self.x = x
    self.y = y
    self.text = text
    self.format = options and options.format or ____exports.Format.LEFT
end
function FontWithPosition.prototype.printFont(self)
    local font = not isEmpty(self.size) and love.graphics.newFont(self.filepath, self.size) or love.graphics.newFont(self.filepath)
    love.graphics.setFont(font)
    local textW = font:getWidth(self.text)
    local textH = font:getHeight()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(
        self.text,
        math.floor(self.x - self:getFormatOffset(textW)) + 1,
        math.floor(self.y - textH / 2) + 1
    )
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(
        self.text,
        math.floor(self.x - self:getFormatOffset(textW)),
        math.floor(self.y - textH / 2)
    )
end
function FontWithPosition.prototype.getFormatOffset(self, textW)
    repeat
        local ____switch5 = self.format
        local ____cond5 = ____switch5 == ____exports.Format.LEFT
        if ____cond5 then
            return 0
        end
        ____cond5 = ____cond5 or ____switch5 == ____exports.Format.CENTER
        if ____cond5 then
            return textW / 2
        end
        ____cond5 = ____cond5 or ____switch5 == ____exports.Format.RIGHT
        if ____cond5 then
            return textW
        end
        do
            return 0
        end
    until true
end
return ____exports
