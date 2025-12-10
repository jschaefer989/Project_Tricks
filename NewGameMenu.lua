local object = require('Libraries.classic-master.classic')
NewGameMenu = object:extend()
local suit = require('Libraries.suit-master')
require "Save"

function NewGameMenu:new()
end

function NewGameMenu:drawScreen()
    suit.layout:reset(50, 50)
    suit.Label("New Game Menu", {}, suit.layout:row(400, 50))

    suit.layout:padding(10, 10)

    local btnW, btnH = 200, 50

    suit.layout:push(suit.layout:row(btnW, btnH))
    local startResult = suit.Button("Start New Game", {}, suit.layout:col(btnW, btnH))
    if startResult.hit then
        GameManager.board = Board()
        GameManager:switchToBoard()
    end
    suit.layout:pop()

    suit.layout:push(suit.layout:row(btnW, btnH))
    local backResult = suit.Button("Back to Main Menu", {}, suit.layout:col(btnW, btnH))
    if backResult.hit then
        GameManager:switchToMainMenu()
    end
    suit.layout:pop()
end
