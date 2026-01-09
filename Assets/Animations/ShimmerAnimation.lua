local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local ____exports = {}
local ____Animation = require("Assets.Animations.Animation")
local Animation = ____Animation.default
____exports.default = __TS__Class()
local ShimmerAnimation = ____exports.default
ShimmerAnimation.name = "ShimmerAnimation"
__TS__ClassExtends(ShimmerAnimation, Animation)
function ShimmerAnimation.prototype.____constructor(self, stopCondition, assets, constructionOptions)
    Animation.prototype.____constructor(self, assets, constructionOptions)
    self.shimmerSpeed = 0.015
    self.shimmerShader = love.graphics.newShader("\n        uniform float shimmerPhase;\n        \n        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) {\n          vec4 pixel = Texel(tex, tc);\n          \n          // Create a diagonal streak based on shimmerPhase\n          float streak = (tc.x + tc.y * 0.5 - shimmerPhase * 1.5);\n          streak = mod(streak + 1.0, 1.0);\n          \n          // Make a sharp line with smooth edges\n          float lineWidth = 0.15;\n          float brightness = smoothstep(0.0, lineWidth * 0.3, streak) * \n                           (1.0 - smoothstep(lineWidth * 0.7, lineWidth, streak));\n          \n          // Add brightness to the streak\n          pixel.rgb += vec3(brightness * 0.6);\n          \n          return pixel * color;\n        }\n      ")
    self.shimmerPhase = 0
    self.shimmerSpeed = constructionOptions and constructionOptions.shimmerSpeed or self.shimmerSpeed
    self.stopAnimationCondition = stopCondition
    local ____ = self.shimmerShader
end
function ShimmerAnimation.prototype.updateAnimation(self, deltaTime)
    Animation.prototype.updateAnimation(self, deltaTime)
    if not self.isAnimating then
        love.graphics.setShader()
        return
    end
end
return ____exports
