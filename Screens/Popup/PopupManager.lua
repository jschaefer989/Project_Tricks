local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Popup = require("Screens.Popup.Popup")
local Popup = ____Popup.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local PopupManager = ____exports.default
PopupManager.name = "PopupManager"
function PopupManager.prototype.____constructor(self, gameManager)
    self.popups = {}
    self.popupAssetIds = {}
    self.popupTextIds = {}
    self.gameManager = gameManager
end
function PopupManager.prototype.open(self, id, title, popupSize, constructionOptions)
    local popup = __TS__New(
        Popup,
        self.gameManager,
        id,
        popupSize,
        title,
        self.popupAssetIds,
        self.popupTextIds,
        constructionOptions
    )
    local activePopup = self:getActivePopup()
    if not isEmpty(activePopup) then
        activePopup.isActive = false
    end
    local ____self_popups_0 = self.popups
    ____self_popups_0[#____self_popups_0 + 1] = popup
    self.popupAssetIds = {}
    self.popupTextIds = {}
end
function PopupManager.prototype.close(self)
    local popup = table.remove(self.popups)
    if isEmpty(popup) then
        return
    end
    popup:close()
    local activePopup = self:getActivePopup()
    if not isEmpty(activePopup) then
        activePopup.isActive = true
    end
end
function PopupManager.prototype.getActivePopup(self)
    return self.popups[#self.popups]
end
function PopupManager.prototype.handleMousePressed(self, x, y, button)
    local activePopup = self:getActivePopup()
    local ____activePopup_1
    if activePopup then
        ____activePopup_1 = activePopup:handleMousePressed(x, y, button)
    else
        ____activePopup_1 = false
    end
    return ____activePopup_1
end
function PopupManager.prototype.handleMouseReleased(self, x, y, button)
    local activePopup = self:getActivePopup()
    local ____activePopup_2
    if activePopup then
        ____activePopup_2 = activePopup:handleMouseReleased(x, y, button)
    else
        ____activePopup_2 = false
    end
    return ____activePopup_2
end
function PopupManager.prototype.drawPopups(self)
    for ____, popup in ipairs(self.popups) do
        popup:drawPopup()
    end
end
return ____exports
