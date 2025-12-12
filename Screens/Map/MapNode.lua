local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____Enums = require("Enums")
local EnemyTypes = ____Enums.EnemyTypes
local MapNodeTypes = ____Enums.MapNodeTypes
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local getRandomElementFromEnum = ____Helpers.getRandomElementFromEnum
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local MapNode = ____exports.default
MapNode.name = "MapNode"
function MapNode.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.type = self:getRandomNodeType()
    self:handleNodeInitialization()
    self.swordImage = Draw:loadImage("assets/battle.jpg")
    self.marketImage = Draw:loadImage("assets/shop.jpg")
end
function MapNode.prototype.load(self, data)
    self.type = data.type or self:getRandomNodeType()
    if data.enemy then
        self.enemy = __TS__New(Enemy)
        self.enemy:load(data.enemy)
    end
end
function MapNode.prototype.save(self)
    return {
        type = self.type,
        enemy = self.enemy and self.enemy:save() or nil
    }
end
function MapNode.prototype.getRandomNodeType(self)
    return getRandomElementFromEnum(MapNodeTypes)
end
function MapNode.prototype.drawInteractiveMapNode(self, x, y)
    repeat
        local ____switch8 = self.type
        local ____cond8 = ____switch8 == MapNodeTypes.BATTLE
        if ____cond8 then
            self:drawInteractiveBattleNode(x, y)
            break
        end
        ____cond8 = ____cond8 or ____switch8 == MapNodeTypes.SHOP
        if ____cond8 then
            self:drawInteractiveShopNode(x, y)
            break
        end
        do
            exhaustiveGuard(self.type)
        end
    until true
end
function MapNode.prototype.drawInteractiveBattleNode(self, x, y)
    if not self.enemy then
        return
    end
    local imageW = self.swordImage:getWidth()
    local imageH = self.swordImage:getHeight()
    local labelHeight = 25
    local buttonText = ((self.enemy:getEnemyName() .. " (Lv. ") .. tostring(self.enemy.level)) .. ")"
    suit.layout:reset(x, y)
    suit.Label(
        buttonText,
        {align = "center"},
        suit.layout:row(imageW, labelHeight)
    )
    local imageY = y + labelHeight + 5
    local bezelPadding = 4
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle(
        "fill",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle(
        "line",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(1, 1, 1, 1)
    suit.layout:reset(x, imageY)
    local result = suit.ImageButton(
        self.swordImage,
        {},
        suit.layout:row(imageW, imageH)
    )
    if result.hit then
        self.gameManager:switchToBoard(self.enemy)
    end
end
function MapNode.prototype.drawInteractiveShopNode(self, x, y)
    local imageW = self.marketImage:getWidth()
    local imageH = self.marketImage:getHeight()
    local labelHeight = 25
    suit.layout:reset(x, y)
    suit.Label(
        "Shop",
        {align = "center"},
        suit.layout:row(imageW, labelHeight)
    )
    local imageY = y + labelHeight + 5
    local bezelPadding = 4
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle(
        "fill",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle(
        "line",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(1, 1, 1, 1)
    suit.layout:reset(x, imageY)
    local result = suit.ImageButton(
        self.marketImage,
        {},
        suit.layout:row(imageW, imageH)
    )
    if result.hit then
        self.gameManager:switchToShop()
    end
end
function MapNode.prototype.drawMapNode(self, x, y)
    repeat
        local ____switch15 = self.type
        local ____cond15 = ____switch15 == MapNodeTypes.BATTLE
        if ____cond15 then
            self:drawBattleNode(x, y)
            break
        end
        ____cond15 = ____cond15 or ____switch15 == MapNodeTypes.SHOP
        if ____cond15 then
            self:drawShopNode(x, y)
            break
        end
        do
            exhaustiveGuard(self.type)
        end
    until true
end
function MapNode.prototype.drawBattleNode(self, x, y)
    if not self.enemy then
        return
    end
    local imageW = self.swordImage:getWidth()
    local imageH = self.swordImage:getHeight()
    local labelHeight = 25
    local buttonText = ((self.enemy:getEnemyName() .. " (Lv. ") .. tostring(self.enemy.level)) .. ")"
    suit.layout:reset(x, y)
    suit.Label(
        buttonText,
        {align = "center"},
        suit.layout:row(imageW, labelHeight)
    )
    local imageY = y + labelHeight + 5
    local bezelPadding = 4
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle(
        "fill",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle(
        "line",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(1, 1, 1, 1)
    suit.layout:reset(x, imageY)
    love.graphics.draw(self.swordImage, x, imageY)
end
function MapNode.prototype.drawShopNode(self, x, y)
    local imageW = self.marketImage:getWidth()
    local imageH = self.marketImage:getHeight()
    local labelHeight = 25
    suit.layout:reset(x, y)
    suit.Label(
        "Shop",
        {align = "center"},
        suit.layout:row(imageW, labelHeight)
    )
    local imageY = y + labelHeight + 5
    local bezelPadding = 4
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle(
        "fill",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle(
        "line",
        x - bezelPadding,
        imageY - bezelPadding,
        imageW + bezelPadding * 2,
        imageH + bezelPadding * 2,
        4
    )
    love.graphics.setColor(1, 1, 1, 1)
    suit.layout:reset(x, imageY)
    love.graphics.draw(self.marketImage, x, imageY)
end
function MapNode.prototype.handleNodeInitialization(self)
    repeat
        local ____switch20 = self.type
        local ____cond20 = ____switch20 == MapNodeTypes.SHOP
        if ____cond20 then
            break
        end
        ____cond20 = ____cond20 or ____switch20 == MapNodeTypes.BATTLE
        if ____cond20 then
            self:initializeBattleNode()
            break
        end
        do
            exhaustiveGuard(self.type)
        end
    until true
end
function MapNode.prototype.initializeBattleNode(self)
    self.enemy = __TS__New(
        Enemy,
        nil,
        nil,
        nil,
        getRandomElementFromEnum(EnemyTypes)
    )
end
return ____exports
