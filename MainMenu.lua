local object = require('Libraries.classic-master.classic')
MainMenu = object:extend()
local suit = require('Libraries.suit-master')

function MainMenu:new()
end

function MainMenu:drawScreen()
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50

    local panelX = (screenW - panelW) / 2
    local labelHeight = 36

    -- Display a game over message (centered)
    suit.layout:reset(panelX, labelY)
    suit.Label("Tricks", {align = "center"}, suit.layout:row(panelW, labelHeight))
    
    -- Create a play button below
    local btnW, btnH = 200, 50
    local playBtnY = labelY + labelHeight + 20
    suit.layout:reset(panelX, playBtnY)
    local playResult = suit.Button("Play", {}, suit.layout:row(btnW, btnH))
    if playResult.hit then
        GameManager:switchToBoard()
    end

    -- Create a quit button directly below the play button
    local quitBtnY = playBtnY + btnH + 10
    suit.layout:reset(panelX, quitBtnY)
    local quitResult = suit.Button("Quit", {}, suit.layout:row(btnW, btnH))
    if quitResult.hit then
        love.event.quit()
    end
end
