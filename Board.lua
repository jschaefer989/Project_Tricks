local object = require('Libraries.classic-master.classic')
Board = object:extend()
local suit = require('Libraries.suit-master')

-- TODO: Refactor hardcoded layout values into constants or configuration

function Board:new()
    self.discardUsed = 0
    self.enemy = Enemy()
    self.dealer = Dealer()
    self.playerPoints = 0
    self.enemyPoints = 0
end

function Board:drawBoard()
    local btnW, btnH = 140, 70
    local lblH = 30
    local padX, padY = 20, 20

    local contentW = self:getContentWidth()
    local coords = self:getStartingCoordinates(contentW, btnH, lblH, padY)
    local startX, startY = coords.startX, coords.startY

    -- Win status display at top
    self:renderWinStatus()

    -- Points display (top center)
    self:renderPointsDisplay()

    -- Enemy stats panel (left side)
    self:renderEnemyStatsPanel(padX, padY)

    -- Enemy deck visualization (left side, below enemy stats)
    self:renderEnemyDeckVisualization()

    -- Enemy row
    self:renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    
    -- Player row (below enemy)
    startY = startY + lblH + padY + btnH + 200
    self:renderPlayerRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)

    -- Submit button centered below
    self:renderPlayButton(startY + lblH + btnH + padY + 50, btnW, btnH, padX, padY)

    -- Player selected stats panel (right side)
    self:renderPlayerSelectedStatsPanel(padY)

    -- Player info (upper-right)
    self:renderPlayerInfoPanel(padX, padY)

    -- Player deck visualization (bottom right)
    self:renderPlayerDeckVisualization()

    -- Discard counter (bottom center)
    self:renderDiscardCounter()
end

function Board:getStartingCoordinates(contentW, btnH, groupH, padY)
    local totalH = groupH * 2 + padY + btnH -- two groups plus spacing plus submit button

    local centerX = love.graphics.getWidth() / 2
    local centerY = love.graphics.getHeight() / 2
    return { startX = math.floor(centerX - contentW / 2), startY = math.floor(centerY - totalH / 2 - 200) }
end

function Board:getContentWidth()
    local enemyHand = self.enemy.hand
    local playerHand = Player.hand

    local function rowWidth(count)
        if count <= 0 then return 100 end
        return count * 100 + (count - 1) * 20
    end

    return math.max(rowWidth(#enemyHand), rowWidth(#playerHand), 300)
end

function Board:getCashout()
    local selectedValue = Player:getCardValue()
    local enemyValue = self.enemy:getCardValue()
    local cashout = selectedValue - enemyValue
    if cashout < 0 then cashout = 0 end
    return cashout
end

function Board:renderWinStatus()
    local selectedPower = Player:getCardPower()
    local enemyPower = self.enemy:getCardPower()

    -- Display "Winning!" to the right of the selected-stats panel when visible,
    -- otherwise center it at the bottom.
    if selectedPower > enemyPower then
        local screenW = love.graphics.getWidth()
        local screenH = love.graphics.getHeight()
        local bottomY = screenH - 150
        local selectedPanelW = 200
        local gap = 20
        local x
        if Player:anySelectedCards() then
            local selectedPanelX = math.floor(screenW / 2 - selectedPanelW / 2)
            x = selectedPanelX + selectedPanelW + gap
        else
            x = math.floor(screenW / 2 - 75)
        end

        suit.layout:reset(x, bottomY, 10, 10)
        suit.Label("You will slay your foe!", {align = "left"}, suit.layout:row(150, 40))
        suit.Label("Your cashout: " .. self:getCashout(), {align = "left"}, suit.layout:row(150, 30))
    end
end

function Board:renderPointsDisplay()
    local screenW = love.graphics.getWidth()
    local centerX = screenW / 2
    local panelW = 300
    local panelX = math.floor(centerX - panelW / 2)

    suit.layout:reset(panelX, 70, 10, 10)
    suit.Label("Enemy: " .. self.enemyPoints .. " | Player: " .. self.playerPoints, {align = "center"}, suit.layout:row(panelW, 30))
end

function Board:renderEnemyStatsPanel(padX, padY)
    local enemyValue = self.enemy:getCardValue()
    local enemyPower = self.enemy:getCardPower()

    suit.layout:reset(padX, padY, 10, 10)
    suit.Label("Enemy Stats", {align = "center"}, suit.layout:row(150, 30))
    suit.Label("Value: " .. enemyValue, {align = "center"}, suit.layout:row(150, 30))
    suit.Label("Power: " .. enemyPower, {align = "center"}, suit.layout:row(150, 30))
end

function Board:renderEnemyDeckVisualization()
    local enemyDeck = self.enemy.deck
    local padX = 20
    local panelY = 170  -- Position below enemy stats panel
    
    suit.layout:reset(padX, panelY, 10, 10)
    suit.Label("Enemy Deck (" .. #enemyDeck .. " cards)", {align = "left"}, suit.layout:row(150, 30))
    suit.layout:row(0, 5)
    
    -- Display each card in the enemy's deck
    for i, card in ipairs(enemyDeck) do
        local cardText = card.rank .. " " .. card.suit .. " - Val: " .. card.value .. ", Pow: " .. card.power
        suit.Label(cardText, {align = "left"}, suit.layout:row(150, 25))
    end
end

function Board:renderPlayerSelectedStatsPanel(padY)
    -- Only show when the player has at least one selected card
    if not Player:anySelectedCards() then return end

    local selectedValue = Player:getCardValue()
    local selectedPower = Player:getCardPower()

    -- Center the panel at the bottom-middle of the screen
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelW = 200
    local panelX = math.floor(screenW / 2 - panelW / 2)
    local bottomY = screenH - 150
    suit.layout:reset(panelX, bottomY, 10, 10)
    suit.Label("Selected Stats", {align = "center"}, suit.layout:row(panelW, 30))
    suit.Label("Value: " .. selectedValue, {align = "center"}, suit.layout:row(panelW, 30))
    suit.Label("Power: " .. selectedPower, {align = "center"}, suit.layout:row(panelW, 30))
end

function Board:renderPlayerInfoPanel(padX, padY)
    local name = Player.name or "Player"
    local level = Player.level or 1
    local exp = Player.experience or 0
    local money = Player.money or 0
    local screenW = love.graphics.getWidth()
    local panelW = 200
    local panelX = screenW - panelW - padX

    suit.layout:reset(panelX, padY, 10, 10)
    suit.Label(name, {align = "center"}, suit.layout:row(panelW, 24))
    suit.Label("Level: " .. level, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("XP: " .. exp, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("Money: " .. money, {align = "left"}, suit.layout:row(panelW, 22))
end

function Board:renderPlayerDeckVisualization()
    local deckSize = #Player.deck
    local discardSize = #Player.discardPile
    
    -- Render discard pile and deck visualization in bottom right corner
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelX = screenW - 170  -- Same right alignment as selected stats
    local panelY = screenH - 200  -- Higher up to fit on screen
    
    suit.layout:reset(panelX, panelY, 10, 10)
    suit.Label("Discard Pile", {align = "center"}, suit.layout:row(150, 30))
    suit.Label("Cards: " .. discardSize, {align = "center"}, suit.layout:row(150, 30))
    
    suit.layout:row(0, 10)
    suit.Label("Player Deck", {align = "center"}, suit.layout:row(150, 30))
    suit.Label("Cards Remaining: " .. deckSize, {align = "center"}, suit.layout:row(150, 30))
end

function Board:renderEnemyRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    local enemyHand = self.enemy.hand
    suit.layout:reset(startX, startY, padX, padY)
    suit.Label("Enemy hand: " .. #enemyHand, {align = "left"}, suit.layout:row(contentW, lblH))
    suit.layout:row(0,0)
    for i, card in ipairs(enemyHand) do
        local labelText = card.rank .. " " .. card.suit .. " (Val: " .. card.value .. ", Pow: " .. card.power .. ")"
        suit.Label(labelText, {align = "left"}, suit.layout:col(btnW, btnH))
    end
end

function Board:renderPlayerRow(startX, startY, contentW, btnW, btnH, lblH, padX, padY)
    local playerHand = Player.hand
    suit.layout:reset(startX, startY, padX, padY)
    suit.Label("Your hand: " .. #playerHand, {align = "left"}, suit.layout:row(contentW, lblH))
    suit.layout:row(0,0)
    for i, card in ipairs(playerHand) do
        local isSelected = card.selected
        local btnText = card.rank .. " " .. card.suit .. " (Val: " .. card.value .. ", Pow: " .. card.power .. ")"
        if isSelected then
            btnText = "[X] " .. btnText
        else
            btnText = "[ ] " .. btnText
        end
        local btnHit = suit.Button(btnText, suit.layout:col(btnW, btnH)).hit
        if btnHit then
            card.selected = not card.selected
        end
    end
end

function Board:renderPlayButton(startY, btnW, btnH, padX, padY)
    -- Center the buttons horizontally
    local gap = 20
    local totalW = btnW * 2 + gap    
    
    suit.layout:reset(love.graphics.getWidth() / 2 - totalW / 2, startY, padX, padY)
    
    local playHit = suit.Button("Play", suit.layout:col(btnW, btnH)).hit
    
    -- Check if discard button should be enabled
    local discardEnabled = self.discardUsed < Player.discards
    local discardLabel = discardEnabled and "Discard" or "Discard (used)"
    local discardHit = suit.Button(discardLabel, suit.layout:col(btnW, btnH)).hit

    if playHit then
        self:handlePlay()
    end
    if discardHit and discardEnabled then
        self:handleDiscard()
    end
end

function Board:renderDiscardCounter()
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()
    local panelX = screenW - 170  -- Right side, aligned with discard pile
    local panelY = screenH - 240  -- Above the discard pile visualization

    suit.layout:reset(panelX, panelY, 10, 10)
    suit.Label("Discards Remaining: " .. (Player.discards - self.discardUsed) .. "/" .. Player.discards, {align = "center"}, suit.layout:row(150, 30))
end

function Board:handlePlay()
    if not Player:anySelectedCards() then return end

    if #self.enemy.deck == 0 then
        self:endFight()
        return
    end

    local selectedPower = Player:getCardPower()
    local enemyPower = self.enemy:getCardPower()
    
    if selectedPower > enemyPower then
        self.playerPoints = self.playerPoints + self:getCashout()
    else
        self.enemyPoints = self.enemyPoints + self.enemy:getCardValue()
    end

    Player:removeSelectedCardsFromHand()
    Dealer:dealCards(CharacterTypes.PLAYER)

    self.enemy:removeAllCardsFromHand()
    Dealer:dealCards(CharacterTypes.ENEMY)
end

function Board:handleDiscard()
    Player:discard()

    self.discardUsed = self.discardUsed + 1

    -- Refill the player's hand after discarding
    Dealer:dealCards(CharacterTypes.PLAYER)
end

function Board:getWinner()
    if self.playerPoints > self.enemyPoints then
        return CharacterTypes.PLAYER
    else
        return CharacterTypes.ENEMY
    end
end

function Board:endFight()
    local winner = self:getWinner()
    if winner == CharacterTypes.PLAYER then
        Player:cashout(self.playerPoints)
        GameManager:switchToWinScreen()
    elseif winner == CharacterTypes.ENEMY then
        GameManager:switchToLoseScreen()
    end
end
