local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
____exports.default = __TS__Class()
local Animation = ____exports.default
Animation.name = "Animation"
function Animation.prototype.____constructor(self, offsetX, offsetY, asset)
    self.animDuration = 0.15
    self.animElapsed = 0
    self.animOffsetX = 0
    self.animOffsetY = 0
    self.animTargetOffsetX = 0
    self.animTargetOffsetY = 0
    self.isAnimating = false
    self.originalX = 0
    self.originalY = 0
    self.originalX = asset.x
    self.originalY = asset.y
    self.animTargetOffsetX = offsetX
    self.animTargetOffsetY = offsetY
    self.animElapsed = 0
    self.isAnimating = true
    self.asset = asset
end
function Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    if self.animElapsed >= self.animDuration then
        self.animElapsed = self.animDuration
        self.isAnimating = false
    end
    local progress = self.animElapsed / self.animDuration
    self.animOffsetX = self.animTargetOffsetX * progress
    self.animOffsetY = self.animTargetOffsetY * progress
    self.asset.y = self.originalY + self.animOffsetY
    self.asset.x = self.originalX + self.animOffsetX
end
__TS__SetDescriptor(
    Animation.prototype,
    "isFinished",
    {get = function(self)
        return not self.isAnimating
    end},
    true
)
return ____exports
