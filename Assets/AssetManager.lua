local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local Set = ____lualib.Set
local ____exports = {}
local push = require("Libraries.push")
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____FontManager = require("Assets.FontManager")
local FontManager = ____FontManager.default
____exports.default = __TS__Class()
local AssetManager = ____exports.default
AssetManager.name = "AssetManager"
function AssetManager.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.assets = __TS__New(Map)
    self.fontManager = __TS__New(FontManager)
end
function AssetManager.prototype.addAsset(self, id, asset)
    self.assets:set(id, asset)
end
function AssetManager.prototype.getAsset(self, id)
    return self.assets:get(id)
end
function AssetManager.prototype.hideAsset(self, id)
    self.assets:delete(id)
end
function AssetManager.prototype.drawAssets(self)
    for ____, asset in __TS__Iterator(self.assets:values()) do
        love.graphics.draw(
            asset.image,
            asset.x,
            asset.y,
            asset.orientation,
            asset.scaleX,
            asset.scaleY,
            asset.offsetX,
            asset.offsetY
        )
    end
    self.fontManager:drawText()
    self:drawHoverables()
end
function AssetManager.prototype.drawHoverables(self)
    local drawnHoverables = __TS__New(Set)
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if not isEmpty(asset.hoverable) and asset.hoverable.isHovered then
            local hoverableId = asset.hoverable.id
            if not drawnHoverables:has(hoverableId) then
                drawnHoverables:add(hoverableId)
                local ____opt_0 = asset.onHover
                if ____opt_0 ~= nil then
                    ____opt_0(asset, self.gameManager, asset)
                end
            end
        end
    end
end
function AssetManager.prototype.handleMousePressed(self, x, y, button)
end
function AssetManager.prototype.handleMouseReleased(self, x, y, button)
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
            asset:onClick()
        end
    end
end
function AssetManager.prototype.handleMouseHover(self)
    local x, y = love.mouse.getPosition()
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    local hoveredHoverables = __TS__New(Set)
    for ____, asset in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(asset.hoverable) then
                goto __continue22
            end
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
                hoveredHoverables:add(asset.hoverable.id)
            end
        end
        ::__continue22::
    end
    for ____, asset in __TS__Iterator(self.assets:values()) do
        if not isEmpty(asset.hoverable) then
            asset.hoverable.isHovered = hoveredHoverables:has(asset.hoverable.id)
        end
    end
end
return ____exports
