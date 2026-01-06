if pcall(require, "lldebugger") then require("lldebugger").start() end
if pcall(require, "mobdebug") then require("mobdebug").start() end
local lualib = require("lualib_bundle")
local tsNew = lualib.__TS__New
local suit = require('Libraries.suit-master.suit')
local GameStateManager = require("Libraries.GameStateManager-main.gamestateManager")
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
local Text = require("Libraries.SYSL-Text-master.example.library.slog-text")
local push = require("Libraries.push")
_G.SYSLText = Text -- Make it globally available for TypeScript
local GameManager = require("GameManager").default
local gameManager = tsNew(GameManager)

love.graphics.setDefaultFilter("nearest", "nearest", 1)

function love.load()    
    love.window.setTitle("Tricks")
    love.keyboard.setKeyRepeat(true)
    math.randomseed(os.time() + os.clock())

    gameManager.settings:apply()
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
    suit.keypressed(key)
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

function love.mousepressed(x, y, button)
    GameStateManager:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    GameStateManager:mousereleased(x, y, button)
end

function love.resize(w, h)
    push:resize(w, h)
end
