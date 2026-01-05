local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Biome = ____exports.default
Biome.name = "Biome"
function Biome.prototype.____constructor(self, boardBackgroundImagePath, battleMusicPath)
    self.boardBackgroundImagePath = boardBackgroundImagePath
    self.battleMusicPath = battleMusicPath
end
return ____exports
