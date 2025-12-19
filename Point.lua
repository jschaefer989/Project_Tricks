local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Point = ____exports.default
Point.name = "Point"
function Point.prototype.____constructor(self, x, y)
    self.x = x
    self.y = y
end
return ____exports
