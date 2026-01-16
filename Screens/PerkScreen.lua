local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local PopupIds = ____Enums.PopupIds
local TextIds = ____Enums.TextIds
local ____Popup = require("Screens.Popup.Popup")
local Popup = ____Popup.default
local PopupSizes = ____Popup.PopupSizes
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Format = ____FontWithPosition.Format
local buttonWidth = 78
local buttonHeight = 27
____exports.default = __TS__Class()
local PerkScreen = ____exports.default
PerkScreen.name = "PerkScreen"
function PerkScreen.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function PerkScreen.prototype.showPerks(self)
    self:buildPerks()
    self:buildReturnButton()
    self.gameManager.popupManager:open(PopupIds.PERKS, "Perks", PopupSizes.MENU)
end
function PerkScreen.prototype.buildPerks(self)
    local perks = self.gameManager.player.perks
    if #perks == 0 then
        local noPerksText = __TS__New(
            FontWithPosition,
            TextIds.PERKS_NO_PERKS_TEXT,
            Popup:getCenterOfPopup(PopupSizes.MENU),
            Popup:getTopOfPopup(PopupSizes.MENU) + 100,
            "No perks acquired yet.",
            {xLocation = Format.CENTER, size = 18}
        )
        self.gameManager.popupManager:addText(TextIds.PERKS_NO_PERKS_TEXT, noPerksText)
        return
    end
    local currentY = Popup:getTopOfPopup(PopupSizes.MENU) + 50
    local centerX = Popup:getCenterOfPopup(PopupSizes.MENU)
    for ____, perk in ipairs(perks) do
        local perkText = __TS__New(
            FontWithPosition,
            perk.perkType,
            centerX,
            currentY,
            perk:getPerkName(),
            {xLocation = Format.CENTER, size = 9}
        )
        self.gameManager.popupManager:addText(perk.perkType, perkText)
        currentY = currentY + 30
    end
end
function PerkScreen.prototype.buildReturnButton(self)
    local returnButtonY = Popup:getBottomOfPopup(PopupSizes.MENU) - 50
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MENU)
    local returnText = __TS__New(
        FontWithPosition,
        TextIds.PERKS_RETURN_BUTTON_CAPTION,
        popupCenterX,
        returnButtonY + buttonHeight / 2 - 1,
        "Return",
        {xLocation = Format.CENTER, size = 9}
    )
    local returnButton = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.PERKS_RETURN_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/MessageBoxButton.png"),
        popupCenterX - buttonWidth / 2,
        returnButtonY,
        buttonWidth,
        buttonHeight,
        {
            onClick = function()
                self.gameManager.popupManager:close()
            end,
            associatedTexts = {returnText},
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addText(TextIds.PERKS_RETURN_BUTTON_CAPTION, returnText)
    self.gameManager.popupManager:addAsset(AssetIds.PERKS_RETURN_BUTTON, returnButton)
    return returnButtonY
end
return ____exports
