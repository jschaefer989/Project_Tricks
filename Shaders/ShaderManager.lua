local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
____exports.default = __TS__Class()
local ShaderManager = ____exports.default
ShaderManager.name = "ShaderManager"
function ShaderManager.prototype.____constructor(self, gameManager)
    self.shaders = __TS__New(Map)
    self.gameManager = gameManager
end
function ShaderManager.prototype.addShader(self, assetId, shader)
    self.shaders:set(assetId, shader)
end
function ShaderManager.prototype.getShader(self, assetId)
    return self.shaders:get(assetId)
end
function ShaderManager.prototype.updateShaders(self, dt)
    for ____, ____value in __TS__Iterator(self.shaders) do
        local id = ____value[1]
        local shader = ____value[2]
        shader:updateShader(dt)
        if shader.isFinished then
            self.shaders:delete(id)
        end
    end
end
function ShaderManager.prototype.applyShaders(self, asset)
    local shader = self.shaders:get(asset.id)
    if shader and shader.isShading then
        love.graphics.setShader(shader.shader)
    end
end
function ShaderManager.prototype.removeShaders(self)
    love.graphics.setShader()
end
return ____exports
