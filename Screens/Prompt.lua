local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local TextIds = ____Enums.TextIds
local ____Popup = require("Screens.Popup.Popup")
local Popup = ____Popup.default
local PopupSizes = ____Popup.PopupSizes
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Format = ____FontWithPosition.Format
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local buttonWidth = 78
local buttonHeight = 27
____exports.default = __TS__Class()
local Prompt = ____exports.default
Prompt.name = "Prompt"
function Prompt.prototype.____constructor(self, gameManager, message, onYesClick, onNoClick, constructionOptions)
    self.gameManager = gameManager
    self.message = message
    self.onYesClick = onYesClick
    self.onNoClick = onNoClick
    self:buildYesButton()
    self:buildNoButton()
    if not isEmpty(constructionOptions and constructionOptions.secondaryMessage) then
        local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MESSAGE_BOX)
        local secondaryMessageText = __TS__New(
            FontWithPosition,
            TextIds.PROMPT_SECONDARY_MESSAGE,
            popupCenterX,
            Popup:getTopOfPopup(PopupSizes.MESSAGE_BOX) + 40,
            constructionOptions.secondaryMessage,
            {xLocation = Format.CENTER, size = 9}
        )
        self.gameManager.popupManager:addText(TextIds.PROMPT_SECONDARY_MESSAGE, secondaryMessageText)
    end
end
function Prompt.prototype.open(self, id)
    self.gameManager.popupManager:open(id, self.message, PopupSizes.MESSAGE_BOX, {animateIn = false})
end
function Prompt.prototype.buildYesButton(self)
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MESSAGE_BOX)
    local yesText = __TS__New(
        FontWithPosition,
        TextIds.YES_BUTTON_CAPTION,
        popupCenterX,
        Popup:getTopOfPopup(PopupSizes.MESSAGE_BOX) + 61 + buttonHeight / 2,
        "Yes",
        {xLocation = Format.CENTER, size = 9}
    )
    local button = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.YES_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/MessageBoxButton.png"),
        popupCenterX - buttonWidth / 2,
        Popup:getTopOfPopup(PopupSizes.MESSAGE_BOX) + 60,
        buttonWidth,
        buttonHeight,
        {
            onClick = self.onYesClick,
            associatedTexts = {yesText},
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addAsset(AssetIds.YES_BUTTON, button)
    self.gameManager.popupManager:addText(TextIds.YES_BUTTON_CAPTION, yesText)
end
function Prompt.prototype.buildNoButton(self)
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MESSAGE_BOX)
    local buttonY = Popup:getTopOfPopup(PopupSizes.MESSAGE_BOX) + 60 + buttonHeight + 10
    local noText = __TS__New(
        FontWithPosition,
        TextIds.NO_BUTTON_CAPTION,
        popupCenterX,
        buttonY + buttonHeight / 2 + 1,
        "No",
        {xLocation = Format.CENTER, size = 9}
    )
    local button = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.NO_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/MessageBoxButton.png"),
        popupCenterX - buttonWidth / 2,
        buttonY,
        buttonWidth,
        buttonHeight,
        {
            onClick = self.onNoClick,
            associatedTexts = {noText},
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addAsset(AssetIds.NO_BUTTON, button)
    self.gameManager.popupManager:addText(TextIds.NO_BUTTON_CAPTION, noText)
end
return ____exports
