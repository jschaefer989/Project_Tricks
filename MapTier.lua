local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____Enums = require("Enums")
local MapNodeTypes = ____Enums.MapNodeTypes
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local ____MapNode = require("MapNode")
local MapNode = ____MapNode.default
local startY = 100
local labelHeight = 25
local imageHeight = 100
local gapBetweenLabelAndImage = 5
local padding = 40
local nodeWidth = 200
local spacing = labelHeight + gapBetweenLabelAndImage + imageHeight + padding
____exports.default = __TS__Class()
local MapTier = ____exports.default
MapTier.name = "MapTier"
function MapTier.prototype.____constructor(self, gameManager, level)
    self.gameManager = gameManager
    self.nodes = {}
    self.level = level or 1
end
function MapTier.prototype.load(self, data)
    self.nodes = __TS__ArrayMap(
        data.nodes or ({}),
        function(____, nodeData)
            local node = __TS__New(MapNode, self.gameManager)
            node:load(nodeData)
            return node
        end
    )
    self.level = data.level
end
function MapTier.prototype.save(self)
    return {
        nodes = __TS__ArrayMap(
            self.nodes,
            function(____, node) return node:save() end
        ),
        level = self.level
    }
end
function MapTier.prototype.generateNodes(self, numberOfNodes)
    do
        local i = 0
        while i < numberOfNodes do
            do
                local newNode = __TS__New(MapNode, self.gameManager)
                if self.level == 1 and self:shouldBeExcludedFromFirstTier(newNode.type) then
                    goto __continue9
                end
                if self:shouldBeUniqueNodeType(newNode.type) and not self:isUniqueNodeType(newNode.type) then
                    goto __continue9
                end
                local ____self_nodes_0 = self.nodes
                ____self_nodes_0[#____self_nodes_0 + 1] = newNode
            end
            ::__continue9::
            i = i + 1
        end
    end
end
function MapTier.prototype.shouldBeExcludedFromFirstTier(self, nodeType)
    repeat
        local ____switch13 = nodeType
        local ____cond13 = ____switch13 == MapNodeTypes.SHOP
        if ____cond13 then
            return true
        end
        ____cond13 = ____cond13 or ____switch13 == MapNodeTypes.BATTLE
        if ____cond13 then
            return false
        end
        do
            exhaustiveGuard(nodeType)
        end
    until true
end
function MapTier.prototype.shouldBeUniqueNodeType(self, nodeType)
    repeat
        local ____switch15 = nodeType
        local ____cond15 = ____switch15 == MapNodeTypes.SHOP
        if ____cond15 then
            return true
        end
        ____cond15 = ____cond15 or ____switch15 == MapNodeTypes.BATTLE
        if ____cond15 then
            return false
        end
        do
            exhaustiveGuard(nodeType)
        end
    until true
end
function MapTier.prototype.isUniqueNodeType(self, nodeType)
    for ____, node in ipairs(self.nodes) do
        if node.type == nodeType then
            return false
        end
    end
    return true
end
function MapTier.prototype.drawTier(self, relativePosition)
    local tierWidth = nodeWidth + 50
    local tierX = relativePosition * tierWidth + 50
    do
        local index = 0
        while index < #self.nodes do
            local node = self.nodes[index + 1]
            local x = tierX
            local y = startY + index * spacing
            if relativePosition == 0 then
                node:drawInteractiveMapNode(x, y)
            else
                node:drawMapNode(x, y)
            end
            index = index + 1
        end
    end
end
return ____exports
