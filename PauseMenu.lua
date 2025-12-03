local object = require('Libraries.classic-master.classic')
PauseMenu = object:extend()
local suit = require('Libraries.suit-master')

function PauseMenu:new()
end

function PauseMenu:drawScreen()
    -- Display the victory message (centered)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50

    -- Render player info panel centered under the Victory label
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    -- Use layout row for the Victory label
    suit.layout:reset(panelX, labelY)
    suit.Label("Paused", {align = "center"}, suit.layout:row(panelW, labelHeight))

    local panelY = labelY + labelHeight

    -- Create a continue button below the player panel using layout row
    local btnW, btnH = 200, 50
    local playBtnY = panelY  + 20
    suit.layout:reset(panelX, playBtnY)
    local btnResult = suit.Button("Continue", {}, suit.layout:row(btnW, btnH))
    if btnResult.hit then
        GameStateManager:revertState()
    end

    -- Create a quit button directly below the play button
    local quitBtnY = playBtnY + btnH + 10
    suit.layout:reset(panelX, quitBtnY)
    local quitResult = suit.Button("Quit", {}, suit.layout:row(btnW, btnH))
    if quitResult.hit then
        love.event.quit()
    end
end