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
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local suit = require("Libraries.suit-master.suit")
local ____CardAssets = require("Assets.CardAssets")
local CardAssets = ____CardAssets.default
local padding = ____CardAssets.padding
local push = require("Libraries.push")
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Format = ____FontWithPosition.Format
local OutlineThickness = ____FontWithPosition.OutlineThickness
local ____Card = require("Cards.Card")
local Card = ____Card.default
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
    self.letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png")
    self.attackButton = love.graphics.newImage("Assets/Images/AttackButton.png")
    self.discardButton = love.graphics.newImage("Assets/Images/DiscardButton.png")
    self.deselectButton = love.graphics.newImage("Assets/Images/DeselectButton.png")
    self.pointBoard = love.graphics.newImage("Assets/Images/PointBoard.png")
    self.edelBoard = love.graphics.newImage("Assets/Images/EdelBoard.png")
    self.portraitBackground = love.graphics.newImage("Assets/Images/PortraitBackground.png")
    self.portrait = love.graphics.newImage("Assets/Images/Portrait.png")
    self.baseDeck = love.graphics.newImage("Assets/Images/BaseCardBack.png")
    self.perksButton = love.graphics.newImage("Assets/Images/PerksButton.png")
    self.markIcon = love.graphics.newImage("Assets/Images/Mark.png")
    self.attackPowerIcon = love.graphics.newImage("Assets/Images/AttackPower.png")
    self.valueIcon = love.graphics.newImage("Assets/Images/Value.png")
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
function Board.prototype.drawBoard(self)
    if not self.gameManager.devMode then
        return
    end
    if self.showingEdelView then
        self:drawInitialView()
    else
        self:drawNormalView()
    end
end
function Board.prototype.drawInitialView(self)
    local btnW = 70
    local btnH = 35
    local lblH = 15
    local padX = 10
    local padY = 10
    local contentW = self:getContentWidth()
    local coords = self:getStartingCoordinates(contentW, btnH, lblH, padY)
    local startX = coords.startX
    local startY = coords.startY
    self:renderTrumpSuitLabel()
    self:renderEnemyDeck()
    self:renderEnemyRow(
        startX,
        startY,
        contentW,
        btnW,
        btnH,
        lblH,
        padX,
        padY
    )
    startY = startY + lblH + padY + btnH + 100
    self:renderPlayerRowInitial(
        startX,
        startY,
        contentW,
        btnW,
        btnH,
        lblH,
        padX,
        padY
    )
    self:renderLetsFightButton(startY + lblH + btnH + padY + 12, btnW, btnH)
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player, {showDiscards = true})
end
function Board.prototype.drawNormalView(self)
    local btnW = 70
    local btnH = 35
    local lblH = 15
    local padX = 10
    local padY = 10
    local contentW = self:getContentWidth()
    local coords = self:getStartingCoordinates(contentW, btnH, lblH, padY)
    local startX = coords.startX
    local startY = coords.startY
    self:renderPointsDisplay()
    self:renderEnemyDeck()
    self:renderEnemyStats(startX, startY)
    self:renderEnemyRow(
        startX,
        startY,
        contentW,
        btnW,
        btnH,
        lblH,
        padX,
        padY
    )
    startY = startY + lblH + padY + btnH + 100
    self:renderPlayerRow(
        startX,
        startY,
        contentW,
        btnW,
        btnH,
        lblH,
        padX,
        padY
    )
    self:renderAttackButton(
        startY + lblH + btnH + padY + 25,
        btnW,
        btnH,
        padX,
        padY
    )
    self:renderPlayerSelectedStats(startX, startY, contentW, btnW)
    self:renderWinStatus(startX, startY)
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player, {showDiscards = true})
    self:renderDiscardCounter()
end
function Board.prototype.getStartingCoordinates(self, contentW, btnH, groupH, padY)
    local totalH = groupH * 2 + padY + btnH
    local centerX = love.graphics.getWidth() / 2
    local centerY = love.graphics.getHeight() / 2
    return {
        startX = math.floor(centerX - contentW / 2),
        startY = math.floor(centerY - totalH / 2 - 100)
    }
end
function Board.prototype.getContentWidth(self)
    local enemyHand = self.enemy.hand
    local playerHand = self.gameManager.player.hand
    local function rowWidth(count)
        if count <= 0 then
            return 25
        end
        return count * 25 + (count - 1) * 5
    end
    return math.max(
        rowWidth(#enemyHand),
        rowWidth(#playerHand),
        75
    )
end
function Board.prototype.getPlayerWinnings(self)
    local winnings = self.playerValue - self.enemyValue
    if winnings < 0 then
        winnings = 0
    end
    return winnings
end
function Board.prototype.getEnemyWinnings(self)
    local winnings = self.enemyValue - self.playerValue
    if winnings < 0 then
        winnings = 0
    end
    return winnings
end
function Board.prototype.renderWinStatus(self, startX, startY)
    if self.playerPower > self.enemyPower then
        local gap = 15
        local panelW = 90
        local selectedStatsW = self.gameManager.player:anySelectedCards() and 90 or 0
        local selectedStatsGap = self.gameManager.player:anySelectedCards() and gap or 0
        local x = startX - panelW - gap - selectedStatsW - selectedStatsGap
        suit.layout:reset(x, startY, 5, 5)
        suit.Label(
            "You will slay your foe!",
            {align = "left"},
            suit.layout:row(panelW, 20)
        )
        suit.Label(
            "Your cashout: " .. tostring(self:getPlayerWinnings()),
            {align = "left"},
            suit.layout:row(panelW, 15)
        )
    end
end
function Board.prototype.renderTrumpSuitLabel(self)
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 150
    local panelX = math.floor(centerX - panelW / 2)
    suit.layout:reset(panelX, 10, 5, 5)
    suit.Label(
        "Trump Suit: " .. self.edelSuit,
        {align = "center"},
        suit.layout:row(panelW, 20)
    )
end
function Board.prototype.renderPointsDisplay(self)
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 150
    local panelX = math.floor(centerX - panelW / 2)
    suit.layout:reset(panelX, 35, 5, 5)
    suit.Label(
        (((self.enemy.name .. ": ") .. tostring(self.enemyPoints)) .. " | Player: ") .. tostring(self.playerPoints),
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
end
function Board.prototype.renderEnemyStats(self, startX, startY)
    local gap = 15
    local panelW = 75
    local x = startX - panelW - gap
    suit.layout:reset(x, startY, 5, 5)
    suit.Label(
        self.enemy.name .. " Hand",
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
    suit.Label(
        "Value: " .. tostring(self.enemyValue),
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
    suit.Label(
        "Power: " .. tostring(self.enemyPower),
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
end
function Board.prototype.renderEnemyDeck(self)
    local enemyDeck = self.enemy.deck
    suit.layout:reset(5, 5, 5, 5)
    suit.Label(
        ((self.enemy.name .. " Deck (") .. tostring(#enemyDeck)) .. " cards)",
        {align = "left"},
        suit.layout:row(75, 15)
    )
    suit.layout:row(0, 2)
    for ____, card in ipairs(enemyDeck) do
        local cardText = (((((card.rank .. " ") .. card.suit) .. " - Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)
        suit.Label(
            cardText,
            {align = "left"},
            suit.layout:row(75, 12)
        )
    end
end
function Board.prototype.renderPlayerSelectedStats(self, startX, startY, contentW, btnW)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    local gap = 15
    local panelW = 90
    local x = startX - panelW - gap
    suit.layout:reset(x, startY, 5, 5)
    suit.Label(
        "Selected Hand",
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
    suit.Label(
        "Value: " .. tostring(self.playerValue),
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
    suit.Label(
        "Power: " .. tostring(self.playerPower),
        {align = "center"},
        suit.layout:row(panelW, 15)
    )
end
function Board.prototype.renderEnemyRow(self, startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    local enemyHand = self.enemy.hand
    suit.layout:reset(startX, startY, padX, padY)
    suit.Label(
        "Enemy hand: " .. tostring(#enemyHand),
        {align = "left"},
        suit.layout:row(contentW, lblH)
    )
    suit.layout:row(0, 0)
    for ____, card in ipairs(enemyHand) do
        local labelText = ((((((card.rank .. " ") .. card.suit) .. " (Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)) .. ")"
        suit.Label(
            labelText,
            {align = "left"},
            suit.layout:col(btnW, btnH)
        )
    end
end
function Board.prototype.renderPlayerRowInitial(self, startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    local playerHand = self.gameManager.player.hand
    suit.layout:reset(startX, startY, padX, padY)
    suit.Label(
        "Your hand: " .. tostring(#playerHand),
        {align = "left"},
        suit.layout:row(contentW, lblH)
    )
    suit.layout:row(0, 0)
    for ____, card in ipairs(playerHand) do
        local cardText = ((((((card.rank .. " ") .. card.suit) .. " (Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)) .. ")"
        suit.Button(
            cardText,
            {},
            suit.layout:col(btnW, btnH)
        )
    end
end
function Board.prototype.renderPlayerRow(self, startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    local playerHand = self.gameManager.player.hand
    suit.layout:reset(startX, startY, padX, padY)
    suit.Label(
        "Your hand: " .. tostring(#playerHand),
        {align = "left"},
        suit.layout:row(contentW, lblH)
    )
    suit.layout:row(0, 0)
    for ____, card in ipairs(playerHand) do
        Draw:card(card, btnW, btnH, {multiSelect = true})
    end
end
function Board.prototype.renderLetsFightButton(self, startY, btnW, btnH)
    local screenW = love.graphics.getWidth()
    local buttonW = 100
    local buttonX = math.floor(screenW / 2 - buttonW / 2)
    suit.layout:reset(buttonX, startY, 10, 10)
    local hit = suit.Button(
        "Let's Fight!",
        {},
        suit.layout:row(buttonW, btnH)
    ).hit
    if hit then
        self:handleStartFight()
    end
end
function Board.prototype.renderAttackButton(self, startY, btnW, btnH, padX, padY)
    local gap = 10
    local totalW = btnW * 3 + gap * 2
    suit.layout:reset(
        love.graphics.getWidth() / 2 - totalW / 2,
        startY,
        padX,
        padY
    )
    local attackHit = suit.Button(
        "Attack",
        {},
        suit.layout:col(btnW, btnH)
    ).hit
    local discardEnabled = self.discardUsed < self.gameManager.player.discards
    local discardLabel = discardEnabled and "Discard" or "Discard (used)"
    local discardHit = suit.Button(
        discardLabel,
        {},
        suit.layout:col(btnW, btnH)
    ).hit
    local deselectHit = suit.Button(
        "Deselect All",
        {},
        suit.layout:col(btnW, btnH)
    ).hit
    if attackHit then
        self:handleAttack()
    end
    if discardHit and discardEnabled then
        self:handleDiscard()
    end
    if deselectHit then
        self.gameManager.player:unselectCards()
    end
end
function Board.prototype.renderDiscardCounter(self)
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelX = screenW - 85
    local panelY = screenH - 120
    suit.layout:reset(panelX, panelY, 5, 5)
    suit.Label(
        (("Discards Remaining: " .. tostring(self.gameManager.player.discards - self.discardUsed)) .. "/") .. tostring(self.gameManager.player.discards),
        {align = "center"},
        suit.layout:row(75, 15)
    )
end
function Board.prototype.handleStartFight(self)
    self.showingEdelView = false
    self.gameManager.assetManager:hideAsset(AssetIds.LETS_FIGHT_BUTTON)
    self.gameManager.assetManager.textManager:hideText(TextIds.LETS_FIGHT_BUTTON_CAPTION)
    self.dealer:startGame()
    self:buildFightAssets()
    self.gameManager.assetManager.textManager:hideText(TextIds.EDEL_LABEL)
    self.gameManager.assetManager:hideAsset(AssetIds.EDEL_BOARD)
    self.gameManager.assetManager:hideAsset(AssetIds.EDEL_SUIT_ICON_LEFT)
    self.gameManager.assetManager:hideAsset(AssetIds.EDEL_SUIT_ICON_RIGHT)
end
function Board.prototype.buildFightAssets(self)
    self:buildPrimaryButtons()
    self:buildPointBoard()
    self:buildPowerAndValues(CharacterTypes.PLAYER)
    self:buildPowerAndValues(CharacterTypes.ENEMY)
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
        self:addPlayerPoints(self:getPlayerWinnings())
    else
        self:addEnemyPoints(self:getEnemyWinnings())
    end
    self:clearStats()
    self.gameManager.player:removeSelectedCardsFromHand()
    local ____opt_1 = self.gameManager.board
    if ____opt_1 ~= nil then
        ____opt_1.dealer:dealCards(CharacterTypes.PLAYER)
    end
    self.enemy:removeAllCardsFromHand()
    local ____opt_3 = self.gameManager.board
    if ____opt_3 ~= nil then
        ____opt_3.dealer:dealCards(CharacterTypes.ENEMY)
    end
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
    local ____opt_5 = self.gameManager.board
    if ____opt_5 ~= nil then
        ____opt_5.dealer:dealCards(CharacterTypes.PLAYER)
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
    self:addPlayerPower(-self.playerPower)
    self:addPlayerValue(-self.playerValue)
    self:addEnemyPower(-self.enemyPower)
    self:addEnemyValue(-self.enemyValue)
end
function Board.prototype.addPlayerPower(self, power)
    self.playerPower = self.playerPower + power
    self.gameManager.assetManager.textManager:updateText(
        TextIds.PLAYER_POWER,
        "Power: " .. tostring(self.playerPower)
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
        "Value: " .. tostring(self.playerValue)
    )
    self.gameManager.assetManager.textManager:updateText(
        TextIds.WINNINGS,
        "Winnings: " .. tostring(self:getPlayerWinnings())
    )
end
function Board.prototype.addEnemyPower(self, power)
    self.enemyPower = self.enemyPower + power
    self.gameManager.assetManager.textManager:updateText(
        TextIds.ENEMY_POWER,
        "Power: " .. tostring(self.enemyPower)
    )
end
function Board.prototype.addEnemyValue(self, value)
    self.enemyValue = self.enemyValue + value
    self.gameManager.assetManager.textManager:updateText(
        TextIds.ENEMY_VALUE,
        "Value: " .. tostring(self.enemyValue)
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
            local x = playerCardPosition.x + i * (self.cardAssets.baseW + padding)
            self.cardAssets:addAsset(card, x, playerCardPosition.y, not self.showingEdelView)
            i = i + 1
        end
    end
    local enemyCardPosition = self.cardAssets:determineCardStartingPosition(CharacterTypes.ENEMY)
    do
        local i = 0
        while i < #self.enemy.hand do
            local card = self.enemy.hand[i + 1]
            local x = enemyCardPosition.x + i * (self.cardAssets.baseW + padding)
            self.cardAssets:addAsset(card, x, enemyCardPosition.y, false)
            i = i + 1
        end
    end
end
function Board.prototype.buildLetsFightButton(self)
    local buttonHeight = self.letsFightButton:getHeight()
    local buttonWidth = self.letsFightButton:getWidth()
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local buttonX = math.floor((screenW - buttonWidth) / 2)
    local buttonY = math.floor((screenH - buttonHeight) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.LETS_FIGHT_BUTTON,
        __TS__New(
            Asset,
            AssetIds.LETS_FIGHT_BUTTON,
            self.letsFightButton,
            buttonX,
            buttonY + 85,
            {onClick = function() return self:handleStartFight() end}
        )
    )
    local centerX = buttonX + buttonWidth / 2
    local centerY = buttonY + buttonHeight / 2
    self.gameManager.assetManager.textManager:addText(
        TextIds.LETS_FIGHT_BUTTON_CAPTION,
        __TS__New(
            FontWithPosition,
            TextIds.LETS_FIGHT_BUTTON_CAPTION,
            centerX,
            centerY,
            "Let's Fight!",
            {size = 27, format = Format.CENTER, outlineThickness = OutlineThickness.THICK}
        )
    )
end
function Board.prototype.buildPrimaryButtons(self)
    local gap = 10
    local btnW = self.attackButton:getWidth()
    local totalW = btnW * 3 + gap * 2
    local buttonY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER) + self.cardAssets.baseH + gap
    local buttonX = math.floor((push:getWidth() - totalW) / 2)
    self:buildAttackButton(buttonX, buttonY, btnW)
    local discardX = self:buildDiscardButton(buttonX, buttonY, btnW, gap)
    self:buildDeselectButton(discardX, buttonY, btnW, gap)
    self:updatePrimaryButtonStates()
end
function Board.prototype.buildAttackButton(self, buttonX, buttonY, btnW)
    local centerX = buttonX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
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
            self.attackButton,
            buttonX,
            buttonY,
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
function Board.prototype.buildDiscardButton(self, buttonX, buttonY, btnW, gap)
    local discardX = buttonX + btnW + gap
    local centerX = discardX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
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
            self.discardButton,
            discardX,
            buttonY,
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
function Board.prototype.buildDeselectButton(self, discardX, buttonY, btnW, gap)
    local deselectX = discardX + btnW + gap
    local centerX = deselectX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
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
            self.deselectButton,
            deselectX,
            buttonY,
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
    local boardWidth = self.pointBoard:getWidth()
    local screenW = push:getWidth()
    local buttonX = math.floor((screenW - boardWidth) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.POINT_DISPLAY,
        __TS__New(
            Asset,
            AssetIds.POINT_DISPLAY,
            self.pointBoard,
            buttonX,
            5
        )
    )
    local centerX = screenW / 2
    local textY = self.pointBoard:getHeight() / 2 + 5
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
function Board.prototype.buildPowerAndValues(self, characterType)
    local portraitHeight = self.portrait:getHeight()
    local portraitAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT or AssetIds.ENEMY_PORTRAIT
    local portraitAsset = self.gameManager.assetManager:getAsset(portraitAssetId, portraitAssetId)
    if isEmpty(portraitAsset) then
        return
    end
    local powerId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_POWER or TextIds.ENEMY_POWER
    local powerValue = characterType == CharacterTypes.PLAYER and self.playerPower or self.enemyPower
    self.gameManager.assetManager.textManager:addText(
        powerId,
        __TS__New(
            FontWithPosition,
            powerId,
            15,
            portraitHeight + portraitAsset.y + 18,
            "Power: " .. tostring(powerValue),
            {size = 9, icon = self.attackPowerIcon}
        )
    )
    local valueId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_VALUE or TextIds.ENEMY_VALUE
    local valueValue = characterType == CharacterTypes.PLAYER and self.playerValue or self.enemyValue
    self.gameManager.assetManager.textManager:addText(
        valueId,
        __TS__New(
            FontWithPosition,
            valueId,
            15,
            portraitHeight + portraitAsset.y + 28,
            "Value: " .. tostring(valueValue),
            {size = 9, icon = self.valueIcon}
        )
    )
end
function Board.prototype.buildPlayerPortrait(self)
    self:buildPortrait(CharacterTypes.PLAYER)
end
function Board.prototype.buildEnemyPortrait(self)
    self:buildPortrait(CharacterTypes.ENEMY)
end
function Board.prototype.buildPortrait(self, characterType)
    if self.portraitPosition == nil and characterType == CharacterTypes.PLAYER then
        self.portraitPosition = self.cardAssets:getCardPosition(characterType)
    end
    local portraitPosition = self:getPortraitPosition(characterType)
    local portraitBackgroundAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT_BACKGROUND or AssetIds.ENEMY_PORTRAIT_BACKGROUND
    self.gameManager.assetManager:addAsset(
        portraitBackgroundAssetId,
        __TS__New(
            Asset,
            portraitBackgroundAssetId,
            self.portraitBackground,
            5,
            portraitPosition
        )
    )
    local portraitAssetId = characterType == CharacterTypes.PLAYER and AssetIds.PLAYER_PORTRAIT or AssetIds.ENEMY_PORTRAIT
    self.gameManager.assetManager:addAsset(
        portraitAssetId,
        __TS__New(
            Asset,
            portraitAssetId,
            self.portrait,
            5,
            portraitPosition
        )
    )
    local portraitWidth = self.portrait:getWidth() - 12
    local portraitHeight = self.portrait:getHeight() - 12
    local portraitBackgroundWidth = self.portraitBackground:getWidth() - 28
    local portraitNameId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_PORTRAIT_NAME or TextIds.ENEMY_PORTRAIT_NAME
    self.gameManager.assetManager.textManager:addText(
        portraitNameId,
        __TS__New(
            FontWithPosition,
            portraitNameId,
            10,
            portraitHeight + portraitPosition + 8,
            characterType == CharacterTypes.PLAYER and self.gameManager.player.name or self.enemy.name,
            {size = 9, outlineThickness = OutlineThickness.THICK}
        )
    )
    local portraitLevelId = characterType == CharacterTypes.PLAYER and TextIds.PLAYER_PORTRAIT_LEVEL or TextIds.ENEMY_PORTRAIT_LEVEL
    self.gameManager.assetManager.textManager:addText(
        portraitLevelId,
        __TS__New(
            FontWithPosition,
            portraitLevelId,
            10,
            portraitHeight + portraitPosition + 20,
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
                portraitBackgroundWidth,
                portraitHeight + portraitPosition + 20,
                tostring(self.gameManager.player.experience) .. " xp",
                {size = 9, format = Format.RIGHT}
            )
        )
        self.gameManager.assetManager:addAsset(
            AssetIds.PERKS_BUTTON,
            __TS__New(
                Asset,
                AssetIds.PERKS_BUTTON,
                self.perksButton,
                portraitWidth + 10,
                portraitPosition + 10,
                {onClick = function() return self.gameManager:switchBasedOnGameState(GameStates.PERKS) end}
            )
        )
        self.gameManager.assetManager.textManager:addText(
            TextIds.PLAYER_PERKS,
            __TS__New(
                FontWithPosition,
                TextIds.PLAYER_PERKS,
                portraitWidth + 15,
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
                portraitBackgroundWidth,
                portraitHeight + portraitPosition + 8,
                tostring(self.gameManager.player.money),
                {size = 9, icon = self.markIcon, format = Format.RIGHT}
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
            self.baseDeck,
            push:getWidth() - self.baseDeck:getWidth() - 5,
            portraitPosition
        )
    )
end
function Board.prototype.buildEnemyDeck(self)
    self.gameManager.assetManager:addAsset(
        AssetIds.ENEMY_DECK,
        __TS__New(
            Asset,
            AssetIds.ENEMY_DECK,
            self.baseDeck,
            push:getWidth() - self.baseDeck:getWidth() - 5,
            5
        )
    )
end
function Board.prototype.buildEdelBoard(self)
    local boardWidth = self.edelBoard:getWidth()
    local screenW = push:getWidth()
    local boardX = math.floor((screenW - boardWidth) / 2)
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_BOARD,
        __TS__New(
            Asset,
            AssetIds.EDEL_BOARD,
            self.edelBoard,
            boardX,
            5
        )
    )
    local centerX = screenW / 2
    self.gameManager.assetManager.textManager:addText(
        TextIds.EDEL_LABEL,
        __TS__New(
            FontWithPosition,
            TextIds.EDEL_LABEL,
            centerX,
            20,
            Card:getSuitName(self.edelSuit),
            {size = 16, format = Format.CENTER, filepath = "Assets/Fonts/Bitmgothic.ttf"}
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
            10
        )
    )
    self.gameManager.assetManager:addAsset(
        AssetIds.EDEL_SUIT_ICON_RIGHT,
        __TS__New(
            Asset,
            AssetIds.EDEL_SUIT_ICON_RIGHT,
            suitImage,
            boardX + boardWidth - suitImage:getWidth() - 5,
            10
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
            0
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
    local portraitWidth = self.portrait:getWidth()
    local portraitHeight = self.portrait:getHeight()
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
            centerY - fireSprite:getHeight() / 4
        )
    )
    self.gameManager.assetManager.textManager:addText(
        TextIds.WIN_FIRE_TEXT,
        __TS__New(
            FontWithPosition,
            TextIds.WIN_FIRE_TEXT,
            portraitCenterX * 2,
            centerY + 10,
            "You are\ndominating!",
            {size = 16, format = Format.CENTER}
        )
    )
    local winnings = self:getPlayerWinnings()
    if winnings <= 0 then
        self.gameManager.assetManager.textManager:addText(
            TextIds.WINNINGS,
            __TS__New(
                FontWithPosition,
                TextIds.WINNINGS,
                portraitCenterX * 2,
                centerY + 50,
                "But you'll get no winnings...",
                {size = 10, format = Format.CENTER}
            )
        )
    else
        self.gameManager.assetManager.textManager:addText(
            TextIds.WINNINGS,
            __TS__New(
                FontWithPosition,
                TextIds.WINNINGS,
                portraitCenterX * 2,
                centerY + 50,
                "Winnings: " .. tostring(winnings),
                {size = 10, format = Format.CENTER}
            )
        )
    end
end
function Board.prototype.removeWinFire(self)
    self.gameManager.assetManager:hideAsset(AssetIds.BASIC_WIN_FIRE)
    self.gameManager.assetManager.textManager:hideText(TextIds.WIN_FIRE_TEXT)
    self.gameManager.assetManager.textManager:hideText(TextIds.WINNINGS)
end
function Board.prototype.getWinFireSprite(self)
    return love.graphics.newImage("Assets/Images/BasicWinFire.png")
end
function Board.prototype.getPortraitPosition(self, characterType)
    return characterType == CharacterTypes.PLAYER and (self.portraitPosition or self.cardAssets:getCardPosition(characterType)) or 5
end
return ____exports
