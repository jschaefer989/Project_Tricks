if pcall(require, "lldebugger") then require("lldebugger").start() end
if pcall(require, "mobdebug") then require("mobdebug").start() end
require "Dealer"
require "GameManager"
require "Enums"
require "Settings"
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
local suit = require('Libraries.suit-master')

GameManager = GameManager()
Player = Player()
Settings = Settings()

function love.load()    
    love.window.setTitle("Tricks")
    math.randomseed(os.time() + os.clock())
    -- TODO: load settings properly
    --GameManager.settings:loadFromTable(saveData.settings or {})
    Settings:defaults()

    GameManager:switchToMainMenu()
end

function love.mousepressed(x, y, button)
    GameStateManager:mousepressed(x, y, button)
end

function love.draw()
    GameStateManager:draw()
    --push.start(push)
    suit.draw()
    lovelyToasts.draw()
    --push.finish(push)
end

function love.resize(w, h)
    GameStateManager:resize(w, h)
end

function love.update(dt)
    GameStateManager:update(dt)
    lovelyToasts.update(dt)
end

function love.textinput(text)
    GameStateManager:textinput(text)
end

function love.keypressed(key, scancode, isrepeat)
    GameStateManager:keypressed(key, scancode, isrepeat)
    
    if GameManager.gameState ~= GameStates.MAIN_MENU then
        if key == "escape" then
            GameManager:switchToPauseMenu()
        end
    end
end

function love.keyreleased(key, scancode)
    GameStateManager:keyreleased(key, scancode)
end