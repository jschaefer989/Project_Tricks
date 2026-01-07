local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__InstanceOf = ____lualib.__TS__InstanceOf
local ____exports = {}
local ____WobbleAnimation = require("Assets.Animations.WobbleAnimation")
local WobbleAnimation = ____WobbleAnimation.default
local ____CutAnimation = require("Assets.Animations.CutAnimation")
local CutAnimation = ____CutAnimation.default
____exports.default = __TS__Class()
local AnimationManager = ____exports.default
AnimationManager.name = "AnimationManager"
function AnimationManager.prototype.____constructor(self, gameManager)
    self.animations = __TS__New(Map)
    self.gameManager = gameManager
end
function AnimationManager.prototype.startAnimation(self, id, animation)
    self.animations:set(id, animation)
end
function AnimationManager.prototype.updateAnimations(self, dt)
    for ____, ____value in __TS__Iterator(self.animations) do
        local id = ____value[1]
        local animation = ____value[2]
        animation:updateAnimation(dt)
        if animation.isFinished then
            self.animations:delete(id)
            local ____this_1
            ____this_1 = animation
            local ____opt_0 = ____this_1.onFinish
            if ____opt_0 ~= nil then
                ____opt_0(____this_1)
            end
        end
    end
end
function AnimationManager.prototype.drawAnimations(self)
    for ____, animation in __TS__Iterator(self.animations:values()) do
        animation:drawAnimation()
    end
end
function AnimationManager.prototype.hasWobbleAnimation(self)
    for ____, animation in __TS__Iterator(self.animations:values()) do
        if __TS__InstanceOf(animation, WobbleAnimation) then
            return true
        end
    end
    return false
end
function AnimationManager.prototype.hasCutAnimation(self)
    for ____, animation in __TS__Iterator(self.animations:values()) do
        if __TS__InstanceOf(animation, CutAnimation) then
            return true
        end
    end
    return false
end
return ____exports
