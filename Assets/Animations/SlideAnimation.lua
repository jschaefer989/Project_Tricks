local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local SlideAnimation = ____exports.default
SlideAnimation.name = "SlideAnimation"
__TS__ClassExtends(SlideAnimation, Animation)
function SlideAnimation.prototype.____constructor(self, offsetX, offsetY, assets, constructionOptions)
    Animation.prototype.____constructor(self, assets, constructionOptions)
    self.animOffsetX = 0
    self.animOffsetY = 0
    self.animTargetOffsetX = 0
    self.animTargetOffsetY = 0
    self.animTargetOffsetX = offsetX
    self.animTargetOffsetY = offsetY
    self.animElapsed = 0
    self.isAnimating = true
    self.assets = assets
end
function SlideAnimation.prototype.updateAnimation(self, deltaTime)
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
    self:updateX(self.animOffsetX)
    self:updateY(self.animOffsetY)
end
__TS__SetDescriptor(
    SlideAnimation.prototype,
    "isFinished",
    {get = function(self)
        return not self.isAnimating
    end},
    true
)
return ____exports
