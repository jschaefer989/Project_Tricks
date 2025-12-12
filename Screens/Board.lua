local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local CharacterTypes = ____Enums.CharacterTypes
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Enemy = require("Enemies.Enemy")
local Enemy = ____Enemy.default
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local Board = ____exports.default
Board.name = "Board"
function Board.prototype.____constructor(self, gameManager, enemy)
    self.gameManager = gameManager
    self.discardUsed = 0
    self.enemy = enemy or __TS__New(Enemy)
    self.dealer = __TS__New(Dealer, gameManager)
    self.playerPoints = 0
    self.enemyPoints = 0
end
function Board.prototype.load(self, data)
    self.discardUsed = data.discardUsed or 0
    self.playerPoints = data.playerPoints or 0
    self.enemyPoints = data.enemyPoints or 0
    self.enemy = __TS__New(Enemy)
    self.enemy:load(data.enemy)
end
function Board.prototype.save(self)
    return {
        discardUsed = self.discardUsed,
        playerPoints = self.playerPoints,
        enemyPoints = self.enemyPoints,
        enemy = self.enemy:save()
    }
end
function Board.prototype.drawBoard(self)
    local btnW = 140
    local btnH = 70
    local lblH = 30
    local padX = 20
    local padY = 20
    local contentW = self:getContentWidth()
    local coords = self:getStartingCoordinates(contentW, btnH, lblH, padY)
    local startX = coords.startX
    local startY = coords.startY
    self:renderWinStatus()
    self:renderPointsDisplay()
    self:renderEnemyStatsPanel(padX, padY)
    self:renderEnemyDeckVisualization()
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
    self:renderPlayButton(
        startY + lblH + btnH + padY + 50,
        btnW,
        btnH,
        padX,
        padY
    )
    self:renderPlayerSelectedStatsPanel()
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
    local selectedValue = self.gameManager.player:getCardValue()
    local enemyValue = self.enemy:getCardValue()
    local cashout = selectedValue - enemyValue
    if cashout < 0 then
        cashout = 0
    end
    return cashout
end
function Board.prototype.getEnemyCashout(self)
    local selectedValue = self.gameManager.player:getCardValue()
    local enemyValue = self.enemy:getCardValue()
    local cashout = enemyValue - selectedValue
    if cashout < 0 then
        cashout = 0
    end
    return cashout
end
function Board.prototype.renderWinStatus(self)
    local selectedPower = self.gameManager.player:getCardPower()
    local enemyPower = self.enemy:getCardPower()
    if selectedPower > enemyPower then
        local screenW = love.graphics.getWidth()
        local screenH = love.graphics.getHeight()
        local bottomY = screenH - 150
        local selectedPanelW = 200
        local gap = 20
        local x
        if self.gameManager.player:anySelectedCards() then
            local selectedPanelX = math.floor(screenW / 2 - selectedPanelW / 2)
            x = selectedPanelX + selectedPanelW + gap
        else
            x = math.floor(screenW / 2 - 75)
        end
        suit.layout:reset(x, bottomY, 10, 10)
        suit.Label(
            "You will slay your foe!",
            {align = "left"},
            suit.layout:row(150, 40)
        )
        suit.Label(
            "Your cashout: " .. tostring(self:getPlayerCashout()),
            {align = "left"},
            suit.layout:row(150, 30)
        )
    end
end
function Board.prototype.renderPointsDisplay(self)
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 300
    local panelX = math.floor(centerX - panelW / 2)
    suit.layout:reset(panelX, 70, 10, 10)
    suit.Label(
        (("Enemy: " .. tostring(self.enemyPoints)) .. " | Player: ") .. tostring(self.playerPoints),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
end
function Board.prototype.renderEnemyStatsPanel(self, padX, padY)
    local enemyValue = self.enemy:getCardValue()
    local enemyPower = self.enemy:getCardPower()
    suit.layout:reset(padX, padY, 10, 10)
    suit.Label(
        "Enemy Stats",
        {align = "center"},
        suit.layout:row(150, 30)
    )
    suit.Label(
        "Value: " .. tostring(enemyValue),
        {align = "center"},
        suit.layout:row(150, 30)
    )
    suit.Label(
        "Power: " .. tostring(enemyPower),
        {align = "center"},
        suit.layout:row(150, 30)
    )
end
function Board.prototype.renderEnemyDeckVisualization(self)
    local enemyDeck = self.enemy.deck
    local padX = 20
    local panelY = 170
    suit.layout:reset(padX, panelY, 10, 10)
    suit.Label(
        ("Enemy Deck (" .. tostring(#enemyDeck)) .. " cards)",
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
function Board.prototype.renderPlayerSelectedStatsPanel(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    local selectedValue = self.gameManager.player:getCardValue()
    local selectedPower = self.gameManager.player:getCardPower()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelW = 200
    local panelX = math.floor(screenW / 2 - panelW / 2)
    local bottomY = screenH - 150
    suit.layout:reset(panelX, bottomY, 10, 10)
    suit.Label(
        "Selected Stats",
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Value: " .. tostring(selectedValue),
        {align = "center"},
        suit.layout:row(panelW, 30)
    )
    suit.Label(
        "Power: " .. tostring(selectedPower),
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
function Board.prototype.renderPlayButton(self, startY, btnW, btnH, padX, padY)
    local gap = 20
    local totalW = btnW * 3 + gap * 2
    suit.layout:reset(
        love.graphics.getWidth() / 2 - totalW / 2,
        startY,
        padX,
        padY
    )
    local playHit = suit.Button(
        "Play",
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
    if playHit then
        self:handlePlay()
    end
    if discardHit and discardEnabled then
        self:handleDiscard()
    end
    if deselectHit then
        self.gameManager.player:deselectAllCards()
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
function Board.prototype.handlePlay(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    if #self.enemy.deck == 0 then
        self:endFight()
        return
    end
    local selectedPower = self.gameManager.player:getCardPower()
    local enemyPower = self.enemy:getCardPower()
    if selectedPower > enemyPower then
        self.playerPoints = self.playerPoints + self:getPlayerCashout()
    else
        self.enemyPoints = self.enemyPoints + self:getEnemyCashout()
    end
    self.gameManager.player:removeSelectedCardsFromHand()
    Dealer:dealCards(self.gameManager, CharacterTypes.PLAYER)
    self.enemy:removeAllCardsFromHand()
    Dealer:dealCards(self.gameManager, CharacterTypes.ENEMY)
end
function Board.prototype.handleDiscard(self)
    if not self.gameManager.player:anySelectedCards() then
        return
    end
    self.gameManager.player:discard()
    self.discardUsed = self.discardUsed + 1
    Dealer:dealCards(self.gameManager, CharacterTypes.PLAYER)
end
function Board.prototype.getWinner(self)
    if self.playerPoints > self.enemyPoints then
        return CharacterTypes.PLAYER
    else
        return CharacterTypes.ENEMY
    end
end
function Board.prototype.endFight(self)
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
return ____exports
