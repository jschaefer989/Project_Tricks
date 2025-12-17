local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local push = require("Libraries.push")
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
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
    local index = 1
    self.assets:forEach(function(____, asset, key)
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
        index = index + 1
    end)
end
function AssetManager.prototype.handleMousePressed(self, x, y, button)
    local gameX = (push:toGame(x, y))
    local gameY = select(
        2,
        push:toGame(x, y)
    )
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if gameX >= asset.x and gameX <= asset.x + asset.width and gameY >= asset.y and gameY <= asset.y + asset.height then
            asset:onClick()
        end
    end
end
function AssetManager.prototype.handleMouseReleased(self, x, y, button)
    local gameX = (push:toGame(x, y))
    local gameY = select(
        2,
        push:toGame(x, y)
    )
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if gameX >= asset.x and gameX <= asset.x + asset.width and gameY >= asset.y and gameY <= asset.y + asset.height then
            asset:onClick()
        end
    end
end
return ____exports
