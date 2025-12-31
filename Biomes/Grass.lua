local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Biome = require("Biomes.Biome")
local Biome = ____Biome.default
____exports.default = __TS__Class()
local Grass = ____exports.default
Grass.name = "Grass"
__TS__ClassExtends(Grass, Biome)
function Grass.prototype.____constructor(self)
    Biome.prototype.____constructor(self, "Assets/Images/GrassBackground.png")
end
return ____exports
