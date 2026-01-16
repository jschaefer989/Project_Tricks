local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Fonts = ____FontWithPosition.Fonts
local Format = ____FontWithPosition.Format
local ____IconAsset = require("Assets.IconAsset")
local IconAsset = ____IconAsset.default
local ____Enums = require("Enums")
local CharacterTypes = ____Enums.CharacterTypes
local AssetIds = ____Enums.AssetIds
local TextIds = ____Enums.TextIds
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
local portraitBackgroundW = 99
local portraitBackgroundH = 106
local portraitW = 54
local portraitH = 53
local portraitGap = 12
____exports.default = __TS__Class()
local CharacterInfoPanel = ____exports.default
CharacterInfoPanel.name = "CharacterInfoPanel"
function CharacterInfoPanel.prototype.____constructor(self, gameManager, character)
    self.gameManager = gameManager
    self.character = character
end
function CharacterInfoPanel.prototype.showPortrait(self)
    self:buildPortraitBackground()
    self:buildPortrait()
    local nameY = self:buildPortraitName()
    local levelY = self:buildPortraitLevel(nameY)
    self:buildCharacterSpecificInfo(nameY, levelY)
    self:buildPowerAndValues()
end
function CharacterInfoPanel.prototype.buildPortraitBackground(self)
    self.gameManager.assetManager:addAsset(
        self:getPortraitBackgroundId(),
        __TS__New(
            Asset,
            self.gameManager,
            self:getPortraitBackgroundId(),
            self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PortraitBackground.png"),
            5,
            self:getPortraitPosition(),
            portraitBackgroundW,
            portraitBackgroundH
        )
    )
end
function CharacterInfoPanel.prototype.buildPortrait(self)
    self.gameManager.assetManager:addAsset(
        self:getPortraitId(),
        __TS__New(
            Asset,
            self.gameManager,
            self:getPortraitId(),
            self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/Portrait.png"),
            5,
            self:getPortraitPosition(),
            portraitW,
            portraitH
        )
    )
end
function CharacterInfoPanel.prototype.buildPortraitName(self)
    local nameY = portraitH + self:getPortraitPosition() + 10
    self.gameManager.assetManager.textManager:addText(
        self:getPortraitNameId(),
        __TS__New(
            FontWithPosition,
            self:getPortraitNameId(),
            10,
            nameY,
            self.character.name,
            {size = 16, font = Fonts.FANTASY}
        )
    )
    return nameY
end
function CharacterInfoPanel.prototype.buildPortraitLevel(self, nameY)
    local levelY = nameY + portraitGap
    self.gameManager.assetManager.textManager:addText(
        self:getPortraitLevelId(),
        __TS__New(
            FontWithPosition,
            self:getPortraitLevelId(),
            10,
            levelY,
            "Lvl " .. tostring(self.character.level),
            {size = 9}
        )
    )
    return levelY
end
function CharacterInfoPanel.prototype.buildCharacterSpecificInfo(self, nameY, levelY)
    repeat
        local ____switch9 = self.character.type
        local ____cond9 = ____switch9 == CharacterTypes.PLAYER
        if ____cond9 then
            self:buildPlayerInfo(nameY, levelY)
            break
        end
        ____cond9 = ____cond9 or ____switch9 == CharacterTypes.ENEMY
        if ____cond9 then
            break
        end
    until true
end
function CharacterInfoPanel.prototype.buildPlayerInfo(self, nameY, levelY)
    self:buildPlayerExperience(levelY)
    self:buildPerksButton()
    self:buildPlayerMoney(nameY)
end
function CharacterInfoPanel.prototype.buildPlayerExperience(self, levelY)
    self.gameManager.assetManager.textManager:addText(
        TextIds.PLAYER_PORTRAIT_EXPERIENCE,
        __TS__New(
            FontWithPosition,
            TextIds.PLAYER_PORTRAIT_EXPERIENCE,
            portraitBackgroundW,
            levelY,
            tostring(self.gameManager.player.experience) .. " xp",
            {size = 9, format = Format.RIGHT}
        )
    )
end
function CharacterInfoPanel.prototype.buildPerksButton(self)
    local perksText = __TS__New(
        FontWithPosition,
        TextIds.PLAYER_PERKS,
        portraitW + 13,
        self:getPortraitPosition() + 20,
        "Perks",
        {size = 9}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.PLAYER_PERKS, perksText)
    self.gameManager.assetManager:addAsset(
        AssetIds.PERKS_BUTTON,
        __TS__New(
            Asset,
            self.gameManager,
            AssetIds.PERKS_BUTTON,
            self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/PerksButton.png"),
            portraitW + 8,
            self:getPortraitPosition() + 10,
            39,
            18,
            {
                onClick = function() return self.gameManager.perkScreen:showPerks() end,
                clickSound = self.gameManager.assetManager.buttonClickSound,
                associatedTexts = {perksText},
                hoverEffect = {HoverEffects.CHANGE_COLOR},
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN},
                alwaysEnabled = true
            }
        )
    )
end
function CharacterInfoPanel.prototype.buildPlayerMoney(self, nameY)
    self.gameManager.assetManager.textManager:addText(
        TextIds.PLAYER_PORTRAIT_MONEY,
        __TS__New(
            FontWithPosition,
            TextIds.PLAYER_PORTRAIT_MONEY,
            portraitBackgroundW - 2,
            nameY,
            tostring(self.gameManager.player.money),
            {
                size = 9,
                icon = __TS__New(
                    IconAsset,
                    self.gameManager,
                    AssetIds.MONEY_ICON,
                    self.gameManager.assetManager.assetLoader:loadImage("Assets/Images/Mark.png"),
                    9,
                    9
                ),
                format = Format.RIGHT
            }
        )
    )
end
function CharacterInfoPanel.prototype.buildPowerAndValues(self)
    local board = self.gameManager.board
    if isEmpty(board) then
        return
    end
    local levelText = self.gameManager.assetManager.textManager:getText(self:getPortraitLevelId())
    if isEmpty(levelText) then
        return
    end
    local powerY = levelText.y + portraitGap
    self.gameManager.assetManager.textManager:addText(
        self:getPortraitPowerId(),
        __TS__New(
            FontWithPosition,
            self:getPortraitPowerId(),
            20,
            powerY,
            tostring(board:getCharacterPower(self.character.type)),
            {icon = IconAsset:getPowerIconAsset(
                self.gameManager,
                self:getPortraitPowerIconId()
            )}
        )
    )
    self.gameManager.assetManager.textManager:addText(
        self:getPortraitValueId(),
        __TS__New(
            FontWithPosition,
            self:getPortraitValueId(),
            20,
            powerY + portraitGap,
            tostring(board:getCharacterValue(self.character.type)),
            {icon = IconAsset:getValueIconAsset(
                self.gameManager,
                self:getPortraitValueIconId()
            )}
        )
    )
end
function CharacterInfoPanel.prototype.getPortraitBackgroundId(self)
    repeat
        local ____switch19 = self.character.type
        local ____cond19 = ____switch19 == CharacterTypes.PLAYER
        if ____cond19 then
            return AssetIds.PLAYER_PORTRAIT_BACKGROUND
        end
        ____cond19 = ____cond19 or ____switch19 == CharacterTypes.ENEMY
        if ____cond19 then
            return AssetIds.ENEMY_PORTRAIT_BACKGROUND
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitId(self)
    repeat
        local ____switch21 = self.character.type
        local ____cond21 = ____switch21 == CharacterTypes.PLAYER
        if ____cond21 then
            return AssetIds.PLAYER_PORTRAIT
        end
        ____cond21 = ____cond21 or ____switch21 == CharacterTypes.ENEMY
        if ____cond21 then
            return AssetIds.ENEMY_PORTRAIT
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitNameId(self)
    repeat
        local ____switch23 = self.character.type
        local ____cond23 = ____switch23 == CharacterTypes.PLAYER
        if ____cond23 then
            return TextIds.PLAYER_PORTRAIT_NAME
        end
        ____cond23 = ____cond23 or ____switch23 == CharacterTypes.ENEMY
        if ____cond23 then
            return TextIds.ENEMY_PORTRAIT_NAME
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitLevelId(self)
    repeat
        local ____switch25 = self.character.type
        local ____cond25 = ____switch25 == CharacterTypes.PLAYER
        if ____cond25 then
            return TextIds.PLAYER_PORTRAIT_LEVEL
        end
        ____cond25 = ____cond25 or ____switch25 == CharacterTypes.ENEMY
        if ____cond25 then
            return TextIds.ENEMY_PORTRAIT_LEVEL
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitPowerId(self)
    repeat
        local ____switch27 = self.character.type
        local ____cond27 = ____switch27 == CharacterTypes.PLAYER
        if ____cond27 then
            return TextIds.PLAYER_POWER
        end
        ____cond27 = ____cond27 or ____switch27 == CharacterTypes.ENEMY
        if ____cond27 then
            return TextIds.ENEMY_POWER
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitPowerIconId(self)
    repeat
        local ____switch29 = self.character.type
        local ____cond29 = ____switch29 == CharacterTypes.PLAYER
        if ____cond29 then
            return AssetIds.PLAYER_ATTACK_POWER_ICON
        end
        ____cond29 = ____cond29 or ____switch29 == CharacterTypes.ENEMY
        if ____cond29 then
            return AssetIds.ENEMY_ATTACK_POWER_ICON
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitValueId(self)
    repeat
        local ____switch31 = self.character.type
        local ____cond31 = ____switch31 == CharacterTypes.PLAYER
        if ____cond31 then
            return TextIds.PLAYER_VALUE
        end
        ____cond31 = ____cond31 or ____switch31 == CharacterTypes.ENEMY
        if ____cond31 then
            return TextIds.ENEMY_VALUE
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitValueIconId(self)
    repeat
        local ____switch33 = self.character.type
        local ____cond33 = ____switch33 == CharacterTypes.PLAYER
        if ____cond33 then
            return AssetIds.PLAYER_VALUE_ICON
        end
        ____cond33 = ____cond33 or ____switch33 == CharacterTypes.ENEMY
        if ____cond33 then
            return AssetIds.ENEMY_VALUE_ICON
        end
    until true
end
function CharacterInfoPanel.prototype.getPortraitHeight(self)
    local portraitAsset = self.gameManager.assetManager:getAsset(AssetIds.PLAYER_PORTRAIT, AssetIds.PLAYER_PORTRAIT)
    if isEmpty(portraitAsset) then
        return
    end
    return portraitAsset:getHeight()
end
function CharacterInfoPanel.prototype.getPortraitWidth(self)
    local portraitAsset = self.gameManager.assetManager:getAsset(AssetIds.PLAYER_PORTRAIT, AssetIds.PLAYER_PORTRAIT)
    if isEmpty(portraitAsset) then
        return
    end
    return portraitAsset:getWidth()
end
function CharacterInfoPanel.prototype.getPortraitPosition(self)
    local assetY = self.gameManager.assetManager:getAsset(
        self:getPortraitId(),
        self:getPortraitId()
    )
    if not isEmpty(assetY) then
        return assetY.y
    end
    repeat
        local ____switch40 = self.character.type
        local cardAssets
        local ____cond40 = ____switch40 == CharacterTypes.PLAYER
        if ____cond40 then
            local ____opt_0 = self.gameManager.board
            cardAssets = ____opt_0 and ____opt_0.cardAssets
            if not isEmpty(cardAssets) then
                return cardAssets:getHandYCoordinate(self.character.type)
            end
            return push:getHeight() - (self:getPortraitHeight() or 0) - 10
        end
        ____cond40 = ____cond40 or ____switch40 == CharacterTypes.ENEMY
        if ____cond40 then
            return 5
        end
    until true
end
return ____exports
