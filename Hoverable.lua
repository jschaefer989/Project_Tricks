local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
____exports.default = __TS__Class()
local Hoverable = ____exports.default
Hoverable.name = "Hoverable"
function Hoverable.prototype.____constructor(self, id)
    self.isHovered = false
    self.id = id
end
return ____exports
