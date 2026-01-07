local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
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
    self.drawSeparately = false
    self.animTargetOffsetX = offsetX
    self.animTargetOffsetY = offsetY
    local ____temp_2 = constructionOptions and constructionOptions.drawSeparately
    if ____temp_2 == nil then
        ____temp_2 = false
    end
    self.drawSeparately = ____temp_2
end
function SlideAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        return
    end
    self:calculateAnimationOffset()
    if not self.drawSeparately then
        self:updateX(self.animOffsetX)
        self:updateY(self.animOffsetY)
    end
end
function SlideAnimation.prototype.calculateAnimationOffset(self)
    local progress = self.animElapsed / self.animDuration
    self.animOffsetX = self.animTargetOffsetX * progress
    self.animOffsetY = self.animTargetOffsetY * progress
end
function SlideAnimation.prototype.drawAnimation(self)
    if not self.drawSeparately then
        return
    end
    for ____, asset in ipairs(self.assets) do
        if __TS__InstanceOf(asset, Asset) then
            love.graphics.draw(asset.image, asset.x + self.animOffsetX, asset.y + self.animOffsetY)
        end
    end
end
return ____exports
