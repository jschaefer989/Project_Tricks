local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local GameStates = ____Enums.GameStates
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
____exports.default = __TS__Class()
local BackgroundManager = ____exports.default
BackgroundManager.name = "BackgroundManager"
function BackgroundManager.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function BackgroundManager.prototype.updateBackground(self, gameState)
    local backgroundImage = self:getBackgroundImage(gameState)
    if isEmpty(backgroundImage) then
        return
    end
    self.gameManager.assetManager:addAsset(
        AssetIds.BACKGROUND,
        __TS__New(
            Asset,
            self.gameManager,
            AssetIds.BACKGROUND,
            backgroundImage,
            0,
            0,
            push:getWidth(),
            push:getHeight()
        )
    )
end
function BackgroundManager.prototype.getBackgroundImage(self, gameState)
    repeat
        local ____switch6 = gameState
        local ____cond6 = ____switch6 == GameStates.MAIN_MENU
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.BOARD
        if ____cond6 then
            return self.gameManager.assetManager.assetLoader:loadImage(self.gameManager.biome.boardBackgroundImagePath)
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.WIN_SCREEN
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.LOSE_SCREEN
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.MAP
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.SHOP
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.LEVEL_UP
        if ____cond6 then
            return
        end
        ____cond6 = ____cond6 or ____switch6 == GameStates.NEW_GAME_MENU
        if ____cond6 then
            return
        end
        do
            exhaustiveGuard(gameState)
        end
    until true
end
return ____exports
