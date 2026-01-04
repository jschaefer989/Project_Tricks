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
    self.iconFormat = ____exports.Format.LEFT
    self.size = options and options.size
    self.filepath = options and options.filepath or TextManager:getDefaultFontFilepath()
    self.x = x
    self.y = y
    self.text = text
    self.format = options and options.format or ____exports.Format.LEFT
    self.icon = options and options.icon
    self.iconFormat = options and options.iconFormat or (self.format == ____exports.Format.CENTER and ____exports.Format.LEFT or self.format)
end
function FontWithPosition.prototype.printFont(self)
    local font = not isEmpty(self.size) and love.graphics.newFont(self.filepath, self.size) or love.graphics.newFont(self.filepath)
    love.graphics.setFont(font)
    local textW = font:getWidth(self.text)
    local textH = font:getHeight()
    local baseX = math.floor(self.x - self:getFormatOffset(textW))
    local baseY = math.floor(self.y - textH / 2)
    love.graphics.setColor(0, 0, 0, 1)
    local offsets = {
        -2,
        -1,
        0,
        1,
        2
    }
    for ____, ox in ipairs(offsets) do
        for ____, oy in ipairs(offsets) do
            do
                if ox == 0 and oy == 0 then
                    goto __continue5
                end
                love.graphics.print(self.text, baseX + ox, baseY + oy)
            end
            ::__continue5::
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.text, baseX, baseY)
    self:renderIcon()
end
function FontWithPosition.prototype.getFormatOffset(self, textW)
    repeat
        local ____switch10 = self.format
        local iconWidth
        local ____cond10 = ____switch10 == ____exports.Format.LEFT
        if ____cond10 then
            return 0
        end
        ____cond10 = ____cond10 or ____switch10 == ____exports.Format.CENTER
        if ____cond10 then
            return textW / 2
        end
        ____cond10 = ____cond10 or ____switch10 == ____exports.Format.RIGHT
        if ____cond10 then
            iconWidth = self.iconFormat == ____exports.Format.RIGHT and not isEmpty(self.icon) and self.icon:getWidth() + 5 or 0
            return textW + iconWidth
        end
        do
            return 0
        end
    until true
end
function FontWithPosition.prototype.renderIcon(self)
    if isEmpty(self.icon) then
        return
    end
    repeat
        local ____switch13 = self.iconFormat
        local ____cond13 = ____switch13 == ____exports.Format.LEFT
        if ____cond13 then
            love.graphics.draw(
                self.icon,
                self.x - self.icon:getWidth() - 5,
                self.y - self.icon:getHeight() / 2 + 2
            )
            break
        end
        ____cond13 = ____cond13 or ____switch13 == ____exports.Format.RIGHT
        if ____cond13 then
            love.graphics.draw(
                self.icon,
                self.x - self.icon:getWidth(),
                self.y - self.icon:getHeight() / 2 + 2
            )
            break
        end
    until true
end
return ____exports
