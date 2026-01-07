local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Tooltip = ____exports.default
Tooltip.name = "Tooltip"
function Tooltip.prototype.____constructor(self, asset, texts)
    self.asset = asset
    self.texts = texts
end
return ____exports
