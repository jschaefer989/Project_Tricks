local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
____exports.default = __TS__Class()
local IconAsset = ____exports.default
IconAsset.name = "IconAsset"
__TS__ClassExtends(IconAsset, Asset)
function IconAsset.prototype.____constructor(self, gameManager, id, image, width, height, constructionOptions)
    Asset.prototype.____constructor(
        self,
        gameManager,
        id,
        image,
        0,
        0,
        width,
        height,
        constructionOptions
    )
end
function IconAsset.getPowerIconAsset(self, gameManager, id)
    return __TS__New(
        ____exports.default,
        gameManager,
        id,
        gameManager.assetManager.assetLoader:loadImage("Assets/Images/AttackPower.png"),
        9,
        9
    )
end
function IconAsset.getValueIconAsset(self, gameManager, id)
    return __TS__New(
        ____exports.default,
        gameManager,
        id,
        gameManager.assetManager.assetLoader:loadImage("Assets/Images/Value.png"),
        9,
        9
    )
end
return ____exports
