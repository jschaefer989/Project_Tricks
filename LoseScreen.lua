local object = require('Libraries.classic-master.classic')
LoseScreen = object:extend()
local suit = require('Libraries.suit-master')

function LoseScreen:new()
end

function LoseScreen:drawScreen() 
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50

    local panelX = (screenW - panelW) / 2
    local labelHeight = 36

    -- Display a game over message (centered)
    suit.layout:reset(panelX, labelY)
    suit.Label("Game Over", {align = "center"}, suit.layout:row(panelW, labelHeight))
    
    -- Create a quit button below 
    local btnW, btnH = 200, 50
    local btnY = labelY + labelHeight + 20
    suit.layout:reset(panelX, btnY)
    local btnResult = suit.Button("Quit", {}, suit.layout:row(btnW, btnH))
    if btnResult.hit then
        love.event.quit() 
    end
end