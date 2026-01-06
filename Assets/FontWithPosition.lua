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
____exports.OutlineThickness = OutlineThickness or ({})
____exports.OutlineThickness.NONE = 0
____exports.OutlineThickness[____exports.OutlineThickness.NONE] = "NONE"
____exports.OutlineThickness.THIN = 1
____exports.OutlineThickness[____exports.OutlineThickness.THIN] = "THIN"
____exports.OutlineThickness.THICK = 2
____exports.OutlineThickness[____exports.OutlineThickness.THICK] = "THICK"
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
    self.outlineThickness = options and options.outlineThickness or ____exports.OutlineThickness.THIN
    if self.isDisabled then
        self:setDisabled(true)
    end
    self.color = options and options.color or ({1, 1, 1, 1})
    self.limit = options and options.limit
    self.alignMode = options and options.alignMode
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
    self:printOutline(baseX, baseY)
    love.graphics.setColor(self.color)
    local ____temp_21
    if not isEmpty(self.limit) then
        ____temp_21 = love.graphics.printf(
            self.text,
            baseX,
            baseY,
            self.limit,
            self.alignMode or "left"
        )
    else
        ____temp_21 = love.graphics.print(self.text, baseX, baseY)
    end
    self:renderIcon()
end
function FontWithPosition.prototype.printOutline(self, x, y)
    if self.outlineThickness == ____exports.OutlineThickness.NONE then
        return
    end
    love.graphics.setColor(0, 0, 0, self.color[4])
    local offsets = self.outlineThickness == ____exports.OutlineThickness.THICK and ({
        -2,
        -1,
        0,
        1,
        2
    }) or ({-1, 0, 1})
    for ____, ox in ipairs(offsets) do
        for ____, oy in ipairs(offsets) do
            do
                if ox == 0 and oy == 0 then
                    goto __continue9
                end
                love.graphics.print(self.text, x + ox, y + oy)
            end
            ::__continue9::
        end
    end
end
function FontWithPosition.prototype.getFormatOffset(self, textW)
    repeat
        local ____switch14 = self.format
        local iconWidth
        local ____cond14 = ____switch14 == ____exports.Format.LEFT
        if ____cond14 then
            return 0
        end
        ____cond14 = ____cond14 or ____switch14 == ____exports.Format.CENTER
        if ____cond14 then
            return textW / 2
        end
        ____cond14 = ____cond14 or ____switch14 == ____exports.Format.RIGHT
        if ____cond14 then
            iconWidth = self.iconFormat == ____exports.Format.RIGHT and not isEmpty(self.icon) and self.icon:getWidth() or 0
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
        local ____switch17 = self.iconFormat
        local ____cond17 = ____switch17 == ____exports.Format.LEFT
        if ____cond17 then
            love.graphics.draw(
                self.icon,
                self.x - self.icon:getWidth() - 1,
                self.y - self.icon:getHeight() / 2
            )
            break
        end
        ____cond17 = ____cond17 or ____switch17 == ____exports.Format.RIGHT
        if ____cond17 then
            love.graphics.draw(
                self.icon,
                self.x - self.icon:getWidth() + 1,
                self.y - self.icon:getHeight() / 2
            )
            break
        end
    until true
end
return ____exports
