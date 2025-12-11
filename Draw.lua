local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local Draw = ____exports.default
Draw.name = "Draw"
function Draw.prototype.____constructor(self)
end
function Draw.card(self, gameManager, card, btnW, btnH, onlySelectOne)
    local isSelected = card.selected
    local btnText = ((((((card.rank .. " ") .. card.suit) .. " (Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)) .. ")"
    if isSelected then
        btnText = "[X] " .. btnText
    else
        btnText = "[ ] " .. btnText
    end
    local btnHit = suit.Button(
        btnText,
        {},
        suit.layout:col(btnW, btnH)
    ).hit
    if btnHit then
        if onlySelectOne then
            if gameManager.board and gameManager.board.dealer then
                gameManager.board.dealer:deselectAllCards()
            end
        end
        card.selected = not card.selected
    end
end
function Draw.loadImage(self, path)
    local success, imageOrError = pcall(function() return love.graphics.newImage(path) end)
    if success then
        return imageOrError
    end
end
function Draw.drawBackgroundImage(self, image)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    love.graphics.draw(
        image,
        0,
        0,
        0,
        screenW / image:getWidth(),
        screenH / image:getHeight()
    )
end
function Draw.setThemeColors(self, r, g, b)
    suit.theme.color.normal.fg = {r, g, b}
end
return ____exports
