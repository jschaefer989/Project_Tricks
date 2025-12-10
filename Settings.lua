local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local push = require("Libraries.push")
____exports.default = __TS__Class()
local Settings = ____exports.default
Settings.name = "Settings"
function Settings.prototype.____constructor(self)
end
function Settings.prototype.defaults(self)
    self:setupWindowedMode()
end
function Settings.prototype.setupWindowedMode(self)
    local gameWidth = 1920
    local gameHeight = 1080
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    windowWidth = windowWidth - 25
    windowHeight = windowHeight - 60
    push:setupScreen(
        gameWidth,
        gameHeight,
        windowWidth,
        windowHeight,
        {fullscreen = false}
    )
end
function Settings.prototype.setupFullscreenMode(self)
    local gameWidth = 1920
    local gameHeight = 1080
    local windowWidth, windowHeight = love.window.getDesktopDimensions()
    if not windowWidth or windowWidth == 0 then
        windowWidth = gameWidth
    end
    if not windowHeight or windowHeight == 0 then
        windowHeight = gameHeight
    end
    push:setupScreen(
        gameWidth,
        gameHeight,
        windowWidth,
        windowHeight,
        {fullscreen = true}
    )
end
return ____exports
