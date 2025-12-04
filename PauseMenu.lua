local object = require('Libraries.classic-master.classic')
PauseMenu = object:extend()
local suit = require('Libraries.suit-master')
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
require "Save"

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

    -- Create a continue button below the label
    local btnW, btnH = 200, 50
    local continueBtnY = panelY + 20
    suit.layout:reset(panelX, continueBtnY)
    local continueResult = suit.Button("Continue", {}, suit.layout:row(btnW, btnH))
    if continueResult.hit then
        GameStateManager:revertState()
    end

    -- Create a save button below the continue button
    local saveBtnY = continueBtnY + btnH + 10
    suit.layout:reset(panelX, saveBtnY)
    local saveResult = suit.Button("Save", {}, suit.layout:row(btnW, btnH))
    if saveResult.hit then
        if not Save.save() then
            lovelyToasts.show("Error saving game!")
        else
            lovelyToasts.show("Game saved successfully.")
        end
    end

    -- Create a quit button below the save button
    local quitBtnY = saveBtnY + btnH + 10
    suit.layout:reset(panelX, quitBtnY)
    local quitResult = suit.Button("Quit", {}, suit.layout:row(btnW, btnH))
    if quitResult.hit then
        love.event.quit()
    end
end