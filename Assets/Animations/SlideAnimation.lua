local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
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
    local ____temp_2 = constructionOptions and constructionOptions.bounceEffect
    if ____temp_2 == nil then
        ____temp_2 = false
    end
    self.bounceEffect = ____temp_2
    self.animTargetOffsetX = offsetX + self:getOvershootAmount(offsetX)
    self.animTargetOffsetY = offsetY + self:getOvershootAmount(offsetY)
    self.animDuration = animDuration
end
function SlideAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        self:updateX(self.animTargetOffsetX)
        self:updateY(self.animTargetOffsetY)
        self:applyBounceEffect()
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
function SlideAnimation.prototype.applyBounceEffect(self)
    if not self.bounceEffect then
        return
    end
    local bounceAmplitudeX = -self:getOvershootAmount(self.animTargetOffsetX)
    local bounceAmplitudeY = -self:getOvershootAmount(self.animTargetOffsetY)
    self.gameManager.animationManager:startAnimation(
        self.id .. "_bounce",
        __TS__New(
            ____exports.default,
            self.gameManager,
            self.id .. "_bounce",
            0.1,
            bounceAmplitudeX,
            bounceAmplitudeY,
            self:getAssets()
        )
    )
end
function SlideAnimation.prototype.getOvershootAmount(self, target)
    if not self.bounceEffect then
        return 0
    end
    return target * 0.1
end
return ____exports
