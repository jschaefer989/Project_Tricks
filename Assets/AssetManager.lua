local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local push = require("Libraries.push")
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____TextManager = require("Assets.TextManager")
local TextManager = ____TextManager.default
____exports.default = __TS__Class()
local AssetManager = ____exports.default
AssetManager.name = "AssetManager"
function AssetManager.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.assets = __TS__New(Map)
    self.textManager = __TS__New(TextManager)
end
function AssetManager.prototype.addAsset(self, id, asset)
    if self.assets:has(id) then
        local assets = self.assets:get(id)
        local ____opt_0 = assets
        if ____opt_0 ~= nil then
            assets[#assets + 1] = asset
        end
        return
    end
    self.assets:set(id, {asset})
end
function AssetManager.prototype.getAssets(self, baseId)
    return self.assets:get(baseId)
end
function AssetManager.prototype.getAsset(self, baseId, assetId)
    local ____opt_2 = self:getAssets(baseId)
    return ____opt_2 and __TS__ArrayFind(
        self:getAssets(baseId),
        function(____, asset) return asset.id == assetId end
    )
end
function AssetManager.prototype.hideAsset(self, id)
    self.assets:delete(id)
end
function AssetManager.prototype.drawAssets(self)
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue10
            end
            for ____, asset in ipairs(assets) do
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
        end
        ::__continue10::
    end
    self.textManager:drawText()
    self:drawHoverables()
end
function AssetManager.prototype.drawHoverables(self)
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue16
            end
            local asset = assets[1]
            if asset.isHovered then
                local ____opt_4 = asset.onHover
                if ____opt_4 ~= nil then
                    ____opt_4(asset, self.gameManager, asset)
                end
            end
        end
        ::__continue16::
    end
end
function AssetManager.prototype.handleMousePressed(self, x, y, button)
end
function AssetManager.prototype.handleMouseReleased(self, x, y, button)
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue23
            end
            local asset = assets[1]
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() and not isEmpty(asset.onClick) then
                asset:onClick()
            end
        end
        ::__continue23::
    end
end
function AssetManager.prototype.handleMouseHover(self)
    local x, y = love.mouse.getPosition()
    local gameX, gameY = push:toGame(x, y)
    if isEmpty(gameX) or isEmpty(gameY) then
        return
    end
    for ____, assets in __TS__Iterator(self.assets:values()) do
        do
            if isEmpty(assets) or #assets == 0 then
                goto __continue29
            end
            local asset = assets[1]
            if gameX >= asset.x and gameX <= asset.x + asset:getWidth() and gameY >= asset.y and gameY <= asset.y + asset:getHeight() then
                asset:setHovered(true)
            else
                asset:setHovered(false)
            end
        end
        ::__continue29::
    end
end
return ____exports
