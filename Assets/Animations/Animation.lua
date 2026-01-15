local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayForEach = ____lualib.__TS__ArrayForEach
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Animation = ____exports.default
Animation.name = "Animation"
function Animation.prototype.____constructor(self, gameManager, id, assets, constructionOptions)
    self.animElapsed = 0
    self.isAnimating = false
    self.hasStarted = false
    self.originalX = __TS__New(Map)
    self.originalY = __TS__New(Map)
    self.playedSound = false
    self.isPaused = false
    self.gameManager = gameManager
    self.id = id
    self.animDuration = constructionOptions and constructionOptions.animDuration
    self.animElapsed = 0
    self.isAnimating = true
    self.assets = assets
    self.originalX = __TS__New(
        Map,
        __TS__ArrayMap(
            assets,
            function(____, asset) return {asset.id, asset.x} end
        )
    )
    self.originalY = __TS__New(
        Map,
        __TS__ArrayMap(
            assets,
            function(____, asset) return {asset.id, asset.y} end
        )
    )
    self.onFinish = constructionOptions and constructionOptions.onFinish
    self.waitForAnimationIds = constructionOptions and constructionOptions.waitForAnimationIds or ({})
    self.stopAnimationCondition = constructionOptions and constructionOptions.stopAnimationCondition
    self.soundToPlay = constructionOptions and constructionOptions.soundToPlay
end
function Animation.prototype.updateAnimation(self, deltaTime)
    self.hasStarted = true
    if not self.isAnimating then
        return
    end
    if self.stopAnimationCondition and self:stopAnimationCondition() then
        self.isAnimating = false
        return
    end
    self.animElapsed = self.animElapsed + deltaTime
    if not isEmpty(self.animDuration) and self.animElapsed >= self.animDuration then
        self.animElapsed = self.animDuration
        self.isAnimating = false
    end
end
function Animation.prototype.getAssets(self)
    return self.assets
end
function Animation.prototype.updateX(self, deltaX)
    __TS__ArrayForEach(
        self.assets,
        function(____, asset)
            local originalX = self.originalX:get(asset.id)
            if originalX ~= nil then
                asset.x = originalX + deltaX
            end
        end
    )
end
function Animation.prototype.updateY(self, deltaY)
    __TS__ArrayForEach(
        self.assets,
        function(____, asset)
            local originalY = self.originalY:get(asset.id)
            if originalY ~= nil then
                asset.y = originalY + deltaY
            end
        end
    )
end
function Animation.prototype.shouldWaitForAnimations(self)
    if #self.waitForAnimationIds > 0 then
        for ____, waitId in ipairs(self.waitForAnimationIds) do
            do
                if waitId == self.id then
                    goto __continue18
                end
                local waitForAnimation = self.gameManager.animationManager.animations:get(waitId)
                if not isEmpty(waitForAnimation) and not waitForAnimation.isFinished and waitForAnimation.hasStarted then
                    return true
                end
            end
            ::__continue18::
        end
    end
    return false
end
__TS__SetDescriptor(
    Animation.prototype,
    "isFinished",
    {get = function(self)
        return not self.isAnimating
    end},
    true
)
return ____exports
