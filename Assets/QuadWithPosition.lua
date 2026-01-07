local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local QuadWithPosition = ____exports.default
QuadWithPosition.name = "QuadWithPosition"
function QuadWithPosition.prototype.____constructor(self, quad, x, y)
    self.quad = quad
    self.x = x
    self.y = y
end
return ____exports
