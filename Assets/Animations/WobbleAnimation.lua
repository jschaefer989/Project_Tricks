local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local WobbleAnimation = ____exports.default
WobbleAnimation.name = "WobbleAnimation"
__TS__ClassExtends(WobbleAnimation, Animation)
function WobbleAnimation.prototype.____constructor(self, animDuration, wobbleAmount, assets, constructionOptions)
    Animation.prototype.____constructor(
        self,
        assets,
        __TS__ObjectAssign(
            {onFinish = function() return self:updateX(0) end},
            constructionOptions
        )
    )
    self.wobbleAmount = 10
    self.originalX = __TS__New(Map)
    self.originalX = __TS__New(
        Map,
        __TS__ArrayMap(
            assets,
            function(____, asset) return {asset.id, asset.x} end
        )
    )
    self.wobbleAmount = wobbleAmount
    self.animDuration = animDuration
end
function WobbleAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        return
    end
    local progress = self.animElapsed / self.animDuration
    local frequency = 8
    local damping = 1 - progress
    local offset = math.sin(progress * frequency * math.pi * 2) * self.wobbleAmount * damping
    self:updateX(offset)
end
return ____exports
