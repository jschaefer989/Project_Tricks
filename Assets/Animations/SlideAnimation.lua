local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local SlideAnimation = ____exports.default
SlideAnimation.name = "SlideAnimation"
__TS__ClassExtends(SlideAnimation, Animation)
function SlideAnimation.prototype.____constructor(self, gameManager, id, animDuration, offsetX, offsetY, assets, constructionOptions)
    Animation.prototype.____constructor(
        self,
        gameManager,
        id,
        assets,
        constructionOptions
    )
    self.animOffsetX = 0
    self.animOffsetY = 0
    self.animTargetOffsetX = 0
    self.animTargetOffsetY = 0
    self.animTargetOffsetX = offsetX
    self.animTargetOffsetY = offsetY
    self.animDuration = animDuration
end
function SlideAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        self:updateX(self.animTargetOffsetX)
        self:updateY(self.animTargetOffsetY)
        return
    end
    self:calculateAnimationOffset()
    self:updateX(self.animOffsetX)
    self:updateY(self.animOffsetY)
end
function SlideAnimation.prototype.calculateAnimationOffset(self)
    local progress = self.animElapsed / self.animDuration
    self.animOffsetX = self.animTargetOffsetX * progress
    self.animOffsetY = self.animTargetOffsetY * progress
end
return ____exports
