local object = require('Libraries.classic-master.classic')
MainMenu = object:extend()
local suit = require('Libraries.suit-master')
require "Save"

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
    
    -- Create a continue button below the title
    local btnW, btnH = 200, 50
    local continueBtnY = labelY + labelHeight + 20
    local saveExists = love.filesystem.getInfo("savegame.json")
    if saveExists then
        suit.layout:reset(panelX, continueBtnY)
        local continueResult = suit.Button("Continue", {}, suit.layout:row(btnW, btnH))
        if continueResult.hit then
            Save.load()
            GameManager:switchBasedOnGameState()
        end
    end

    -- Create a new game button below the continue button
    local newGameBtnY = ternary(saveExists, continueBtnY + btnH + 10, continueBtnY)
    suit.layout:reset(panelX, newGameBtnY)
    local newGameResult = suit.Button("New Game", {}, suit.layout:row(btnW, btnH))
    if newGameResult.hit then
        self:initializeNewGame()
        -- TODO: need an "are you sure?" prompt here
        GameManager:switchToBoard()
    end

    -- Create a quit button below the new game button
    local quitBtnY = newGameBtnY + btnH + 10
    suit.layout:reset(panelX, quitBtnY)
    local quitResult = suit.Button("Quit", {}, suit.layout:row(btnW, btnH))
    if quitResult.hit then
        love.event.quit()
    end
end

function MainMenu:initializeNewGame()
    -- TODO: might need to do more here
    Dealer:initializePlayerDeck()
end
