local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
____exports.default = __TS__Class()
local Shader = ____exports.default
Shader.name = "Shader"
function Shader.prototype.____constructor(self, gameManager, shader, stopCondition, assets)
    self.isShading = true
    self.elapsedTime = 0
    self.gameManager = gameManager
    self.shader = shader
    self.stopCondition = stopCondition
    self.assets = assets
end
function Shader.prototype.updateShader(self, deltaTime)
    if not self.isShading then
        return
    end
    if self.stopCondition and self:stopCondition() then
        self.isShading = false
        return
    end
    self.elapsedTime = self.elapsedTime + deltaTime
end
__TS__SetDescriptor(
    Shader.prototype,
    "isFinished",
    {get = function(self)
        return not self.isShading
    end},
    true
)
return ____exports
