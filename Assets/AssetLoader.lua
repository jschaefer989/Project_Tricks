local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
____exports.default = __TS__Class()
local AssetLoader = ____exports.default
AssetLoader.name = "AssetLoader"
function AssetLoader.prototype.____constructor(self)
    self.loadedAssets = __TS__New(Map)
end
function AssetLoader.prototype.loadImage(self, path)
    if self.loadedAssets:has(path) then
        return self.loadedAssets:get(path)
    end
    local image = love.graphics.newImage(path)
    self.loadedAssets:set(path, image)
    return image
end
return ____exports
