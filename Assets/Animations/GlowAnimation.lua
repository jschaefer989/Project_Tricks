local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local GlowAnimation = ____exports.default
GlowAnimation.name = "GlowAnimation"
__TS__ClassExtends(GlowAnimation, Animation)
function GlowAnimation.prototype.____constructor(self, gameManager, id, stopCondition, assets, constructionOptions)
    Animation.prototype.____constructor(
        self,
        gameManager,
        id,
        assets,
        constructionOptions
    )
    self.originalColors = __TS__New(Map)
    self.glowStrength = 2
    self.pulsePeriod = 1.5
    self:storeOriginalColors(assets)
    self.glowStrength = constructionOptions and constructionOptions.glowStrength or self.glowStrength
    self.pulsePeriod = constructionOptions and constructionOptions.glowPeriodSeconds or self.pulsePeriod
    self.stopAnimationCondition = stopCondition
end
function GlowAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        self:restoreOriginalColors()
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    local intensity = 0.5 + 0.5 * math.sin(self.animElapsed / self.pulsePeriod * math.pi * 2)
    local blend = self.glowStrength * intensity
    local glowColor = {1, 0.95, 0.6}
    local alphaBoost = 0.2 * intensity
    for ____, asset in ipairs(self.assets) do
        if __TS__InstanceOf(asset, Asset) then
            local original = self.originalColors:get(asset.id)
            if original then
                local r, g, b, a = unpack(original, 1, 4)
                asset.color = {
                    r * (1 - blend) + glowColor[1] * blend,
                    g * (1 - blend) + glowColor[2] * blend,
                    b * (1 - blend) + glowColor[3] * blend,
                    math.min(1, a + alphaBoost)
                }
            end
        end
    end
end
function GlowAnimation.prototype.storeOriginalColors(self, assets)
    for ____, asset in ipairs(assets) do
        if __TS__InstanceOf(asset, Asset) then
            self.originalColors:set(
                asset.id,
                {unpack(asset.color)}
            )
        end
    end
end
function GlowAnimation.prototype.restoreOriginalColors(self)
    for ____, asset in ipairs(self.assets) do
        if __TS__InstanceOf(asset, Asset) then
            local original = self.originalColors:get(asset.id)
            if original then
                asset.color = original
            end
        end
    end
end
return ____exports
