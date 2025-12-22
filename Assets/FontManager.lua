local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
____exports.default = __TS__Class()
local FontManager = ____exports.default
FontManager.name = "FontManager"
function FontManager.prototype.____constructor(self)
    self.fonts = __TS__New(Map)
end
function FontManager.prototype.drawText(self)
    local prevFont = love.graphics.getFont()
    for ____, font in __TS__Iterator(self.fonts:values()) do
        if font.id == AssetIds.ATTACK_BUTTON then
            local text = "Attack"
            local bigFont = love.graphics.newFont(28)
            love.graphics.setFont(bigFont)
            local textW = bigFont:getWidth(text)
            local textH = bigFont:getHeight()
            local centerX = asset.x + asset:getWidth() / 2
            local centerY = asset.y + asset:getHeight() / 2
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(
                text,
                math.floor(centerX - textW / 2) + 1,
                math.floor(centerY - textH / 2) + 1
            )
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(
                text,
                math.floor(centerX - textW / 2),
                math.floor(centerY - textH / 2)
            )
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    if not isEmpty(nil, prevFont) then
        love.graphics.setFont(prevFont)
    end
end
return ____exports
