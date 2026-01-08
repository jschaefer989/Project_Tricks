local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local __TS__New = ____lualib.__TS__New
local __TS__ArrayPush = ____lualib.__TS__ArrayPush
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____QuadWithPosition = require("Assets.QuadWithPosition")
local QuadWithPosition = ____QuadWithPosition.default
____exports.default = __TS__Class()
local CutAnimation = ____exports.default
CutAnimation.name = "CutAnimation"
__TS__ClassExtends(CutAnimation, SlideAnimation)
function CutAnimation.prototype.____constructor(self, animDuration, offsetX, offsetY, animationAssets, constructionOptions)
    SlideAnimation.prototype.____constructor(
        self,
        animDuration,
        offsetX,
        offsetY,
        animationAssets,
        constructionOptions
    )
    self.topQuads = {}
    for ____, asset in ipairs(self.assets) do
        do
            if not __TS__InstanceOf(asset, Asset) then
                goto __continue3
            end
            local imageWidth = asset.image:getWidth()
            local spriteHeight = asset:getHeight()
            local topQuad = love.graphics.newQuad(
                0,
                0,
                imageWidth,
                spriteHeight / 2,
                imageWidth,
                imageWidth
            )
            local bottomQuad = love.graphics.newQuad(
                0,
                spriteHeight / 2,
                imageWidth,
                spriteHeight / 2,
                imageWidth,
                imageWidth
            )
            local topQuadWithPosition = __TS__New(QuadWithPosition, topQuad, 0, 0)
            __TS__ArrayPush(
                asset.quads,
                topQuadWithPosition,
                __TS__New(QuadWithPosition, bottomQuad, 0, spriteHeight / 2)
            )
            local ____self_topQuads_0 = self.topQuads
            ____self_topQuads_0[#____self_topQuads_0 + 1] = topQuadWithPosition
        end
        ::__continue3::
    end
end
function CutAnimation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    if self.animElapsed >= self.animDuration then
        self.animElapsed = self.animDuration
        self.isAnimating = false
    end
    self:calculateAnimationOffset()
    for ____, topQuad in ipairs(self.topQuads) do
        topQuad.y = self.animOffsetY
    end
end
return ____exports
