local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
____exports.default = __TS__Class()
local AssetManager = ____exports.default
AssetManager.name = "AssetManager"
function AssetManager.prototype.____constructor(self)
    self.assets = __TS__New(Map)
end
function AssetManager.prototype.addAsset(self, id, asset)
    self.assets:set(id, asset)
end
function AssetManager.prototype.getAsset(self, id)
    return self.assets:get(id)
end
function AssetManager.prototype.drawAssets(self)
    for ____, asset in __TS__Iterator(self.assets:values()) do
        love.graphics.draw(
            asset.image,
            asset.x,
            asset.y,
            asset.orientation,
            asset.scaleX,
            asset.scaleY,
            asset.offsetX,
            asset.offsetY
        )
    end
end
function AssetManager.prototype.handleMousePressed(self, x, y, button)
end
function AssetManager.prototype.handleMouseReleased(self, x, y, button)
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if x >= asset.x and x <= asset.x + asset.width and y >= asset.y and y <= asset.y + asset.height then
            asset:onClick()
        end
    end
end
return ____exports
