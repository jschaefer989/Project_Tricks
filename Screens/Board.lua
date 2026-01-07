local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local CharacterTypes = ____Enums.CharacterTypes
local TextIds = ____Enums.TextIds
local Suits = ____Enums.Suits
local GameStates = ____Enums.GameStates
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local AnimationIds = ____Enums.AnimationIds
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____CardAssets = require("Assets.CardAssets")
local CardAssets = ____CardAssets.default
local cardHeight = ____CardAssets.cardHeight
local cardWidth = ____CardAssets.cardWidth
local padding = ____CardAssets.padding
local push = require("Libraries.push")
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Fonts = ____FontWithPosition.Fonts
local Format = ____FontWithPosition.Format
local OutlineThickness = ____FontWithPosition.OutlineThickness
local ____Card = require("Cards.Card")
local Card = ____Card.default
local ____IconAsset = require("Assets.IconAsset")
local IconAsset = ____IconAsset.default
local ____CutAnimation = require("Assets.Animations.CutAnimation")
local CutAnimation = ____CutAnimation.default
local ____FlickerAnimation = require("Assets.Animations.FlickerAnimation")
local FlickerAnimation = ____FlickerAnimation.default
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local portraitGap = 12
____exports.default = __TS__Class()
local Board = ____exports.default
Board.name = "Board"
function Board.prototype.____constructor(self, gameManager, enemy)
    self.discardUsed = 0
    self.playerPoints = 0
    self.enemyPoints = 0
    self.edelSuit = Suits.ACORNS
    self.playerPower = 0
    self.playerValue = 0
    self.enemyPower = 0
    self.enemyValue = 0
    self.showingEdelView = true
    self.winFireSound = love.audio.newSource("Assets/Sounds/Dominating.wav", "static")
    self.gameManager = gameManager
    self.enemy = enemy or __TS__New(Enemy, gameManager)
    self.dealer = __TS__New(Dealer, gameManager)
    self.cardAssets = __TS__New(CardAssets, gameManager)
end
function Board.prototype.load(self, data)
    self.discardUsed = data.discardUsed
    self.playerPoints = data.playerPoints
    self.enemyPoints = data.enemyPoints
    self.edelSuit = data.edelSuit
    self.playerPower = data.playerPower
    self.playerValue = data.playerValue
    self.enemyPower = data.enemyPower
    self.enemyValue = data.enemyValue
    local ____data_showingInitialView_0 = data.showingInitialView
    if ____data_showingInitialView_0 == nil then
        ____data_showingInitialView_0 = true
    end
    self.showingEdelView = ____data_showingInitialView_0
    self.enemy = __TS__New(Enemy, self.gameManager)
    self.enemy:load(self.gameManager, data.enemy)
end
function Board.prototype.save(self)
    return {
        discardUsed = self.discardUsed,
        playerPoints = self.playerPoints,
        enemyPoints = self.enemyPoints,
        enemy = self.enemy:save(),
        edelSuit = self.edelSuit,
        playerPower = self.playerPower,
        playerValue = self.playerValue,
        enemyPower = self.enemyPower,
        enemyValue = self.enemyValue,
        showingInitialView = self.showingEdelView
    }
end
function Board.prototype.getPlayerPoints(self)
    local points = self.playerValue - self.enemyValue
    if points < 0 then
        points = 0
    end
    return points
end
function Board.prototype.getEnemyPoints(self)
    local points = self.enemyValue - self.playerValue
    if points < 0 then
        points = 0
    end
    return points
end
function Board.prototype.handleStartFight(self)
    self.showingEdelView = false
    self.gameManager.assetManager:removeAssets(AssetIds.LETS_FIGHT_BUTTON)
    self.gameManager.assetManager.textManager:hideText(TextIds.LETS_FIGHT_BUTTON_CAPTION)
    self.dealer:startGame()
    self:buildFightAssets()
    self:hideEdelBoard()
end
function Board.prototype.buildFightAssets(self)
    self:buildPrimaryButtons()
    self:buildPointBoard()
    local portraitHeight = self:getPortraitHeight() or 0
    self:buildPowerAndValues(CharacterTypes.PLAYER, portraitHeight)
    self:buildPowerAndValues(CharacterTypes.ENEMY, portraitHeight)
end
function Board.prototype.hideEdelBoard(self)
    self.gameManager.assetManager.textManager:hideText(TextIds.EDEL_LABEL)
    self.gameManager.assetManager:removeAssets(AssetIds.EDEL_BOARD)
    self.gameManager.assetManager:removeAssets(AssetIds.EDEL_SUIT_ICON_LEFT)
    self.gameManager.assetManager:removeAssets(AssetIds.EDEL_SUIT_ICON_RIGHT)
end
function Board.prototype.handleAttack(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    if #self.enemy.deck == 0 then
        self:endFight()
        return
    end
    if self.playerPower > self.enemyPower then
        for ____, card in ipairs(self.enemy.hand) do
            self:startCutAnimation(card, CharacterTypes.PLAYER)
        end
        return
    else
        for ____, card in ipairs(self.gameManager.player.hand) do
            if card.isSelected then
                self:startCutAnimation(card, CharacterTypes.ENEMY)
            end
        end
    end
end
function Board.prototype.startCutAnimation(self, card, winner)
    local ____temp_1 = self.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_1.baseAsset
    local suitAssets = ____temp_1.suitAssets
    local rankAsset = ____temp_1.rankAsset
    local normalSuitAsset = suitAssets[1]
    local cutAnimationAssets = {}
    local baseId = AnimationIds.CARD_BASE_CUT .. card.id
    if not isEmpty(baseAsset) and not self.gameManager.animationManager.animations:has(baseId) then
        cutAnimationAssets[#cutAnimationAssets + 1] = baseAsset
    end
    local rankAssetId = AnimationIds.CARD_RANK_CUT .. card.id
    if not isEmpty(rankAsset) and not self.gameManager.animationManager.animations:has(rankAssetId) then
        cutAnimationAssets[#cutAnimationAssets + 1] = rankAsset
    end
    self.gameManager.animationManager.animations:set(
        baseId,
        __TS__New(
            CutAnimation,
            0,
            -40,
            cutAnimationAssets,
            {
                onFinish = function() return self:startFlickerAnimation(card, winner) end,
                animDuration = 0.25
            }
        )
    )
    local slideAnimationAssets = {}
    local normalSuitAssetId = AnimationIds.CARD_SUIT_NORMAL_CUT .. card.id
    if not isEmpty(normalSuitAsset) and not self.gameManager.animationManager.animations:has(normalSuitAssetId) then
        slideAnimationAssets[#slideAnimationAssets + 1] = normalSuitAsset
    end
    self.gameManager.animationManager.animations:set(
        normalSuitAssetId,
        __TS__New(
            SlideAnimation,
            0,
            -40,
            slideAnimationAssets,
            {animDuration = 0.25, drawSeparately = true}
        )
    )
end
function Board.prototype.startFlickerAnimation(self, card, winner)
    local ____temp_2 = self.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_2.baseAsset
    local suitAssets = ____temp_2.suitAssets
    local rankAsset = ____temp_2.rankAsset
    local normalSuitAsset = suitAssets[1]
    local flippedSuitAsset = suitAssets[2]
    local flickerAssets = {}
    if not isEmpty(baseAsset) then
        flickerAssets[#flickerAssets + 1] = baseAsset
    end
    if not isEmpty(rankAsset) then
        flickerAssets[#flickerAssets + 1] = rankAsset
    end
    if not isEmpty(normalSuitAsset) then
        flickerAssets[#flickerAssets + 1] = normalSuitAsset
    end
    if not isEmpty(flippedSuitAsset) then
        flickerAssets[#flickerAssets + 1] = flippedSuitAsset
    end
    local flickerId = AnimationIds.CARD_BASE_FLICKER .. card.id
    self.gameManager.animationManager.animations:set(
        flickerId,
        __TS__New(
            FlickerAnimation,
            flickerAssets,
            {
                onFinish = function() return self:dealNextRound(winner) end,
                animDuration = 0.6
            }
        )
    )
end
function Board.prototype.dealNextRound(self, winner)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    if winner == CharacterTypes.PLAYER then
        self:addPlayerPoints(self:getPlayerPoints())
    else
        self:addEnemyPoints(self:getEnemyPoints())
    end
    self.gameManager.player:removeSelectedCardsFromHand()
    self.dealer:dealCards(CharacterTypes.PLAYER)
    self.enemy:removeAllCardsFromHand()
    self:clearEnemyStats()
    self.dealer:dealCards(CharacterTypes.ENEMY)
end
function Board.prototype.addPlayerPoints(self, points)
    self.playerPoints = self.playerPoints + points
    self.gameManager.assetManager.textManager:updateText(
        TextIds.POINTS_PLAYER,
        (self.gameManager.player.name .. ": ") .. tostring(self.playerPoints)
    )
end
function Board.prototype.addEnemyPoints(self, points)
    self.enemyPoints = self.enemyPoints + points
    self.gameManager.assetManager.textManager:updateText(
        TextIds.POINTS_ENEMY,
        (self.enemy.name .. ": ") .. tostring(self.enemyPoints)
    )
end
function Board.prototype.handleDiscard(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    if self:getRemainingDiscards() <= 0 then
        return
    end
    self.gameManager.player:discard()
    self.discardUsed = self.discardUsed + 1
    local remaining = self:getRemainingDiscards()
    self.gameManager.assetManager.textManager:updateText(
        TextIds.DISCARD_BUTTON_COUNTER,
        (tostring(remaining) .. "/") .. tostring(self.gameManager.player.discards)
    )
    if remaining <= 0 then
        self.gameManager.assetManager:disableAsset(AssetIds.DISCARD_BUTTON)
        self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_CAPTION)
        self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_COUNTER)
    end
    local ____opt_3 = self.gameManager.board
    if ____opt_3 ~= nil then
        ____opt_3.dealer:dealCards(CharacterTypes.PLAYER)
    end
end
function Board.prototype.getRemainingDiscards(self)
    return self.gameManager.player.discards - self.discardUsed
end
function Board.prototype.getWinner(self)
    if self.playerPoints > self.enemyPoints then
        return CharacterTypes.PLAYER
    else
        return CharacterTypes.ENEMY
    end
end
function Board.prototype.endFight(self)
    self:clearStats()
    self.gameManager.player:deselectAllCards()
    local winner = self:getWinner()
    if winner == CharacterTypes.PLAYER then
        self.enemy:removeAllCardsFromHand()
        self.gameManager.player:addDiscardsToDeck()
        self.gameManager.player:cashout(self.playerPoints)
        self.dealer:getLootCards()
        self.gameManager:switchBasedOnGameState(GameStates.WIN_SCREEN)
    elseif winner == CharacterTypes.ENEMY then
        self.gameManager:switchBasedOnGameState(GameStates.LOSE_SCREEN)
    end
end
function Board.prototype.clearStats(self)
    self:clearPlayerStats()
    self:clearEnemyStats()
end
function Board.prototype.clearPlayerStats(self)
    self:addPlayerPower(-self.playerPower)
    self:addPlayerValue(-self.playerValue)
end
function Board.prototype.clearEnemyStats(self)
    self:addEnemyPower(-self.enemyPower)
    self:addEnemyValue(-self.enemyValue)
end
function Board.prototype.addPlayerPower(self, power)
    self.playerPower = self.playerPower + power
    self.gameManager.assetManager.textManager:updateText(
        TextIds.PLAYER_POWER,
        tostring(self.playerPower)
    )
    if self.playerPower > self.enemyPower then
        self:playWinFireSound()
        self:buildWinFire()
    else
        self:removeWinFire()
    end
end
function Board.prototype.addPlayerValue(self, value)
    self.playerValue = self.playerValue + value
    self.gameManager.assetManager.textManager:updateText(
        TextIds.PLAYER_VALUE,
        tostring(self.playerValue)
    )
    self.gameManager.assetManager.textManager:updateText(
        TextIds.POINTS,
        "Points: " .. tostring(self:getPlayerPoints())
    )
end
function Board.prototype.addEnemyPower(self, power)
    self.enemyPower = self.enemyPower + power
    self.gameManager.assetManager.textManager:updateText(
        TextIds.ENEMY_POWER,
        tostring(self.enemyPower)
    )
end
function Board.prototype.addEnemyValue(self, value)
    self.enemyValue = self.enemyValue + value
    self.gameManager.assetManager.textManager:updateText(
        TextIds.ENEMY_VALUE,
        tostring(self.enemyValue)
    )
end
function Board.prototype.buildAssets(self)
    self:buildBackground()
    self:buildCardAssets()
    self:buildPlayerPortrait()
    self:buildEnemyPortrait()
    self:buildPlayerDeck()
    self:buildEnemyDeck()
    if self.showingEdelView then
        self:buildLetsFightButton()
        self:buildEdelBoard()
    else
        self:buildFightAssets()
    end
end
function Board.prototype.buildCardAssets(self)
    local playerCardPosition = self.cardAssets:determineCardStartingPosition(CharacterTypes.PLAYER)
    do
        local i = 0
        while i < #self.gameManager.player.hand do
            local card = self.gameManager.player.hand[i + 1]
            local x = playerCardPosition.x + i * (cardWidth + padding)
            self.cardAssets:addAsset(card, x, playerCardPosition.y, not self.showingEdelView)
            i = i + 1
        end
    end
    local enemyCardPosition = self.cardAssets:determineCardStartingPosition(CharacterTypes.ENEMY)
    do
        local i = 0
        while i < #self.enemy.hand do
            local card = self.enemy.hand[i + 1]
            local x = enemyCardPosition.x + i * (cardWidth + padding)
            self.cardAssets:addAsset(card, x, enemyCardPosition.y, false)
            i = i + 1
        end
    end
end
function Board.prototype.buildLetsFightButton(self)
    local buttonHeight = 87
    local buttonWidth = 253
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local buttonX = math.floor((screenW - buttonWidth) / 2)
    local buttonY = math.floor((screenH - buttonHeight) / 2)
    local centerX = buttonX + buttonWidth / 2
    local centerY = buttonY + buttonHeight / 2
    local letsFightButtonText = __TS__New(
        FontWithPosition,
        TextIds.LETS_FIGHT_BUTTON_CAPTION,
        centerX + 14,
        centerY,
        "Let's Fight!",
        {size = 42, format = Format.CENTER, outlineThickness = OutlineThickness.THICK, font = Fonts.FANTASY}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.LETS_FIGHT_BUTTON_CAPTION, letsFightButtonText)
    self.gameManager.assetManager:addAsset(
        AssetIds.LETS_FIGHT_BUTTON,
        __TS__New(
            Asset,
            AssetIds.LETS_FIGHT_BUTTON,
            love.graphics.newImage("Assets/Images/LetsFightButton.png"),
            buttonX,
            centerY - buttonHeight / 2,
            buttonWidth,
            buttonHeight,
            {
                onClick = function() return self:handleStartFight() end,
                hoverEffect = {HoverEffects.CHANGE_COLOR},
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN},
                associatedTexts = {letsFightButtonText}
            }
        )
    )
end
function Board.prototype.buildPrimaryButtons(self)
    local gap = 10
    local btnW = 90
    local btnH = 70
    local totalW = btnW * 3 + gap * 2
    local buttonY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER) + cardHeight + gap
    local buttonX = math.floor((push:getWidth() - totalW) / 2)
    self:buildAttackButton(buttonX, buttonY, btnW, btnH)
    local discardX = self:buildDiscardButton(
        buttonX,
        buttonY,
        btnW,
        btnH,
        gap
    )
    self:buildDeselectButton(
        discardX,
        buttonY,
        btnW,
        btnH,
        gap
    )
    self:updatePrimaryButtonStates()
end
function Board.prototype.buildAttackButton(self, buttonX, buttonY, btnW, btnH)
    local centerX = buttonX + btnW / 2
    local centerY = buttonY + btnH / 2
    local attackButtonText = __TS__New(
        FontWithPosition,
        TextIds.ATTACK_BUTTON_CAPTION,
        centerX,
        centerY,
        "Attack",
        {size = 18, format = Format.CENTER}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.ATTACK_BUTTON_CAPTION, attackButtonText)
    self.gameManager.assetManager:addAsset(
        AssetIds.ATTACK_BUTTON,
        __TS__New(
            Asset,
            AssetIds.ATTACK_BUTTON,
            love.graphics.newImage("Assets/Images/AttackButton.png"),
            buttonX,
            buttonY,
            btnW,
            btnH,
            {
                onClick = function() return self:handleAttack() end,
                clickSound = love.audio.newSource("Assets/Sounds/AttackClicked.flac", "static"),
                associatedTexts = {attackButtonText},
                hoverEffect = {HoverEffects.CHANGE_COLOR},
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
            }
        )
    )
end
function Board.prototype.buildDiscardButton(self, buttonX, buttonY, btnW, btnH, gap)
    local discardX = buttonX + btnW + gap
    local centerX = discardX + btnW / 2
    local centerY = buttonY + btnH / 2
    local discardButtonCaptionText = __TS__New(
        FontWithPosition,
        TextIds.DISCARD_BUTTON_CAPTION,
        centerX,
        centerY,
        "Discard",
        {size = 18, format = Format.CENTER}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.DISCARD_BUTTON_CAPTION, discardButtonCaptionText)
    local remaining = self.gameManager.player.discards - self.discardUsed
    local discardButtonCounterText = __TS__New(
        FontWithPosition,
        TextIds.DISCARD_BUTTON_COUNTER,
        centerX,
        centerY + 12,
        (tostring(remaining) .. "/") .. tostring(self.gameManager.player.discards),
        {size = 9, format = Format.CENTER}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.DISCARD_BUTTON_COUNTER, discardButtonCounterText)
    self.gameManager.assetManager:addAsset(
        AssetIds.DISCARD_BUTTON,
        __TS__New(
            Asset,
            AssetIds.DISCARD_BUTTON,
            love.graphics.newImage("Assets/Images/DiscardButton.png"),
            discardX,
            buttonY,
            btnW,
            btnH,
            {
                onClick = function() return self:handleDiscard() end,
                associatedTexts = {discardButtonCaptionText, discardButtonCounterText},
                hoverEffect = {HoverEffects.CHANGE_COLOR},
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
            }
        )
    )
    return discardX
end
function Board.prototype.buildDeselectButton(self, discardX, buttonY, btnW, btnH, gap)
    local deselectX = discardX + btnW + gap
    local centerX = deselectX + btnW / 2
    local centerY = buttonY + btnH / 2
    local deselectButtonCaptionText = __TS__New(
        FontWithPosition,
        TextIds.DESELECT_BUTTON_CAPTION,
        centerX + 2,
        centerY,
        "Deselect",
        {size = 18, format = Format.CENTER}
    )
    self.gameManager.assetManager.textManager:addText(TextIds.DESELECT_BUTTON_CAPTION, deselectButtonCaptionText)
    self.gameManager.assetManager:addAsset(
        AssetIds.DESELECT_BUTTON,
        __TS__New(
            Asset,
            AssetIds.DESELECT_BUTTON,
            love.graphics.newImage("Assets/Images/DeselectButton.png"),
            deselectX,
            buttonY,
            btnW + 2,
            btnH,
            {
                onClick = function() return self.gameManager.player:unselectCards() end,
                associatedTexts = {deselectButtonCaptionText},
                hoverEffect = {HoverEffects.CHANGE_COLOR},
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
            }
        )
    )
end
function Board.prototype.updatePrimaryButtonStates(self)
    local hasSelectedCards = self.gameManager.player:anySelectedCards()
    if hasSelectedCards then
        self.gameManager.assetManager:enableAsset(AssetIds.ATTACK_BUTTON)
        self.gameManager.assetManager.textManager:enableText(TextIds.ATTACK_BUTTON_CAPTION)
        self.gameManager.assetManager:enableAsset(AssetIds.DISCARD_BUTTON)
        self.gameManager.assetManager.textManager:enableText(TextIds.DISCARD_BUTTON_CAPTION)
        self.gameManager.assetManager.textManager:enableText(TextIds.DISCARD_BUTTON_COUNTER)
        self.gameManager.assetManager:enableAsset(AssetIds.DESELECT_BUTTON)
        self.gameManager.assetManager.textManager:enableText(TextIds.DESELECT_BUTTON_CAPTION)
    else
        self.gameManager.assetManager:disableAsset(AssetIds.ATTACK_BUTTON)
        self.gameManager.assetManager.textManager:disableText(TextIds.ATTACK_BUTTON_CAPTION)
        self.gameManager.assetManager:disableAsset(AssetIds.DISCARD_BUTTON)
        self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_CAPTION)
        self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_COUNTER)
        self.gameManager.assetManager:disableAsset(AssetIds.DESELECT_BUTTON)
        self.gameManager.assetManager.textManager:disableText(TextIds.DESELECT_BUTTON_CAPTION)
    end
end
function Board.prototype.buildPointBoard(self)
    local boardWidth = 250
    local boardHeight = 23
    local screenW = push:getWidth()
    local buttonX = math.floor((screenW - boardWidth) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.POINT_DISPLAY,
        __TS__New(
            Asset,
            AssetIds.POINT_DISPLAY,
            love.graphics.newImage("Assets/Images/PointBoard.png"),
            buttonX,
            5,
            boardWidth,
            boardHeight
        )
    )
    local centerX = screenW / 2
    local textY = boardHeight / 2 + 5
    local playerText = (self.gameManager.player.name .. ": ") .. tostring(self.playerPoints)
    local enemyText = (self.enemy.name .. ": ") .. tostring(self.enemyPoints)
    self.gameManager.assetManager.textManager:addText(
        TextIds.POINTS_PLAYER,
        __TS__New(
            FontWithPosition,
            TextIds.POINTS_PLAYER,
            centerX - boardWidth / 2 + 5,
            textY,
            playerText,
            {size = 9}
        )
    )
    self.gameManager.assetManager.textManager:addText(
        TextIds.POINTS_ENEMY,
        __TS__New(
            FontWithPosition,
            TextIds.POINTS_ENEMY,
            centerX + boardWidth / 2 - 5,
            textY,
            enemyText,
            {size = 9, format = Format.RIGHT}
        )
    )
end
function Board.prototype.buildPowerAndValues(self, characterType, portraitHeight)
    local ____temp_5
    if characterType == CharacterTypes.PLAYER then
        ____temp_5 = self.gameManager.assetManager.textManager:getText(TextIds.PLAYER_PORTRAIT_LEVEL)
    else
        ____temp_5 = self.gameManager.assetManager.textManager:getText(TextIds.ENEMY_PORTRAIT_LEVEL)
    end
    local levelText = ____temp_5
    if isEmpty(levelText) then
        return
    end
    local powerId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_POWER or TextIds.ENEMY_POWER
    local powerValue = characterType == CharacterTypes.PLAYER and self.playerPower or self.enemyPower
    local attackPowerAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_ATTACK_POWER_ICON or AssetIds.ENEMY_ATTACK_POWER_ICON
    local powerY = levelText.y + portraitGap
    self.gameManager.assetManager.textManager:addText(
        powerId,
        __TS__New(
            FontWithPosition,
            powerId,
            20,
            powerY,
            tostring(powerValue),
            {icon = IconAsset:getPowerIconAsset(attackPowerAssetId)}
        )
    )
    local valueAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_VALUE_ICON or AssetIds.ENEMY_VALUE_ICON
    local valueId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_VALUE or TextIds.ENEMY_VALUE
    local valueValue = characterType == CharacterTypes.PLAYER and self.playerValue or self.enemyValue
    self.gameManager.assetManager.textManager:addText(
        valueId,
        __TS__New(
            FontWithPosition,
            valueId,
            20,
            powerY + portraitGap,
            tostring(valueValue),
            {icon = IconAsset:getValueIconAsset(valueAssetId)}
        )
    )
end
function Board.prototype.buildPlayerPortrait(self)
    self:buildPortrait(CharacterTypes.PLAYER)
    self:buildPowerAndValues(
        CharacterTypes.PLAYER,
        self:getPortraitHeight() or 0
    )
end
function Board.prototype.getPortraitHeight(self)
    local portraitAsset = self.gameManager.assetManager:getAsset(AssetIds.PLAYER_PORTRAIT, AssetIds.PLAYER_PORTRAIT)
    if isEmpty(portraitAsset) then
        return
    end
    return portraitAsset:getHeight()
end
function Board.prototype.getPortraitWidth(self)
    local portraitAsset = self.gameManager.assetManager:getAsset(AssetIds.PLAYER_PORTRAIT, AssetIds.PLAYER_PORTRAIT)
    if isEmpty(portraitAsset) then
        return
    end
    return portraitAsset:getWidth()
end
function Board.prototype.buildEnemyPortrait(self)
    self:buildPortrait(CharacterTypes.ENEMY)
end
function Board.prototype.buildPortrait(self, characterType)
    if self.portraitPosition == nil and characterType == CharacterTypes.PLAYER then
        self.portraitPosition = self.cardAssets:getCardPosition(characterType)
    end
    local portraitPosition = self:getPortraitPosition(characterType)
    local portraitBackgroundW = 99
    local portraitBackgroundH = 106
    local portraitBackgroundAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT_BACKGROUND or AssetIds.ENEMY_PORTRAIT_BACKGROUND
    self.gameManager.assetManager:addAsset(
        portraitBackgroundAssetId,
        __TS__New(
            Asset,
            portraitBackgroundAssetId,
            love.graphics.newImage("Assets/Images/PortraitBackground.png"),
            5,
            portraitPosition,
            portraitBackgroundW,
            portraitBackgroundH
        )
    )
    local portraitW = 54
    local portraitH = 53
    local portraitAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT or AssetIds.ENEMY_PORTRAIT
    self.gameManager.assetManager:addAsset(
        portraitAssetId,
        __TS__New(
            Asset,
            portraitAssetId,
            love.graphics.newImage("Assets/Images/Portrait.png"),
            5,
            portraitPosition,
            portraitW,
            portraitH
        )
    )
    local portraitNameId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_PORTRAIT_NAME or TextIds.ENEMY_PORTRAIT_NAME
    local nameY = portraitH + portraitPosition + 10
    self.gameManager.assetManager.textManager:addText(
        portraitNameId,
        __TS__New(
            FontWithPosition,
            portraitNameId,
            10,
            nameY,
            characterType == CharacterTypes.PLAYER and self.gameManager.player.name or self.enemy.name,
            {size = 16, font = Fonts.FANTASY}
        )
    )
    local portraitLevelId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_PORTRAIT_LEVEL or TextIds.ENEMY_PORTRAIT_LEVEL
    local levelY = nameY + portraitGap
    self.gameManager.assetManager.textManager:addText(
        portraitLevelId,
        __TS__New(
            FontWithPosition,
            portraitLevelId,
            10,
            levelY,
            "Lvl " .. tostring(characterType == CharacterTypes.PLAYER and self.gameManager.player.level or self.enemy.level),
            {size = 9}
        )
    )
    if characterType == CharacterTypes.PLAYER then
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
        self.gameManager.assetManager:addAsset(
            AssetIds.PERKS_BUTTON,
            __TS__New(
                Asset,
                AssetIds.PERKS_BUTTON,
                love.graphics.newImage("Assets/Images/PerksButton.png"),
                portraitW + 8,
                portraitPosition + 10,
                39,
                18,
                {onClick = function() return self.gameManager:switchBasedOnGameState(GameStates.PERKS) end}
            )
        )
        self.gameManager.assetManager.textManager:addText(
            TextIds.PLAYER_PERKS,
            __TS__New(
                FontWithPosition,
                TextIds.PLAYER_PERKS,
                portraitW + 13,
                portraitPosition + 20,
                "Perks",
                {size = 9}
            )
        )
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
                        AssetIds.MONEY_ICON,
                        love.graphics.newImage("Assets/Images/Mark.png"),
                        9,
                        9
                    ),
                    format = Format.RIGHT
                }
            )
        )
    end
end
function Board.prototype.buildPlayerDeck(self)
    local portraitPosition = self:getPortraitPosition(CharacterTypes.PLAYER)
    self.gameManager.assetManager:addAsset(
        AssetIds.PLAYER_DECK,
        __TS__New(
            Asset,
            AssetIds.PLAYER_DECK,
            love.graphics.newImage("Assets/Images/BaseCardBack.png"),
            push:getWidth() - cardWidth - 5,
            portraitPosition,
            cardWidth,
            cardHeight
        )
    )
end
function Board.prototype.buildEnemyDeck(self)
    self.gameManager.assetManager:addAsset(
        AssetIds.ENEMY_DECK,
        __TS__New(
            Asset,
            AssetIds.ENEMY_DECK,
            love.graphics.newImage("Assets/Images/BaseCardBack.png"),
            push:getWidth() - cardWidth - 5,
            5,
            cardWidth,
            cardHeight
        )
    )
end
function Board.prototype.buildEdelBoard(self)
    local boardWidth = 149
    local boardHeight = 23
    local screenW = push:getWidth()
    local boardX = math.floor((screenW - boardWidth) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_BOARD,
        __TS__New(
            Asset,
            AssetIds.EDEL_BOARD,
            love.graphics.newImage("Assets/Images/EdelBoard.png"),
            boardX,
            5,
            boardWidth,
            boardHeight
        )
    )
    local centerX = screenW / 2
    self.gameManager.assetManager.textManager:addText(
        TextIds.EDEL_LABEL,
        __TS__New(
            FontWithPosition,
            TextIds.EDEL_LABEL,
            centerX,
            18,
            Card:getSuitName(self.edelSuit),
            {size = 16, format = Format.CENTER, font = Fonts.ELOQUENT}
        )
    )
    local suitImage = love.graphics.newImage(CardAssets:getSuitAssetPath(self.edelSuit))
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_SUIT_ICON_LEFT,
        __TS__New(
            Asset,
            AssetIds.EDEL_SUIT_ICON_LEFT,
            suitImage,
            boardX + 5,
            8,
            16,
            16
        )
    )
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_SUIT_ICON_RIGHT,
        __TS__New(
            Asset,
            AssetIds.EDEL_SUIT_ICON_RIGHT,
            suitImage,
            boardX + boardWidth - suitImage:getWidth() - 5,
            8,
            16,
            16
        )
    )
end
function Board.prototype.buildBackground(self)
    self.gameManager.assetManager:addAsset(
        AssetIds.BACKGROUND,
        __TS__New(
            Asset,
            AssetIds.BACKGROUND,
            love.graphics.newImage(self.gameManager.biome.boardBackgroundImagePath),
            0,
            0,
            640,
            360
        )
    )
end
function Board.prototype.playWinFireSound(self)
    if not self.winFireSound:isPlaying() then
        self.winFireSound:play()
    end
end
function Board.prototype.buildWinFire(self)
    local fireSprite = self:getWinFireSprite()
    local portraitWidth = self:getPortraitWidth() or 0
    local portraitHeight = self:getPortraitHeight() or 0
    local playerPortraitY = self:getPortraitPosition(CharacterTypes.PLAYER)
    local enemyPortraitY = self:getPortraitPosition(CharacterTypes.ENEMY)
    local portraitCenterX = 5 + portraitWidth / 2
    local playerCenterY = playerPortraitY + portraitHeight / 2
    local enemyCenterY = enemyPortraitY + portraitHeight / 2
    local centerY = (playerCenterY + enemyCenterY) / 2
    self.gameManager.assetManager:addAsset(
        AssetIds.BASIC_WIN_FIRE,
        __TS__New(
            Asset,
            AssetIds.BASIC_WIN_FIRE,
            fireSprite,
            portraitCenterX - fireSprite:getWidth() / 4,
            centerY - fireSprite:getHeight() / 4,
            90,
            90
        )
    )
    self.gameManager.assetManager.textManager:addText(
        TextIds.WIN_FIRE_TEXT,
        __TS__New(
            FontWithPosition,
            TextIds.WIN_FIRE_TEXT,
            portraitCenterX + 20,
            centerY + 20,
            "You are winning!",
            {size = 9, format = Format.CENTER, outlineThickness = OutlineThickness.THICK}
        )
    )
    local points = self:getPlayerPoints()
    if points <= 0 then
        self.gameManager.assetManager.textManager:addText(
            TextIds.POINTS,
            __TS__New(
                FontWithPosition,
                TextIds.POINTS,
                portraitCenterX + 15,
                centerY + 32,
                "But you'll get no points...",
                {size = 9, format = Format.CENTER}
            )
        )
    else
        self.gameManager.assetManager.textManager:addText(
            TextIds.POINTS,
            __TS__New(
                FontWithPosition,
                TextIds.POINTS,
                portraitCenterX + 10,
                centerY + 32,
                "Points: " .. tostring(points),
                {size = 9, format = Format.CENTER}
            )
        )
    end
end
function Board.prototype.removeWinFire(self)
    self.gameManager.assetManager:removeAssets(AssetIds.BASIC_WIN_FIRE)
    self.gameManager.assetManager.textManager:hideText(TextIds.WIN_FIRE_TEXT)
    self.gameManager.assetManager.textManager:hideText(TextIds.POINTS)
end
function Board.prototype.getWinFireSprite(self)
    return love.graphics.newImage("Assets/Images/BasicWinFire.png")
end
function Board.prototype.getPortraitPosition(self, characterType)
    return characterType == CharacterTypes.PLAYER and (self.portraitPosition or self.cardAssets:getCardPosition(characterType)) or 5
end
return ____exports
