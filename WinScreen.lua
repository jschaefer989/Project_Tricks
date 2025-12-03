local object = require('Libraries.classic-master.classic')
WinScreen = object:extend()
local suit = require('Libraries.suit-master')

function WinScreen:new()
end

function WinScreen:drawScreen()
    -- Display the victory message (centered)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50

    -- Render player info panel centered under the Victory label
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    -- Use layout row for the Victory label
    suit.layout:reset(panelX, labelY)
    suit.Label("Victory!", {align = "center"}, suit.layout:row(panelW, labelHeight))

    local panelY = labelY + labelHeight
    local panelH = self:renderPlayerInfoPanel(panelX, panelY, panelW)

    -- Create a continue button below the player panel using layout row
    local btnW, btnH = 200, 50
    local btnY = panelY + panelH + 20
    suit.layout:reset(panelX, btnY)
    local btnResult = suit.Button("Continue", {}, suit.layout:row(btnW, btnH))
    if btnResult.hit then
        GameManager:switchToBoard()
    end
end

function WinScreen:renderPlayerInfoPanel(x, y, panelW)
    local name = Player.name or "Player"
    local level = Player.level or 1
    local exp = Player.experience or 0
    local money = Player.money or 0

    suit.layout:reset(x, y)
    suit.Label(name, {align = "center"}, suit.layout:row(panelW, 24))
    suit.Label("Level: " .. level, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("XP: " .. exp, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("Money: " .. money, {align = "left"}, suit.layout:row(panelW, 22))

    -- Return the computed panel height so callers can place elements below
    local totalHeight = 24 + 22 * 3
    return totalHeight
end