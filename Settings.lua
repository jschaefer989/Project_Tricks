local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local push = require("Libraries.push")
---
-- @noSelfInFile
local WindowOptions = WindowOptions or ({})
WindowOptions.WINDOWED = "WINDOWED"
WindowOptions.FULLSCREEN = "FULLSCREEN"
____exports.default = __TS__Class()
local Settings = ____exports.default
Settings.name = "Settings"
function Settings.prototype.____constructor(self)
    self.playMusic = true
    self.playSoundEffects = true
    self.windowSetting = WindowOptions.WINDOWED
    self.dealerSpeed = 0.25
end
function Settings.prototype.apply(self)
    repeat
        local ____switch4 = self.windowSetting
        local ____cond4 = ____switch4 == WindowOptions.FULLSCREEN
        if ____cond4 then
            self:setupFullscreenMode()
            break
        end
        ____cond4 = ____cond4 or ____switch4 == WindowOptions.WINDOWED
        if ____cond4 then
            self:setupWindowedMode()
            break
        end
        do
            exhaustiveGuard(self.windowSetting)
        end
    until true
    self.playMusic = false
end
function Settings.prototype.setupWindowedMode(self)
    local gameWidth = 640
    local gameHeight = 360
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
