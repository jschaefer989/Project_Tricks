local object = require('Libraries.classic-master.classic')
WinScreen = object:extend()
local suit = require('Libraries.suit-master')

function WinScreen:new()
end

function WinScreen:drawScreen()
    -- Display the victory message (centered)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50

    -- Render player info panel centered under the Victory label
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    -- Use layout row for the Victory label
    self:renderVictoryLabel()

    local panelY = labelY + labelHeight
    local panelH = self:renderPlayerInfoPanel(panelX, panelY, panelW)

    -- Render Loot label above cards and get its height so we can place the Continue button below
    local lootStartY = panelY + panelH + 10
    local lootH = self:renderLootCards(panelX, lootStartY, panelW)

    -- Create a continue button below the loot cards using layout row
    local continueBtnY = lootStartY + lootH + 10
    self:renderContinueButton(panelX, continueBtnY, panelW)
end

function WinScreen:renderVictoryLabel()
    suit.layout:reset((love.graphics.getWidth() - 240) / 2, 50)
    suit.Label("Victory!", {align = "center"}, suit.layout:row(240, 36))
end

function WinScreen:renderPlayerInfoPanel(x, y, panelW)
    local name = Player.name or "Player"
    local level = Player.level or 1
    local exp = Player.experience or 0
    local money = Player.money or 0

    suit.layout:reset(x, y)
    suit.Label(name, {align = "center"}, suit.layout:row(panelW, 24))
    suit.Label("Level: " .. level, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("XP: " .. exp, {align = "left"}, suit.layout:row(panelW, 22))
    suit.Label("Money: " .. money, {align = "left"}, suit.layout:row(panelW, 22))

    -- Return the computed panel height so callers can place elements below
    local totalHeight = 24 + 22 * 3
    return totalHeight
end

function WinScreen:renderLootCards(panelX, startY, panelW)
    local labelH = 24
    -- Place the Loot label at the start Y
    suit.layout:reset(panelX, startY)
    suit.Label("Loot:", {align = "center"}, suit.layout:row(panelW, labelH))

    local lootCards = GameManager.board.dealer and GameManager.board.dealer.lootCards or {}
    local padding = 8
    local maxBtnW = 120
    local count = math.max(1, #lootCards)
    local btnW = math.floor((panelW - padding * (count - 1)) / count)
    btnW = math.max(40, math.min(btnW, maxBtnW))
    local btnH = math.floor(btnW * 1.4) -- card aspect ratio

    -- Cards start below the label
    local cardsY = startY + labelH + 8
    for i, card in ipairs(lootCards) do
        local x = panelX + (i - 1) * (btnW + padding)
        suit.layout:reset(x, cardsY)
        Draw:card(card, btnW, btnH, true) -- true to allow selecting only one card
    end

    local totalHeight = labelH + 8 + btnH
    return totalHeight
end

function WinScreen:renderContinueButton(panelX, panelY, panelW)
    local btnW, btnH = 200, 50
    suit.layout:reset(panelX + (panelW - btnW) / 2, panelY)
    local continueResult = suit.Button("Continue", {}, suit.layout:row(btnW, btnH))
    if continueResult.hit then
        Player:addDiscardsToDeck()
        GameManager.board.dealer:addLootCardsToPlayer()
        GameManager.board = {}
        GameManager:switchToBoard() -- TODO: will need to go back to the map at some point
    end
end
