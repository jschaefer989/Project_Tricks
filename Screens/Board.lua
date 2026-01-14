local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____CutAnimation = require("Assets.Animations.CutAnimation")
local CutAnimation = ____CutAnimation.default
local ____FlickerAnimation = require("Assets.Animations.FlickerAnimation")
local FlickerAnimation = ____FlickerAnimation.default
local ____GlowAnimation = require("Assets.Animations.GlowAnimation")
local GlowAnimation = ____GlowAnimation.default
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____CardAssets = require("Assets.CardAssets")
local CardAssets = ____CardAssets.default
local cardHeight = ____CardAssets.cardHeight
local cardWidth = ____CardAssets.cardWidth
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Fonts = ____FontWithPosition.Fonts
local Format = ____FontWithPosition.Format
local OutlineThickness = ____FontWithPosition.OutlineThickness
local ____IconAsset = require("Assets.IconAsset")
local IconAsset = ____IconAsset.default
local ____Card = require("Cards.Card")
local Card = ____Card.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local push = require("Libraries.push")
local ____ShimmerShader = require("Shaders.ShimmerShader")
local ShimmerShader = ____ShimmerShader.default
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Enums = require("Enums")
local AnimationIds = ____Enums.AnimationIds
local AssetIds = ____Enums.AssetIds
local CharacterTypes = ____Enums.CharacterTypes
local GameStates = ____Enums.GameStates
local HoverEffects = ____Enums.HoverEffects
local MousePressEffects = ____Enums.MousePressEffects
local TextIds = ____Enums.TextIds
local portraitGap = 12
____exports.default = __TS__Class()
local Board = ____exports.default
Board.name = "Board"
function Board.prototype.____constructor(self, gameManager, enemy)
    self.discardUsed = 0
    self.playerPoints = 0
    self.enemyPoints = 0
    self.playerPower = 0
    self.playerValue = 0
    self.enemyPower = 0
    self.enemyValue = 0
    self.showingEdelView = true
    self.winFireSound = love.audio.newSource("Assets/Sounds/Dominating.wav", "static")
    self.gameManager = gameManager
    self.enemy = enemy or __TS__New(Enemy, gameManager)
    self.dealer = __TS__New(Dealer, gameManager, self)
    self.cardAssets = __TS__New(CardAssets, gameManager, self)
end
function Board.prototype.load(self, data)
    self.discardUsed = data.discardUsed
    self.playerPoints = data.playerPoints
    self.enemyPoints = data.enemyPoints
    self.edelCard = data.edelCard
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
        edelCard = self.edelCard,
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
    local ____opt_1 = self.gameManager.board
    if ____opt_1 ~= nil then
        ____opt_1.cardAssets:disableAllCards(true)
    end
    self.dealer:dealHandAtStartOfFight()
    self:hideEdelBoard()
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
    local ____opt_3 = self.gameManager.board
    if ____opt_3 ~= nil then
        ____opt_3.cardAssets:disableAllCards(true)
    end
    if #self.enemy.deck == 0 then
        self:endFight()
        return
    end
    if self.playerPower > self.enemyPower then
        for ____, card in ipairs(self:getSlainCards(CharacterTypes.ENEMY)) do
            self.cardAssets:redrawCard(card)
            self:startCutAnimation(card, CharacterTypes.PLAYER, CharacterTypes.ENEMY)
        end
        return
    else
        for ____, card in ipairs(self:getSlainCards(CharacterTypes.PLAYER)) do
            self.cardAssets:redrawCard(card)
            self:startCutAnimation(card, CharacterTypes.ENEMY, CharacterTypes.PLAYER)
        end
    end
end
function Board.prototype.getSlainCards(self, characterType)
    repeat
        local ____switch21 = characterType
        local ____cond21 = ____switch21 == CharacterTypes.PLAYER
        if ____cond21 then
            return __TS__ArrayFilter(
                self.gameManager.player.hand,
                function(____, card) return card.isSelected end
            )
        end
        ____cond21 = ____cond21 or ____switch21 == CharacterTypes.ENEMY
        if ____cond21 then
            return self.enemy.hand
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Board.prototype.startCutAnimation(self, card, winner, loser)
    local ____temp_5 = self.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_5.baseAsset
    local suitAssets = ____temp_5.suitAssets
    local rankAsset = ____temp_5.rankAsset
    local normalSuitAsset = suitAssets[1]
    local cutAnimationAssets = {}
    if not isEmpty(baseAsset) then
        cutAnimationAssets[#cutAnimationAssets + 1] = baseAsset
    end
    if not isEmpty(rankAsset) then
        cutAnimationAssets[#cutAnimationAssets + 1] = rankAsset
    end
    self.gameManager.animationManager:startAnimation(
        AnimationIds.CARD_CUT .. card.id,
        __TS__New(
            CutAnimation,
            0.15,
            0,
            -40,
            cutAnimationAssets,
            {onFinish = function() return self:startFlickerAnimation(card, winner, loser) end}
        )
    )
    local slideAnimationAssets = {}
    if not isEmpty(normalSuitAsset) then
        slideAnimationAssets[#slideAnimationAssets + 1] = normalSuitAsset
    end
    self.gameManager.animationManager:startAnimation(
        AnimationIds.CARD_SUIT_SLIDE .. card.id,
        __TS__New(
            SlideAnimation,
            0.15,
            0,
            -40,
            slideAnimationAssets,
            {drawSeparately = true}
        )
    )
end
function Board.prototype.startFlickerAnimation(self, card, winner, loser)
    self.gameManager.animationManager:startAnimation(
        AnimationIds.CARD_FLICKER .. card.id,
        __TS__New(
            FlickerAnimation,
            self.cardAssets:getCardAssetList(card),
            {
                onFinish = function() return self:wrapUpAttack(winner, loser) end,
                animDuration = 0.6
            }
        )
    )
end
function Board.prototype.wrapUpAttack(self, winner, loser)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    self:hideSlainCards(loser)
    self:addPoints(winner)
    self.dealer:dealNextHand()
    self:clearEnemyStats()
end
function Board.prototype.hideSlainCards(self, characterType)
    for ____, card in ipairs(self:getSlainCards(characterType)) do
        self.cardAssets:removeCardAssets(card)
    end
end
function Board.prototype.addPlayerPoints(self, points)
    self.playerPoints = self.playerPoints + points
    self.gameManager.assetManager.textManager:updateText(
        TextIds.POINTS_PLAYER,
        (self.gameManager.player.name .. ": ") .. tostring(self.playerPoints)
    )
end
function Board.prototype.getAllCardsInPlay(self)
    local cardsInPlay = {}
    for ____, card in ipairs(self.gameManager.player.hand) do
        cardsInPlay[#cardsInPlay + 1] = card
    end
    for ____, card in ipairs(self.enemy.hand) do
        cardsInPlay[#cardsInPlay + 1] = card
    end
    return cardsInPlay
end
function Board.prototype.addPoints(self, winner)
    repeat
        local ____switch42 = winner
        local ____cond42 = ____switch42 == CharacterTypes.PLAYER
        if ____cond42 then
            self:addPlayerPoints(self:getPlayerPoints())
            break
        end
        ____cond42 = ____cond42 or ____switch42 == CharacterTypes.ENEMY
        if ____cond42 then
            self:addEnemyPoints(self:getEnemyPoints())
            break
        end
        do
            exhaustiveGuard(winner)
        end
    until true
end
function Board.prototype.addEnemyPoints(self, points)
    self.enemyPoints = self.enemyPoints + points
    self.gameManager.assetManager.textManager:updateText(
        TextIds.POINTS_ENEMY,
        (self.enemy.name .. ": ") .. tostring(self.enemyPoints)
    )
end
function Board.prototype.displayEdel(self)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    self.cardAssets:disableAllCards(false)
    self:buildLetsFightButton()
    self:buildEdelBoard()
    if not isEmpty(self.edelCard) then
        self.gameManager.animationManager:startAnimation(
            AnimationIds.EDEL_CARD,
            __TS__New(
                GlowAnimation,
                function()
                    local ____opt_6 = self.gameManager.board
                    return not (____opt_6 and ____opt_6.showingEdelView)
                end,
                {unpack(self.cardAssets:getCardAssetList(self.edelCard))},
                {glowPeriodSeconds = 3}
            )
        )
        local ____temp_8 = self.cardAssets:getCardAssets(self.edelCard)
        local baseAsset = ____temp_8.baseAsset
        if not isEmpty(baseAsset) then
            self.gameManager.shaderManager:addShader(
                baseAsset.id,
                __TS__New(
                    ShimmerShader,
                    self.gameManager,
                    function() return not self.showingEdelView end,
                    {baseAsset}
                )
            )
        end
    end
end
function Board.prototype.displayFight(self)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    self.cardAssets:disableAllCards(false)
    self:buildPrimaryButtons()
    self:buildPointBoard()
    local portraitHeight = self:getPortraitHeight() or 0
    self:buildPowerAndValues(CharacterTypes.PLAYER, portraitHeight)
    self:buildPowerAndValues(CharacterTypes.ENEMY, portraitHeight)
end
function Board.prototype.handleDiscard(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    if self:getRemainingDiscards() <= 0 then
        return
    end
    local ____opt_9 = self.gameManager.board
    if ____opt_9 ~= nil then
        ____opt_9.cardAssets:disableAllCards(true)
    end
    local removedIndices = self.dealer:discardCards(
        CharacterTypes.PLAYER,
        self.gameManager.player:getSelectedCards()
    )
    self.discardUsed = self.discardUsed + 1
    local remaining = self:getRemainingDiscards()
    self:updateDiscardCounter(remaining)
    if remaining <= 0 then
        self:disableDiscardButton()
    end
    local ____opt_11 = self.gameManager.board
    if ____opt_11 ~= nil then
        ____opt_11.dealer:dealCards(CharacterTypes.PLAYER, removedIndices)
    end
end
function Board.prototype.updateDiscardCounter(self, remainingNumberOfDiscards)
    self.gameManager.assetManager.textManager:updateText(
        TextIds.DISCARD_BUTTON_COUNTER,
        (tostring(remainingNumberOfDiscards) .. "/") .. tostring(self.gameManager.player.discards)
    )
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
function Board.prototype.start(self)
    self:buildPlayerPortrait()
    self:buildEnemyPortrait()
    self:buildDeck(CharacterTypes.PLAYER)
    self:buildDeck(CharacterTypes.ENEMY)
    self.dealer:dealEdel()
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
            self.gameManager,
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
                associatedTexts = {letsFightButtonText},
                clickSound = self.gameManager.assetManager.buttonClickSound
            }
        )
    )
end
function Board.prototype.buildPrimaryButtons(self)
    local gap = 10
    local btnW = 90
    local btnH = 70
    local totalW = btnW * 3 + gap * 2
    local buttonY = self.cardAssets:getHandYCoordinate(CharacterTypes.PLAYER) + cardHeight + gap
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
            self.gameManager,
            AssetIds.ATTACK_BUTTON,
            love.graphics.newImage("Assets/Images/AttackButton.png"),
            buttonX,
            buttonY,
            btnW,
            btnH,
            {
                onClick = function() return self:handleAttack() end,
                clickSound = self.gameManager.assetManager.buttonClickSound,
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
            self.gameManager,
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
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN},
                clickSound = self.gameManager.assetManager.buttonClickSound
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
            self.gameManager,
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
                mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN},
                clickSound = self.gameManager.assetManager.buttonClickSound
            }
        )
    )
end
function Board.prototype.updatePrimaryButtonStates(self)
    local hasSelectedCards = self.gameManager.player:anySelectedCards()
    if hasSelectedCards then
        self:enableAttackButton()
        self:enableDiscardButton()
        self:enableDeselectButton()
    else
        self:disableAttackButton()
        self:disableDiscardButton()
        self:disableDeselectButton()
    end
end
function Board.prototype.enableAttackButton(self)
    self.gameManager.assetManager:enableAsset(AssetIds.ATTACK_BUTTON)
    self.gameManager.assetManager.textManager:enableText(TextIds.ATTACK_BUTTON_CAPTION)
end
function Board.prototype.enableDiscardButton(self)
    if self:getRemainingDiscards() <= 0 then
        return
    end
    self.gameManager.assetManager:enableAsset(AssetIds.DISCARD_BUTTON)
    self.gameManager.assetManager.textManager:enableText(TextIds.DISCARD_BUTTON_CAPTION)
    self.gameManager.assetManager.textManager:enableText(TextIds.DISCARD_BUTTON_COUNTER)
end
function Board.prototype.enableDeselectButton(self)
    self.gameManager.assetManager:enableAsset(AssetIds.DESELECT_BUTTON)
    self.gameManager.assetManager.textManager:enableText(TextIds.DESELECT_BUTTON_CAPTION)
end
function Board.prototype.disableAttackButton(self)
    self.gameManager.assetManager:disableAsset(AssetIds.ATTACK_BUTTON)
    self.gameManager.assetManager.textManager:disableText(TextIds.ATTACK_BUTTON_CAPTION)
end
function Board.prototype.disableDiscardButton(self)
    self.gameManager.assetManager:disableAsset(AssetIds.DISCARD_BUTTON)
    self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_CAPTION)
    self.gameManager.assetManager.textManager:disableText(TextIds.DISCARD_BUTTON_COUNTER)
end
function Board.prototype.disableDeselectButton(self)
    self.gameManager.assetManager:disableAsset(AssetIds.DESELECT_BUTTON)
    self.gameManager.assetManager.textManager:disableText(TextIds.DESELECT_BUTTON_CAPTION)
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
            self.gameManager,
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
    if not isEmpty(self.edelCard) then
        local suitImage = love.graphics.newImage(CardAssets:getSuitAssetPath(self.edelCard.suit))
        self.gameManager.assetManager:addAsset(
            AssetIds.EDEL_ICON,
            __TS__New(
                Asset,
                self.gameManager,
                AssetIds.EDEL_ICON,
                suitImage,
                centerX - suitImage:getWidth() / 2,
                5 + boardHeight / 2 - suitImage:getHeight() / 2,
                16,
                16
            )
        )
    end
end
function Board.prototype.buildPowerAndValues(self, characterType, portraitHeight)
    local ____temp_13
    if characterType == CharacterTypes.PLAYER then
        ____temp_13 = self.gameManager.assetManager.textManager:getText(TextIds.PLAYER_PORTRAIT_LEVEL)
    else
        ____temp_13 = self.gameManager.assetManager.textManager:getText(TextIds.ENEMY_PORTRAIT_LEVEL)
    end
    local levelText = ____temp_13
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
            {icon = IconAsset:getPowerIconAsset(self.gameManager, attackPowerAssetId)}
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
            {icon = IconAsset:getValueIconAsset(self.gameManager, valueAssetId)}
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
    self:buildPowerAndValues(
        CharacterTypes.ENEMY,
        self:getPortraitHeight() or 0
    )
end
function Board.prototype.buildPortrait(self, characterType)
    if self.portraitPosition == nil and characterType == CharacterTypes.PLAYER then
        self.portraitPosition = self.cardAssets:getHandYCoordinate(characterType)
    end
    local portraitPosition = self:getPortraitPosition(characterType)
    local portraitBackgroundW = 99
    local portraitBackgroundH = 106
    local portraitBackgroundAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT_BACKGROUND or AssetIds.ENEMY_PORTRAIT_BACKGROUND
    self.gameManager.assetManager:addAsset(
        portraitBackgroundAssetId,
        __TS__New(
            Asset,
            self.gameManager,
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
            self.gameManager,
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
        local perksText = __TS__New(
            FontWithPosition,
            TextIds.PLAYER_PERKS,
            portraitW + 13,
            portraitPosition + 20,
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
                love.graphics.newImage("Assets/Images/PerksButton.png"),
                portraitW + 8,
                portraitPosition + 10,
                39,
                18,
                {
                    onClick = function() return self.gameManager:switchBasedOnGameState(GameStates.PERKS) end,
                    clickSound = self.gameManager.assetManager.buttonClickSound,
                    associatedTexts = {perksText},
                    hoverEffect = {HoverEffects.CHANGE_COLOR},
                    mousePressEffect = {MousePressEffects.DARKEN, MousePressEffects.SHIFT_DOWN}
                }
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
                        self.gameManager,
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
function Board.prototype.buildDeck(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local deckPosition = self.dealer:getDeckPosition(characterType)
    self.gameManager.assetManager:addAsset(
        characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_DECK or AssetIds.ENEMY_DECK,
        __TS__New(
            Asset,
            self.gameManager,
            characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_DECK or AssetIds.ENEMY_DECK,
            love.graphics.newImage("Assets/Images/BaseCardBack.png"),
            deckPosition.x,
            deckPosition.y,
            cardWidth,
            cardHeight,
            {
                onHover = function(____, asset) return character:showDeckOverview(asset) end,
                onUnhover = function() return self.gameManager.assetManager.tooltipManager:hideTooltip() end,
                onClick = function() return character:showDeckContents() end,
                hoverEffect = {HoverEffects.WOBBLE, HoverEffects.SHIMMER},
                mousePressEffect = {MousePressEffects.SHIFT_DOWN},
                clickSound = self.cardAssets.cardClick,
                hoverSound = self.cardAssets.hoverSound
            }
        )
    )
end
function Board.prototype.buildEdelBoard(self)
    if isEmpty(self.edelCard) then
        return
    end
    local boardWidth = 149
    local boardHeight = 23
    local screenW = push:getWidth()
    local boardX = math.floor((screenW - boardWidth) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_BOARD,
        __TS__New(
            Asset,
            self.gameManager,
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
            Card:getSuitName(self.edelCard.suit),
            {size = 16, format = Format.CENTER, font = Fonts.ELOQUENT}
        )
    )
    local suitImage = love.graphics.newImage(CardAssets:getSuitAssetPath(self.edelCard.suit))
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_SUIT_ICON_LEFT,
        __TS__New(
            Asset,
            self.gameManager,
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
            self.gameManager,
            AssetIds.EDEL_SUIT_ICON_RIGHT,
            suitImage,
            boardX + boardWidth - suitImage:getWidth() - 5,
            8,
            16,
            16
        )
    )
end
function Board.prototype.playWinFireSound(self)
    if not self.winFireSound:isPlaying() then
        self.winFireSound:play()
    end
end
function Board.prototype.buildWinFire(self)
    if self.gameManager.assetManager:hasAssets(AssetIds.BASIC_WIN_FIRE) then
        return
    end
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
            self.gameManager,
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
    self:playWinFireSound()
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
    return characterType == CharacterTypes.PLAYER and (self.portraitPosition or self.cardAssets:getHandYCoordinate(characterType)) or 5
end
function Board.prototype.tallyEnemyPowerAndValue(self)
    self:addEnemyPower(self.enemy:getCardPower())
    self:addEnemyValue(self.enemy:getCardValue())
end
return ____exports
