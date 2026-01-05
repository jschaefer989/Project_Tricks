local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local TextManager = ____exports.default
TextManager.name = "TextManager"
function TextManager.prototype.____constructor(self)
    self.texts = __TS__New(Map)
end
function TextManager.prototype.drawText(self)
    local prevFont = love.graphics.getFont()
    for ____, font in __TS__Iterator(self.texts:values()) do
        font:printFont()
    end
    love.graphics.setColor(1, 1, 1, 1)
    if not isEmpty(prevFont) then
        love.graphics.setFont(prevFont)
    end
end
function TextManager.prototype.addText(self, id, font)
    self.texts:set(id, font)
end
function TextManager.prototype.getText(self, id)
    return self.texts:get(id)
end
function TextManager.prototype.hideText(self, id)
    self.texts:delete(id)
end
function TextManager.prototype.updateText(self, id, newText)
    local text = self.texts:get(id)
    if not isEmpty(text) then
        text.text = newText
    end
end
function TextManager.prototype.disableText(self, id)
    local text = self.texts:get(id)
    if not isEmpty(text) then
        text:setDisabled(true)
    end
end
function TextManager.prototype.enableText(self, id)
    local text = self.texts:get(id)
    if not isEmpty(text) then
        text:setDisabled(false)
    end
end
function TextManager.getDefaultFontFilepath(self)
    return "Assets/Fonts/Germania.ttf"
end
function TextManager.setDefaultFont(self)
    local mainFont = love.graphics.newFont(self:getDefaultFontFilepath())
    love.graphics.setFont(mainFont)
    return mainFont
end
return ____exports
