local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
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
____exports.Fonts = Fonts or ({})
____exports.Fonts.STANDARD = "Assets/Fonts/Germania.ttf"
____exports.Fonts.FANTASY = "Assets/Fonts/dpcomic.ttf"
____exports.Fonts.ELOQUENT = "Assets/Fonts/Bitmgothic.ttf"
____exports.Highlights = Highlights or ({})
____exports.Highlights.HEARTS = "//HEARTS//"
____exports.Highlights.BELLS = "//BELLS//"
____exports.Highlights.ACORNS = "//ACORNS//"
____exports.Highlights.LEAVES = "//LEAVES//"
____exports.Highlights.EDEL = "//EDEL//"
____exports.default = __TS__Class()
local FontWithPosition = ____exports.default
FontWithPosition.name = "FontWithPosition"
function FontWithPosition.prototype.____constructor(self, id, x, y, text, options)
    self.iconFormat = ____exports.Format.LEFT
    self.isDisabled = false
    self.color = {1, 1, 1, 1}
    local size = options and options.size or 9
    local font = options and options.font or ____exports.Fonts.STANDARD
    self.font = love.graphics.newFont(font, size)
    self.id = id
    self.x = x
    self.y = y
    self.text = text
    self.xLocation = options and options.xLocation or ____exports.Format.LEFT
    self.icon = options and options.icon
    self.iconFormat = options and options.iconFormat or (self.xLocation == ____exports.Format.CENTER and ____exports.Format.LEFT or self.xLocation)
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
function FontWithPosition.prototype.printText(self)
    love.graphics.setFont(self.font)
    local textW = self.font:getWidth(self.text)
    local textH = self.font:getHeight()
    local baseX = math.floor(self.x - self:getFormatOffset(textW))
    local baseY = math.floor(self.y - textH / 2)
    self:printOutline(baseX, baseY)
    local segments = self:parseHighlights(self.text)
    local currentX = baseX
    if not isEmpty(self.limit) and self.alignMode == ____exports.Format.CENTER then
        local cleanText = self:stripHighlights(self.text)
        local totalWidth = self.font:getWidth(cleanText)
        currentX = baseX + (self.limit - totalWidth) / 2
    end
    for ____, segment in ipairs(segments) do
        love.graphics.setColor(segment.color)
        love.graphics.print(segment.text, currentX, baseY)
        currentX = currentX + self.font:getWidth(segment.text)
    end
    self:renderIcon()
end
function FontWithPosition.prototype.parseHighlights(self, text)
    local segments = {}
    local remaining = text
    local currentColor = self.color
    while #remaining > 0 do
        local foundHighlight = false
        for ____, highlight in ipairs(__TS__ObjectValues(____exports.Highlights)) do
            if __TS__StringStartsWith(remaining, highlight) then
                remaining = __TS__StringSubstring(remaining, #highlight)
                local result = self:extractNextWord(remaining)
                if #result.word > 0 then
                    segments[#segments + 1] = {
                        text = result.word,
                        color = self:getColorForHighlight(highlight)
                    }
                    remaining = __TS__StringSubstring(remaining, result.consumed)
                    currentColor = self.color
                    foundHighlight = true
                    break
                end
            end
        end
        if not foundHighlight then
            local nextPos = #remaining
            for ____, highlight in ipairs(__TS__ObjectValues(____exports.Highlights)) do
                local pos = (string.find(remaining, highlight, nil, true) or 0) - 1
                if pos ~= -1 then
                    nextPos = math.min(nextPos, pos)
                end
            end
            local chunk = __TS__StringSubstring(remaining, 0, nextPos)
            if #chunk > 0 then
                segments[#segments + 1] = {text = chunk, color = currentColor}
            end
            remaining = __TS__StringSubstring(remaining, nextPos)
        end
    end
    return #segments > 0 and segments or ({{text = self.text, color = self.color}})
end
function FontWithPosition.prototype.extractNextWord(self, text)
    local i = 0
    while i < #text and (__TS__StringAccess(text, i) == " " or __TS__StringAccess(text, i) == "\t" or __TS__StringAccess(text, i) == "\n") do
        i = i + 1
    end
    local wordStart = i
    while i < #text and __TS__StringAccess(text, i) ~= " " and __TS__StringAccess(text, i) ~= "\t" and __TS__StringAccess(text, i) ~= "\n" do
        i = i + 1
    end
    return {
        word = __TS__StringSubstring(text, wordStart, i),
        consumed = i
    }
end
function FontWithPosition.prototype.textHasHighlights(self, text)
    for ____, highlight in ipairs(__TS__ObjectValues(____exports.Highlights)) do
        if (string.find(text, highlight, nil, true) or 0) - 1 ~= -1 then
            return true
        end
    end
    return false
end
function FontWithPosition.prototype.stripHighlights(self, text)
    local result = text
    for ____, highlight in ipairs(__TS__ObjectValues(____exports.Highlights)) do
        result = table.concat(
            __TS__StringSplit(result, highlight),
            ""
        )
    end
    return result
end
function FontWithPosition.prototype.printOutline(self, x, y)
    if self.outlineThickness == ____exports.OutlineThickness.NONE then
        return
    end
    local offsets = self.outlineThickness == ____exports.OutlineThickness.THICK and ({
        -2,
        -1,
        0,
        1,
        2
    }) or ({-1, 0, 1})
    local hasHighlights = self:textHasHighlights(self.text)
    love.graphics.setColor(0, 0, 0, self.color[4])
    if not isEmpty(self.limit) and not hasHighlights then
        for ____, ox in ipairs(offsets) do
            for ____, oy in ipairs(offsets) do
                do
                    if ox == 0 and oy == 0 then
                        goto __continue34
                    end
                    love.graphics.printf(
                        self.text,
                        x + ox,
                        y + oy,
                        self.limit,
                        self.alignMode == ____exports.Format.CENTER and "center" or "left"
                    )
                end
                ::__continue34::
            end
        end
    else
        local segments = self:parseHighlights(self.text)
        local currentX = x
        if not isEmpty(self.limit) and self.alignMode == ____exports.Format.CENTER then
            local cleanText = self:stripHighlights(self.text)
            local totalWidth = self.font:getWidth(cleanText)
            currentX = x + (self.limit - totalWidth) / 2
        end
        for ____, segment in ipairs(segments) do
            love.graphics.setColor(0, 0, 0, segment.color[4])
            for ____, ox in ipairs(offsets) do
                for ____, oy in ipairs(offsets) do
                    do
                        if ox == 0 and oy == 0 then
                            goto __continue42
                        end
                        love.graphics.print(segment.text, currentX + ox, y + oy)
                    end
                    ::__continue42::
                end
            end
            currentX = currentX + self.font:getWidth(segment.text)
        end
    end
end
function FontWithPosition.prototype.getFormatOffset(self, textW)
    repeat
        local ____switch48 = self.xLocation
        local iconWidth
        local ____cond48 = ____switch48 == ____exports.Format.LEFT
        if ____cond48 then
            return 0
        end
        ____cond48 = ____cond48 or ____switch48 == ____exports.Format.CENTER
        if ____cond48 then
            return textW / 2
        end
        ____cond48 = ____cond48 or ____switch48 == ____exports.Format.RIGHT
        if ____cond48 then
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
        local ____switch51 = self.iconFormat
        local ____cond51 = ____switch51 == ____exports.Format.LEFT
        if ____cond51 then
            if self.alignMode == ____exports.Format.CENTER then
                love.graphics.draw(
                    self.icon.image,
                    self.x + self.limit / 2 - self.font:getWidth(self.text) / 2 - self.icon:getWidth() - 2,
                    self.y - self.icon:getHeight() / 2
                )
            else
                love.graphics.draw(
                    self.icon.image,
                    self.x - self.icon:getWidth() - 2,
                    self.y - self.icon:getHeight() / 2
                )
            end
            break
        end
        ____cond51 = ____cond51 or ____switch51 == ____exports.Format.RIGHT
        if ____cond51 then
            love.graphics.draw(
                self.icon.image,
                self.x - self.icon:getWidth() + 1,
                self.y - self.icon:getHeight() / 2
            )
            break
        end
    until true
end
function FontWithPosition.prototype.getColorForHighlight(self, marker)
    repeat
        local ____switch55 = marker
        local ____cond55 = ____switch55 == ____exports.Highlights.HEARTS
        if ____cond55 then
            return {1, 0, 0, 1}
        end
        ____cond55 = ____cond55 or ____switch55 == ____exports.Highlights.BELLS
        if ____cond55 then
            return {1, 0.84, 0, 1}
        end
        ____cond55 = ____cond55 or ____switch55 == ____exports.Highlights.ACORNS
        if ____cond55 then
            return {0.55, 0.27, 0.07, 1}
        end
        ____cond55 = ____cond55 or ____switch55 == ____exports.Highlights.LEAVES
        if ____cond55 then
            return {0, 0.5, 0, 1}
        end
        ____cond55 = ____cond55 or ____switch55 == ____exports.Highlights.EDEL
        if ____cond55 then
            return {1, 0.84, 0, 1}
        end
        do
            exhaustiveGuard(marker)
        end
    until true
end
return ____exports
