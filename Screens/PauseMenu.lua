local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Format = ____FontWithPosition.Format
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local PopupIds = ____Enums.PopupIds
local TextIds = ____Enums.TextIds
local ____Save = require("Save")
local Save = ____Save.default
local ____Popup = require("Screens.Popup.Popup")
local Popup = ____Popup.default
local PopupSizes = ____Popup.PopupSizes
local ____Prompt = require("Screens.Prompt")
local Prompt = ____Prompt.default
local buttonWidth = 192
local buttonHeight = 64
____exports.default = __TS__Class()
local PauseMenu = ____exports.default
PauseMenu.name = "PauseMenu"
function PauseMenu.prototype.____constructor(self, gameManager)
    self.isOpen = false
    self.gameManager = gameManager
end
function PauseMenu.prototype.showPauseMenu(self)
    local continueButtonY = self:buildContinueButton()
    local saveButtonY = self:buildSaveButton(continueButtonY)
    self:buildQuitButton(saveButtonY)
    self.gameManager.popupManager:open(
        PopupIds.PAUSE_MENU,
        "Paused",
        PopupSizes.MENU,
        {onClose = function()
            self.isOpen = false
        end}
    )
    self.isOpen = true
end
function PauseMenu.prototype.buildContinueButton(self)
    local continueButtonY = 50
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MENU)
    local continueText = __TS__New(
        FontWithPosition,
        TextIds.PAUSE_CONTINUE_BUTTON_CAPTION,
        popupCenterX,
        continueButtonY + buttonHeight / 2 - 1,
        "Continue",
        {format = Format.CENTER, size = 18}
    )
    local continueButton = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.PAUSE_CONTINUE_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PauseMenuButton.png"),
        popupCenterX - buttonWidth / 2,
        continueButtonY,
        buttonWidth,
        buttonHeight,
        {
            onClick = function()
                self.gameManager.popupManager:close()
            end,
            associatedTexts = {continueText},
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addText(TextIds.PAUSE_CONTINUE_BUTTON_CAPTION, continueText)
    self.gameManager.popupManager:addAsset(AssetIds.PAUSE_CONTINUE_BUTTON, continueButton)
    return continueButtonY
end
function PauseMenu.prototype.buildSaveButton(self, continueButtonY)
    local saveButtonY = continueButtonY + buttonHeight + 10
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MENU)
    local saveText = __TS__New(
        FontWithPosition,
        TextIds.PAUSE_SAVE_BUTTON_CAPTION,
        popupCenterX,
        saveButtonY + buttonHeight / 2 - 1,
        "Save",
        {format = Format.CENTER, size = 18}
    )
    local saveButton = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.PAUSE_SAVE_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PauseMenuButton.png"),
        popupCenterX - buttonWidth / 2,
        saveButtonY,
        buttonWidth,
        buttonHeight,
        {
            onClick = function()
                Save:save(self.gameManager)
            end,
            associatedTexts = {saveText},
            isDisabled = not self:canSave(),
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addText(TextIds.PAUSE_SAVE_BUTTON_CAPTION, saveText)
    self.gameManager.popupManager:addAsset(AssetIds.PAUSE_SAVE_BUTTON, saveButton)
    return saveButtonY
end
function PauseMenu.prototype.buildQuitButton(self, saveButtonY)
    local quitButtonY = saveButtonY + buttonHeight + 10
    local popupCenterX = Popup:getCenterOfPopup(PopupSizes.MENU)
    local quitText = __TS__New(
        FontWithPosition,
        TextIds.PAUSE_QUIT_BUTTON_CAPTION,
        popupCenterX,
        quitButtonY + buttonHeight / 2 - 1,
        "Quit",
        {format = Format.CENTER, size = 18}
    )
    local quitButton = __TS__New(
        Asset,
        self.gameManager,
        AssetIds.PAUSE_QUIT_BUTTON,
        self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PauseMenuButton.png"),
        popupCenterX - buttonWidth / 2,
        quitButtonY,
        buttonWidth,
        buttonHeight,
        {
            onClick = function() return self:promptToQuit() end,
            associatedTexts = {quitText},
            clickSound = self.gameManager.assetManager.buttonClickSound,
            hoverEffect = {HoverEffects.CHANGE_COLOR},
            mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
        }
    )
    self.gameManager.popupManager:addText(TextIds.PAUSE_QUIT_BUTTON_CAPTION, quitText)
    self.gameManager.popupManager:addAsset(AssetIds.PAUSE_QUIT_BUTTON, quitButton)
end
function PauseMenu.prototype.canSave(self)
    return true
end
function PauseMenu.prototype.promptToQuit(self)
    local prompt = __TS__New(
        Prompt,
        self.gameManager,
        "Are you sure you want to quit?",
        function() return love.event.quit() end,
        function() return self.gameManager.popupManager:close() end,
        {secondaryMessage = "All unsaved progress will be lost."}
    )
    prompt:open(PopupIds.QUIT_PROMPT)
end
return ____exports
