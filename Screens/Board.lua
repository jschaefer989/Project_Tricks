local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local Biomes = ____Enums.Biomes
local CharacterTypes = ____Enums.CharacterTypes
local FontIds = ____Enums.FontIds
local Suits = ____Enums.Suits
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local suit = require("Libraries.suit-master.suit")
local ____CardAssets = require("Assets.CardAssets")
local CardAssets = ____CardAssets.default
local push = require("Libraries.push")
local ____Asset = require("Assets.Asset")
local Asset = ____Asset.default
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local isEmpty = ____Helpers.isEmpty
local ____FontWithPosition = require("Assets.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local Format = ____FontWithPosition.Format
local padding = 20
____exports.default = __TS__Class()
local Board = ____exports.default
Board.name = "Board"
function Board.prototype.____constructor(self, gameManager, enemy)
    self.discardUsed = 0
    self.playerPoints = 0
    self.enemyPoints = 0
    self.trumpSuit = Suits.ACORNS
    self.playerPower = 0
    self.playerValue = 0
    self.enemyPower = 0
    self.enemyValue = 0
    self.showingInitialView = true
    self.letsFightButton = love.graphics.newImage("Assets/Images/LetsFightButton.png")
    self.attackButton = love.graphics.newImage("Assets/Images/AttackButton.png")
    self.discardButton = love.graphics.newImage("Assets/Images/DiscardButton.png")
    self.deselectButton = love.graphics.newImage("Assets/Images/DeselectButton.png")
    self.pointBoard = love.graphics.newImage("Assets/Images/PointBoard.png")
    self.playerPortrait = love.graphics.newImage("Assets/Images/PlayerPortrait.png")
    self.enemyPortrait = love.graphics.newImage("Assets/Images/EnemyPortrait.png")
    self.baseDeck = love.graphics.newImage("Assets/Images/BaseCardBack.png")
    self.gameManager = gameManager
    self.enemy = enemy or __TS__New(Enemy, gameManager)
    self.dealer = __TS__New(Dealer, gameManager)
    self.cardAssets = __TS__New(CardAssets, gameManager)
end
function Board.prototype.load(self, data)
    self.discardUsed = data.discardUsed
    self.playerPoints = data.playerPoints
    self.enemyPoints = data.enemyPoints
    self.trumpSuit = data.trumpSuit
    self.playerPower = data.playerPower
    self.playerValue = data.playerValue
    self.enemyPower = data.enemyPower
    self.enemyValue = data.enemyValue
    local ____data_showingInitialView_0 = data.showingInitialView
    if ____data_showingInitialView_0 == nil then
        ____data_showingInitialView_0 = true
    end
    self.showingInitialView = ____data_showingInitialView_0
    self.enemy = __TS__New(Enemy, self.gameManager)
    self.enemy:load(self.gameManager, data.enemy)
end
function Board.prototype.save(self)
    return {
        discardUsed = self.discardUsed,
        playerPoints = self.playerPoints,
        enemyPoints = self.enemyPoints,
        enemy = self.enemy:save(),
        trumpSuit = self.trumpSuit,
        playerPower = self.playerPower,
        playerValue = self.playerValue,
        enemyPower = self.enemyPower,
        enemyValue = self.enemyValue,
        showingInitialView = self.showingInitialView
    }
end
function Board.prototype.drawBoard(self)
    if not self.gameManager.devMode then
        return
    end
    if self.showingInitialView then
        self:drawInitialView()
    else
        self:drawNormalView()
    end
end
function Board.prototype.drawInitialView(self)
    local btnW = 140
    local btnH = 70
    local lblH = 30
    local padX = 20
    local padY = 20
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
    startY = startY + lblH + padY + btnH + 200
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
    self:renderLetsFightButton(startY + lblH + btnH + padY + 50, btnW, btnH)
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player, {showDiscards = true})
end
function Board.prototype.drawNormalView(self)
    local btnW = 140
    local btnH = 70
    local lblH = 30
    local padX = 20
    local padY = 20
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
    startY = startY + lblH + padY + btnH + 200
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
        startY + lblH + btnH + padY + 50,
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
        startY = math.floor(centerY - totalH / 2 - 200)
    }
end
function Board.prototype.getContentWidth(self)
    local enemyHand = self.enemy.hand
    local playerHand = self.gameManager.player.hand
    local function rowWidth(count)
        if count <= 0 then
            return 100
        end
        return count * 100 + (count - 1) * 20
    end
    return math.max(
        rowWidth(#enemyHand),
        rowWidth(#playerHand),
        300
    )
end
function Board.prototype.getPlayerCashout(self)
    local cashout = self.playerValue - self.enemyValue
    if cashout < 0 then
        cashout = 0
    end
    return cashout
end
function Board.prototype.getEnemyCashout(self)
    local cashout = self.enemyValue - self.playerValue
    if cashout < 0 then
        cashout = 0
    end
    return cashout
end
function Board.prototype.renderWinStatus(self, startX, startY)
    if self.playerPower > self.enemyPower then
        local gap = 30
        local panelW = 180
        local selectedStatsW = self.gameManager.player:anySelectedCards() and 180 or 0
        local selectedStatsGap = self.gameManager.player:anySelectedCards() and gap or 0
        local x = startX - panelW - gap - selectedStatsW - selectedStatsGap
        suit.layout:reset(x, startY, 10, 10)
        suit.Label(
            "You will slay your foe!",
            {align = "left"},
            suit.layout:row(panelW, 40)
        )
        suit.Label(
            "Your cashout: " .. tostring(self:getPlayerCashout()),
            {align = "left"},
            suit.layout:row(panelW, 30)
        )
    end
end
function Board.prototype.renderTrumpSuitLabel(self)
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 300
    local panelX = math.floor(centerX - panelW / 2)
    suit.layout:reset(panelX, 20, 10, 10)
    suit.Label(
        "Trump Suit: " .. self.trumpSuit,
        {align = "center"},
        suit.layout:row(panelW, 40)
    )
end
function Board.prototype.renderPointsDisplay(self)
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 300
    local panelX = math.floor(centerX - panelW / 2)
    suit.layout:reset(panelX, 70, 10, 10)
    suit.Label(
        (((self.enemy.name .. ": ") .. tostring(self.enemyPoints)) .. " | Player: ") .. tostring(self.playerPoints),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
end
function Board.prototype.renderEnemyStats(self, startX, startY)
    local gap = 30
    local panelW = 150
    local x = startX - panelW - gap
    suit.layout:reset(x, startY, 10, 10)
    suit.Label(
        self.enemy.name .. " Hand",
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Value: " .. tostring(self.enemyValue),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Power: " .. tostring(self.enemyPower),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
end
function Board.prototype.renderEnemyDeck(self)
    local enemyDeck = self.enemy.deck
    suit.layout:reset(10, 10, 10, 10)
    suit.Label(
        ((self.enemy.name .. " Deck (") .. tostring(#enemyDeck)) .. " cards)",
        {align = "left"},
        suit.layout:row(150, 30)
    )
    suit.layout:row(0, 5)
    for ____, card in ipairs(enemyDeck) do
        local cardText = (((((card.rank .. " ") .. card.suit) .. " - Val: ") .. tostring(card.value)) .. ", Pow: ") .. tostring(card.power)
        suit.Label(
            cardText,
            {align = "left"},
            suit.layout:row(150, 25)
        )
    end
end
function Board.prototype.renderPlayerSelectedStats(self, startX, startY, contentW, btnW)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    local gap = 30
    local panelW = 180
    local x = startX - panelW - gap
    suit.layout:reset(x, startY, 10, 10)
    suit.Label(
        "Selected Hand",
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Value: " .. tostring(self.playerValue),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Power: " .. tostring(self.playerPower),
        {align = "center"},
        suit.layout:row(panelW, 30)
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
    local buttonW = 200
    local buttonX = math.floor(screenW / 2 - buttonW / 2)
    suit.layout:reset(buttonX, startY, 20, 20)
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
    local gap = 20
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
    local panelX = screenW - 170
    local panelY = screenH - 240
    suit.layout:reset(panelX, panelY, 10, 10)
    suit.Label(
        (("Discards Remaining: " .. tostring(self.gameManager.player.discards - self.discardUsed)) .. "/") .. tostring(self.gameManager.player.discards),
        {align = "center"},
        suit.layout:row(150, 30)
    )
end
function Board.prototype.handleStartFight(self)
    self.showingInitialView = false
    self.gameManager.assetManager:hideAsset(AssetIds.LETS_FIGHT_BUTTON)
    self.dealer:startGame()
    self:buildPrimaryButtons()
    self:buildPointBoard()
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
        self:addPlayerPoints(self:getPlayerCashout())
    else
        self:addEnemyPoints(self:getEnemyCashout())
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
    local text = self.gameManager.assetManager.fontManager:getText(FontIds.POINTS_PLAYER)
    if not isEmpty(text) then
        text.text = (self.gameManager.player.name .. ": ") .. tostring(self.playerPoints)
    end
end
function Board.prototype.addEnemyPoints(self, points)
    self.enemyPoints = self.enemyPoints + points
    local text = self.gameManager.assetManager.fontManager:getText(FontIds.POINTS_ENEMY)
    if not isEmpty(text) then
        text.text = (self.enemy.name .. ": ") .. tostring(self.enemyPoints)
    end
end
function Board.prototype.handleDiscard(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    self.gameManager.player:discard()
    self.discardUsed = self.discardUsed + 1
    local ____opt_5 = self.gameManager.board
    if ____opt_5 ~= nil then
        ____opt_5.dealer:dealCards(CharacterTypes.PLAYER)
    end
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
        self.gameManager:switchToWinScreen()
    elseif winner == CharacterTypes.ENEMY then
        self.gameManager:switchToLoseScreen()
    end
end
function Board.prototype.clearStats(self)
    self.playerPower = 0
    self.playerValue = 0
    self.enemyPower = 0
    self.enemyValue = 0
end
function Board.prototype.buildAssets(self)
    self:buildBackground(Biomes.GRASS)
    self:buildCardAssets()
    self:buildLetsFightButton()
    self:buildPlayerPortrait()
    self:buildEnemyPortrait()
    self:buildPlayerDeck()
    self:buildEnemyDeck()
end
function Board.prototype.buildCardAssets(self)
    local playerCardPosition = self.cardAssets:determineCardStartingPosition(CharacterTypes.PLAYER)
    do
        local i = 0
        while i < #self.gameManager.player.hand do
            local card = self.gameManager.player.hand[i + 1]
            local x = playerCardPosition.x + i * (self.cardAssets.baseW + padding)
            self.cardAssets:addAsset(card, x, playerCardPosition.y)
            i = i + 1
        end
    end
    local enemyCardPosition = self.cardAssets:determineCardStartingPosition(CharacterTypes.ENEMY)
    do
        local i = 0
        while i < #self.enemy.hand do
            local card = self.enemy.hand[i + 1]
            local x = enemyCardPosition.x + i * (self.cardAssets.baseW + padding)
            self.cardAssets:addAsset(card, x, enemyCardPosition.y)
            i = i + 1
        end
    end
end
function Board.prototype.buildLetsFightButton(self)
    local cardY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER)
    local buttonHeight = self.letsFightButton:getHeight()
    local buttonWidth = self.letsFightButton:getWidth()
    local screenW = push:getWidth()
    local buttonX = math.floor((screenW - buttonWidth) / 2)
    local buttonY = cardY - buttonHeight - padding
    self.gameManager.assetManager:addAsset(
        AssetIds.LETS_FIGHT_BUTTON,
        __TS__New(
            Asset,
            AssetIds.LETS_FIGHT_BUTTON,
            self.letsFightButton,
            buttonX,
            buttonY,
            function() return self:handleStartFight() end
        )
    )
end
function Board.prototype.buildPrimaryButtons(self)
    local gap = 20
    local btnW = self.attackButton:getWidth()
    local totalW = btnW * 3 + gap * 2
    local buttonY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER) + self.cardAssets.baseH + padding
    local buttonX = math.floor((push:getWidth() - totalW) / 2)
    self:buildAttackButton(buttonX, buttonY, btnW)
    local discardX = self:buildDiscardButton(buttonX, buttonY, btnW, gap)
    self:buildDeselectButton(discardX, buttonY, btnW, gap)
end
function Board.prototype.buildAttackButton(self, buttonX, buttonY, btnW)
    self.gameManager.assetManager:addAsset(
        AssetIds.ATTACK_BUTTON,
        __TS__New(
            Asset,
            AssetIds.ATTACK_BUTTON,
            self.attackButton,
            buttonX,
            buttonY,
            function() return self:handleAttack() end
        )
    )
    local centerX = buttonX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
    self.gameManager.assetManager.fontManager:addText(
        FontIds.ATTACK_BUTTON_CAPTION,
        __TS__New(
            FontWithPosition,
            centerX,
            centerY,
            "Attack",
            {size = 28, format = Format.CENTER}
        )
    )
end
function Board.prototype.buildDiscardButton(self, buttonX, buttonY, btnW, gap)
    local discardX = buttonX + btnW + gap
    self.gameManager.assetManager:addAsset(
        AssetIds.DISCARD_BUTTON,
        __TS__New(
            Asset,
            AssetIds.DISCARD_BUTTON,
            self.discardButton,
            discardX,
            buttonY,
            function() return self:handleDiscard() end
        )
    )
    local centerX = discardX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
    self.gameManager.assetManager.fontManager:addText(
        FontIds.DISCARD_BUTTON_CAPTION,
        __TS__New(
            FontWithPosition,
            centerX,
            centerY,
            "Discard",
            {size = 28, format = Format.CENTER}
        )
    )
    return discardX
end
function Board.prototype.buildDeselectButton(self, discardX, buttonY, btnW, gap)
    local deselectX = discardX + btnW + gap
    self.gameManager.assetManager:addAsset(
        AssetIds.DESELECT_BUTTON,
        __TS__New(
            Asset,
            AssetIds.DESELECT_BUTTON,
            self.deselectButton,
            deselectX,
            buttonY,
            function() return self.gameManager.player:unselectCards() end
        )
    )
    local centerX = deselectX + btnW / 2
    local centerY = buttonY + self.attackButton:getHeight() / 2
    self.gameManager.assetManager.fontManager:addText(
        FontIds.DESELECT_BUTTON_CAPTION,
        __TS__New(
            FontWithPosition,
            centerX,
            centerY,
            "Deselect",
            {size = 28, format = Format.CENTER}
        )
    )
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
            10
        )
    )
    local centerX = screenW / 2
    local textY = 40
    local playerText = (self.gameManager.player.name .. ": ") .. tostring(self.playerPoints)
    local enemyText = (self.enemy.name .. ": ") .. tostring(self.enemyPoints)
    self.gameManager.assetManager.fontManager:addText(
        FontIds.POINTS_PLAYER,
        __TS__New(
            FontWithPosition,
            centerX - boardWidth / 2 + 10,
            textY,
            playerText,
            {size = 20}
        )
    )
    self.gameManager.assetManager.fontManager:addText(
        FontIds.POINTS_ENEMY,
        __TS__New(
            FontWithPosition,
            centerX + boardWidth / 2 - 10,
            textY,
            enemyText,
            {size = 20, format = Format.RIGHT}
        )
    )
end
function Board.prototype.buildPlayerPortrait(self)
    self.gameManager.assetManager:addAsset(
        AssetIds.PLAYER_PORTRAIT,
        __TS__New(
            Asset,
            AssetIds.PLAYER_PORTRAIT,
            self.playerPortrait,
            5,
            5
        )
    )
end
function Board.prototype.buildEnemyPortrait(self)
    self.gameManager.assetManager:addAsset(
        AssetIds.ENEMY_PORTRAIT,
        __TS__New(
            Asset,
            AssetIds.ENEMY_PORTRAIT,
            self.enemyPortrait,
            push:getWidth() - self.enemyPortrait:getWidth() - 5,
            5
        )
    )
end
function Board.prototype.buildPlayerDeck(self)
    local playerCardY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER)
    self.gameManager.assetManager:addAsset(
        AssetIds.PLAYER_DECK,
        __TS__New(
            Asset,
            AssetIds.PLAYER_DECK,
            self.baseDeck,
            5,
            playerCardY
        )
    )
end
function Board.prototype.buildEnemyDeck(self)
    local playerCardY = self.cardAssets:getCardPosition(CharacterTypes.PLAYER)
    self.gameManager.assetManager:addAsset(
        AssetIds.ENEMY_DECK,
        __TS__New(
            Asset,
            AssetIds.ENEMY_DECK,
            self.baseDeck,
            push:getWidth() - self.baseDeck:getWidth() - 5,
            playerCardY
        )
    )
end
function Board.prototype.buildBackground(self, biome)
    local backgroundImage = self:getBackgroundImageForBiome(biome)
    self.gameManager.assetManager:addAsset(
        AssetIds.GRASS_BACKGROUND,
        __TS__New(
            Asset,
            AssetIds.GRASS_BACKGROUND,
            backgroundImage,
            0,
            0
        )
    )
end
function Board.prototype.getBackgroundImageForBiome(self, biome)
    repeat
        local ____switch86 = biome
        local ____cond86 = ____switch86 == Biomes.GRASS
        if ____cond86 then
            return love.graphics.newImage("Assets/Images/GrassBackground.png")
        end
        do
            exhaustiveGuard(biome)
        end
    until true
end
return ____exports
