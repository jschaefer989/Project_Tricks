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
local FlickerAnimation = ____exports.default
FlickerAnimation.name = "FlickerAnimation"
__TS__ClassExtends(FlickerAnimation, Animation)
function FlickerAnimation.prototype.____constructor(self, animationAssets, constructionOptions)
    Animation.prototype.____constructor(self, animationAssets, constructionOptions)
    self.flickerInterval = 0.1
    self.flickerCount = 0
    self.maxFlickers = 6
end
function FlickerAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        for ____, asset in ipairs(self.assets) do
            if __TS__InstanceOf(asset, Asset) then
                asset.isHidden = false
            end
        end
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    local currentFlickers = math.floor(self.animElapsed / self.flickerInterval)
    if currentFlickers > self.flickerCount then
        self.flickerCount = currentFlickers
        for ____, asset in ipairs(self.assets) do
            if __TS__InstanceOf(asset, Asset) then
                asset.isHidden = not asset.isHidden
            end
        end
    end
end
return ____exports
