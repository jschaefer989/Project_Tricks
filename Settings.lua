local push = require('Libraries.push')
local object = require('Libraries.classic-master.classic')
Settings = object:extend()

function Settings:new()
end

function Settings:defaults()
    -- Load settings from a file or set defaults
    self:setupFullscreenMode()
end

function Settings:setupWindowedMode()
    local gameWidth, gameHeight = 1920, 1080  --fixed game resolution
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    windowWidth, windowHeight = windowWidth-25, windowHeight-60 --make the window a bit smaller than the screen itself
    push.setupScreen(push, gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})
end

function Settings:setupFullscreenMode()
    -- Configure push for fullscreen using the desktop resolution
    local gameWidth, gameHeight = 1920, 1080
    local windowWidth, windowHeight = love.window.getDesktopDimensions()

    -- Some platforms report the desktop size as 0 when not yet initialized;
    -- fall back to the game resolution in that case.
    if not windowWidth or windowWidth == 0 then windowWidth = gameWidth end
    if not windowHeight or windowHeight == 0 then windowHeight = gameHeight end

    -- Use the same call style as existing code (push.setupScreen(push, ...))
    push.setupScreen(push, gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})
end
