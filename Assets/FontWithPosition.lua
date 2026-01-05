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
function FontWithPosition.prototype.____constructor(self, id, x, y, text, options)
    self.iconFormat = ____exports.Format.LEFT
    self.isDisabled = false
    self.color = {1, 1, 1, 1}
    self.id = id
    self.size = options and options.size
    self.filepath = options and options.filepath or TextManager:getDefaultFontFilepath()
    self.x = x
    self.y = y
    self.text = text
    self.format = options and options.format or ____exports.Format.LEFT
    self.icon = options and options.icon
    self.iconFormat = options and options.iconFormat or (self.format == ____exports.Format.CENTER and ____exports.Format.LEFT or self.format)
    local ____temp_12 = options and options.isDisabled
    if ____temp_12 == nil then
        ____temp_12 = false
    end
    self.isDisabled = ____temp_12
end
function FontWithPosition.prototype.setDisabled(self, disabled)
    self.isDisabled = disabled
    self.color = disabled and ({0.5, 0.5, 0.5, 1}) or ({1, 1, 1, 1})
end
function FontWithPosition.prototype.printFont(self)
    local font = not isEmpty(self.size) and love.graphics.newFont(self.filepath, self.size) or love.graphics.newFont(self.filepath)
    love.graphics.setFont(font)
    local textW = font:getWidth(self.text)
    local textH = font:getHeight()
    local baseX = math.floor(self.x - self:getFormatOffset(textW))
    local baseY = math.floor(self.y - textH / 2)
    love.graphics.setColor(0, 0, 0, self.color[4])
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
                    goto __continue6
                end
                love.graphics.print(self.text, baseX + ox, baseY + oy)
            end
            ::__continue6::
        end
    end
    love.graphics.setColor(self.color)
    love.graphics.print(self.text, baseX, baseY)
    self:renderIcon()
end
function FontWithPosition.prototype.getFormatOffset(self, textW)
    repeat
        local ____switch11 = self.format
        local iconWidth
        local ____cond11 = ____switch11 == ____exports.Format.LEFT
        if ____cond11 then
            return 0
        end
        ____cond11 = ____cond11 or ____switch11 == ____exports.Format.CENTER
        if ____cond11 then
            return textW / 2
        end
        ____cond11 = ____cond11 or ____switch11 == ____exports.Format.RIGHT
        if ____cond11 then
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
    love.graphics.setColor(self.color)
    repeat
        local ____switch14 = self.iconFormat
        local ____cond14 = ____switch14 == ____exports.Format.LEFT
        if ____cond14 then
            love.graphics.draw(
                self.icon,
                self.x - self.icon:getWidth() - 5,
                self.y - self.icon:getHeight() / 2 + 2
            )
            break
        end
        ____cond14 = ____cond14 or ____switch14 == ____exports.Format.RIGHT
        if ____cond14 then
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
