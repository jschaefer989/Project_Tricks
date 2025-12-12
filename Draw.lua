local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local suit = require("Libraries.suit-master.suit")
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Draw = ____exports.default
Draw.name = "Draw"
function Draw.prototype.____constructor(self)
end
function Draw.card(self, card, btnW, btnH, options)
    local isSelected = card.selected
    local btnText = ((((((card.rank .. " ") .. card.suit) .. " (Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)) .. ")"
    if options and options.multiSelect then
        if isSelected then
            btnText = "[X] " .. btnText
        else
            btnText = "[ ] " .. btnText
        end
    end
    if options and options.displayCost then
        btnText = btnText .. " Cost: " .. tostring(card.cost)
    end
    local btnHit = suit.Button(
        btnText,
        {},
        suit.layout:col(btnW, btnH)
    ).hit
    if btnHit then
        if not isEmpty(options and options.onClick) then
            options:onClick(card)
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
function Draw.playerInfo(self, player, gameManager)
    local padX = 20
    local padY = 20
    local name = player.name
    local level = player.level
    local exp = player.experience
    local money = player.money
    local screenW = love.graphics.getWidth()
    local panelW = 200
    local panelX = screenW - panelW - padX
    suit.layout:reset(panelX, padY, 10, 10)
    suit.Label(
        name,
        {align = "center"},
        suit.layout:row(panelW, 24)
    )
    suit.Label(
        ((("Level: " .. tostring(level)) .. " (Next: ") .. tostring(player:getNextLevelExperience())) .. " XP)",
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    suit.Label(
        "XP: " .. tostring(exp),
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    suit.Label(
        "Money: " .. tostring(money),
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    local btnH = 30
    local perkResult = suit.Button(
        "Perks",
        {},
        suit.layout:row(panelW, btnH)
    )
    if perkResult.hit then
        gameManager:switchToPerkScreen()
    end
end
function Draw.playerDeck(self, player, options)
    local deckSize = #player.deck
    local discardSize = #player.discardPile
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelX = screenW - 170
    local panelY = screenH - 200
    if options and options.showDiscards then
        suit.layout:reset(panelX, panelY, 10, 10)
        suit.Label(
            "Discard Pile",
            {align = "center"},
            suit.layout:row(150, 30)
        )
        suit.Label(
            "Cards: " .. tostring(discardSize),
            {align = "center"},
            suit.layout:row(150, 30)
        )
    end
    suit.layout:row(0, 10)
    suit.Label(
        "Player Deck",
        {align = "center"},
        suit.layout:row(150, 30)
    )
    suit.Label(
        "Cards Remaining: " .. tostring(deckSize),
        {align = "center"},
        suit.layout:row(150, 30)
    )
end
return ____exports
