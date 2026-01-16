local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local DisabledStateCache = ____exports.default
DisabledStateCache.name = "DisabledStateCache"
function DisabledStateCache.prototype.____constructor(self, gameManager)
    self.cache = __TS__New(Map)
    self.gameManager = gameManager
end
function DisabledStateCache.prototype.cacheState(self, asset)
    self.cache:set(asset.id, {isDisabled = asset.isDisabled, useDisabledAnimation = asset.useDisabledAnimation, color = asset.color, showDisabledColor = asset.showDisabledColor})
end
function DisabledStateCache.prototype.restore(self, idsToSkip)
    for ____, ____value in __TS__Iterator(self.cache) do
        local baseId = ____value[1]
        local disabledState = ____value[2]
        do
            local ____opt_0 = idsToSkip
            if ____opt_0 and __TS__ArrayIncludes(idsToSkip, baseId) then
                goto __continue5
            end
            local assets = self.gameManager.assetManager.assets:get(baseId)
            if not isEmpty(assets) then
                for ____, asset in ipairs(assets) do
                    asset.color = disabledState.color
                    asset:setDisabled(disabledState.isDisabled, {useDisabledAnimation = disabledState.useDisabledAnimation, showDisabledColor = disabledState.showDisabledColor})
                end
            end
        end
        ::__continue5::
    end
    self.cache:clear()
end
return ____exports
