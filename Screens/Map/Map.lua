local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____MapTier = require("Screens.Map.MapTier")
local MapTier = ____MapTier.default
____exports.default = __TS__Class()
local Map = ____exports.default
Map.name = "Map"
function Map.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.tiers = {}
    self.currentTierIndex = 0
end
function Map.prototype.load(self, data)
    self.tiers = __TS__ArrayMap(
        data.tiers,
        function(____, tierData)
            local tier = __TS__New(MapTier, self.gameManager)
            tier:load(tierData)
            return tier
        end
    )
    self.currentTierIndex = data.currentTierIndex or 0
end
function Map.prototype.save(self)
    return {
        tiers = __TS__ArrayMap(
            self.tiers,
            function(____, tier) return tier:save() end
        ),
        currentTierIndex = self.currentTierIndex
    }
end
function Map.prototype.drawMap(self)
    self:drawTiers()
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player)
end
function Map.prototype.drawBackground(self)
end
function Map.prototype.drawTiers(self)
    do
        local index = 0
        while index < #self.tiers do
            local tier = self.tiers[index + 1]
            local relativePosition = index - self.currentTierIndex
            tier:drawTier(relativePosition)
            index = index + 1
        end
    end
end
function Map.prototype.generateNewMap(self)
    do
        local index = 0
        while index < 5 do
            local newTier = __TS__New(MapTier, self.gameManager, index + 1)
            newTier:generateNodes(3)
            local ____self_tiers_0 = self.tiers
            ____self_tiers_0[#____self_tiers_0 + 1] = newTier
            index = index + 1
        end
    end
end
function Map.prototype.advanceToNextTier(self)
    if self.currentTierIndex < #self.tiers - 1 then
        self.currentTierIndex = self.currentTierIndex + 1
    end
end
return ____exports
