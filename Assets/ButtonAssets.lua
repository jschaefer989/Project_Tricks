local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
____exports.default = __TS__Class()
local ButtonAssets = ____exports.default
ButtonAssets.name = "ButtonAssets"
function ButtonAssets.prototype.____constructor(self, gameManager)
    self.letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png")
    self.baseW = self.letsFightButton:getWidth()
    self.baseH = self.letsFightButton:getHeight()
    self.gameManager = gameManager
end
function ButtonAssets.prototype.addAsset(self, buttonX, buttonY, onClick, options)
    local assetId = AssetIds.LETS_FIGHT_BUTTON
    self.gameManager.assetManager:addAsset(
        assetId,
        __TS__New(
            Asset,
            assetId,
            self.letsFightButton,
            buttonX,
            buttonY,
            onClick,
            options and options.onHover,
            self.baseW,
            self.baseH
        )
    )
end
function ButtonAssets.prototype.getAsset(self, assetId)
    return self.gameManager.assetManager:getAsset(assetId)
end
function ButtonAssets.prototype.hideButton(self, buttonId)
    self.gameManager.assetManager.assets:delete(buttonId)
end
return ____exports
