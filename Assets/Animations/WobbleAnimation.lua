local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local WobbleAnimation = ____exports.default
WobbleAnimation.name = "WobbleAnimation"
__TS__ClassExtends(WobbleAnimation, Animation)
function WobbleAnimation.prototype.____constructor(self, wobbleAmount, assets, constructionOptions)
    Animation.prototype.____constructor(self, assets, constructionOptions)
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
    self.animElapsed = 0
    self.isAnimating = true
    self.assets = assets
end
function WobbleAnimation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    if self.animElapsed >= self.animDuration then
        self.animElapsed = self.animDuration
        self.isAnimating = false
        self:updateX(0)
        return
    end
    local progress = self.animElapsed / self.animDuration
    local frequency = 8
    local damping = 1 - progress
    local offset = math.sin(progress * frequency * math.pi * 2) * self.wobbleAmount * damping
    self:updateX(offset)
end
__TS__SetDescriptor(
    WobbleAnimation.prototype,
    "isFinished",
    {get = function(self)
        return not self.isAnimating
    end},
    true
)
return ____exports
