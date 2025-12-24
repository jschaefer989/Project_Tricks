local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local FontManager = ____exports.default
FontManager.name = "FontManager"
function FontManager.prototype.____constructor(self)
    self.texts = __TS__New(Map)
end
function FontManager.prototype.drawText(self)
    local prevFont = love.graphics.getFont()
    for ____, font in __TS__Iterator(self.texts:values()) do
        font:printFont()
    end
    love.graphics.setColor(1, 1, 1, 1)
    if not isEmpty(prevFont) then
        love.graphics.setFont(prevFont)
    end
end
function FontManager.prototype.addText(self, id, font)
    self.texts:set(id, font)
end
function FontManager.prototype.getText(self, id)
    return self.texts:get(id)
end
function FontManager.prototype.hideAsset(self, id)
    self.texts:delete(id)
end
function FontManager.getDefaultFontFilepath(self)
    return "Assets/Fonts/Gothic Pixels.ttf"
end
function FontManager.setDefaultFont(self)
    local mainFont = love.graphics.newFont(self:getDefaultFontFilepath())
    love.graphics.setFont(mainFont)
    return mainFont
end
return ____exports
