local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
____exports.default = __TS__Class()
local CutAnimation = ____exports.default
CutAnimation.name = "CutAnimation"
__TS__ClassExtends(CutAnimation, SlideAnimation)
function CutAnimation.prototype.____constructor(self, offsetX, offsetY, animationAssets, stationaryAssets, constructionOptions)
    SlideAnimation.prototype.____constructor(
        self,
        offsetX,
        offsetY,
        animationAssets,
        constructionOptions
    )
    self.topQuads = __TS__New(Map)
    self.bottomQuads = __TS__New(Map)
    self.stationaryAssets = {}
    if stationaryAssets then
        self.stationaryAssets = stationaryAssets
    end
    for ____, asset in ipairs(self.assets) do
        do
            if not __TS__InstanceOf(asset, Asset) then
                goto __continue4
            end
            local imageWidth = asset.image:getWidth()
            local spriteHeight = asset:getHeight()
            self.topQuads:set(
                asset,
                love.graphics.newQuad(
                    0,
                    0,
                    imageWidth,
                    spriteHeight / 2,
                    imageWidth,
                    imageWidth
                )
            )
            self.bottomQuads:set(
                asset,
                love.graphics.newQuad(
                    0,
                    spriteHeight / 2,
                    imageWidth,
                    spriteHeight / 2,
                    imageWidth,
                    imageWidth
                )
            )
        end
        ::__continue4::
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
end
function CutAnimation.prototype.drawAnimation(self)
    for ____, ____value in __TS__Iterator(self.topQuads) do
        local asset = ____value[1]
        local topQuad = ____value[2]
        love.graphics.draw(asset.image, topQuad, asset.x, asset.y + self.animOffsetY)
    end
    for ____, ____value in __TS__Iterator(self.bottomQuads) do
        local asset = ____value[1]
        local bottomQuad = ____value[2]
        love.graphics.draw(
            asset.image,
            bottomQuad,
            asset.x,
            asset.y + asset:getHeight() / 2
        )
    end
    for ____, asset in ipairs(self.stationaryAssets) do
        if __TS__InstanceOf(asset, Asset) then
            asset:drawAsset()
        end
        if __TS__InstanceOf(asset, FontWithPosition) then
            asset:printText()
        end
    end
end
return ____exports
