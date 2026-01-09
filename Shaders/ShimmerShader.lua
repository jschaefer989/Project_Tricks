local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Shader = require("Shaders.Shader")
local Shader = ____Shader.default
____exports.default = __TS__Class()
local ShimmerShader = ____exports.default
ShimmerShader.name = "ShimmerShader"
__TS__ClassExtends(ShimmerShader, Shader)
function ShimmerShader.prototype.____constructor(self, gameManager, stopCondition, assets)
    local shader = love.graphics.newShader("Shaders/Shimmer.glsl")
    Shader.prototype.____constructor(
        self,
        gameManager,
        shader,
        stopCondition,
        assets
    )
    self.shimmerPhase = 0
    self.sweepDuration = 0.4
    self.delayDuration = 2
    self.isSweeping = false
    self.delayTimer = 2
end
function ShimmerShader.prototype.updateShader(self, deltaTime)
    Shader.prototype.updateShader(self, deltaTime)
    if self.isSweeping then
        local nextPhase = self.shimmerPhase + deltaTime / self.sweepDuration
        if nextPhase >= 0.85 then
            self.isSweeping = false
            self.delayTimer = self.delayDuration
            self.shimmerPhase = 0
            self.shader:send("shimmerPhase", -10)
        else
            self.shimmerPhase = nextPhase
            self.shader:send("shimmerPhase", self.shimmerPhase)
        end
    else
        self.delayTimer = self.delayTimer - deltaTime
        if self.delayTimer <= 0 then
            self.isSweeping = true
            self.shimmerPhase = 0
        end
        self.shader:send("shimmerPhase", -10)
    end
end
return ____exports
