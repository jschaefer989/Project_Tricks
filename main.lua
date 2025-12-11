if pcall(require, "lldebugger") then require("lldebugger").start() end
if pcall(require, "mobdebug") then require("mobdebug").start() end
local ____lualib = require("lualib_bundle")
local __TS__New = ____lualib.__TS__New
local suit = require('Libraries.suit-master.suit')
local GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
local GameManager = require("GameManager").default
local gameManager = __TS__New(GameManager)

function love.load()    
    love.window.setTitle("Tricks")
    math.randomseed(os.time() + os.clock())

    -- TODO: load settings properly
    --global.GAME_MANAGER.settings:loadFromTable(saveData.settings or {})
    gameManager.settings:defaults()
    gameManager:switchToMainMenu()
end

function love.mousepressed(x, y, button)
    GameStateManager:mousepressed(x, y, button)
end

function love.draw()
    GameStateManager:draw()
    suit.draw()
    lovelyToasts.draw()
end

function love.resize(w, h)
    GameStateManager:resize(w, h)
end

function love.update(dt)
    GameStateManager:update(dt)
    lovelyToasts.update(dt)
end

function love.textinput(text)
    suit.textinput(text)
    GameStateManager:textinput(text)
end

function love.keypressed(key, scancode, isrepeat)
    GameStateManager:keypressed(key, scancode, isrepeat)
    
    if gameManager.gameState ~= "MAIN_MENU" then
        if key == "escape" then
            gameManager:switchToPauseMenu()
        end
    end
end

function love.keyreleased(key, scancode)
    GameStateManager:keyreleased(key, scancode)
end
