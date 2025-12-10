local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Draw = require("Draw")
local Draw = ____Draw.default
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local WinScreen = ____exports.default
WinScreen.name = "WinScreen"
function WinScreen.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function WinScreen.prototype.drawScreen(self)
    local screenW = love.graphics.getWidth()
    local panelW = 240
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    self:renderVictoryLabel()
    local panelY = labelY + labelHeight
    local panelH = self:renderPlayerInfoPanel(panelX, panelY, panelW)
    local lootStartY = panelY + panelH + 10
    local lootH = self:renderLootCards(panelX, lootStartY, panelW)
    local continueBtnY = lootStartY + lootH + 10
    self:renderContinueButton(panelX, continueBtnY, panelW)
end
function WinScreen.prototype.renderVictoryLabel(self)
    suit.layout:reset(
        (love.graphics.getWidth() - 240) / 2,
        50
    )
    suit.Label(
        "Victory!",
        {align = "center"},
        suit.layout:row(240, 36)
    )
end
function WinScreen.prototype.renderPlayerInfoPanel(self, x, y, panelW)
    local name = self.gameManager.player.name or "Player"
    local level = self.gameManager.player.level or 1
    local exp = self.gameManager.player.experience or 0
    local money = self.gameManager.player.money or 0
    suit.layout:reset(x, y)
    suit.Label(
        name,
        {align = "center"},
        suit.layout:row(panelW, 24)
    )
    suit.Label(
        "Level: " .. tostring(level),
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    suit.Label(
        "XP: " .. tostring(exp),
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    suit.Label(
        "Money: " .. tostring(money),
        {align = "left"},
        suit.layout:row(panelW, 22)
    )
    local totalHeight = 24 + 22 * 3
    return totalHeight
end
function WinScreen.prototype.renderLootCards(self, panelX, startY, panelW)
    local labelH = 24
    suit.layout:reset(panelX, startY)
    suit.Label(
        "Loot:",
        {align = "center"},
        suit.layout:row(panelW, labelH)
    )
    local lootCards = self.gameManager.board and self.gameManager.board.dealer and self.gameManager.board.dealer.lootCards or ({})
    local padding = 8
    local maxBtnW = 120
    local count = math.max(1, #lootCards)
    local btnW = math.floor((panelW - padding * (count - 1)) / count)
    btnW = math.max(
        40,
        math.min(btnW, maxBtnW)
    )
    local btnH = math.floor(btnW * 1.4)
    local cardsY = startY + labelH + 8
    do
        local i = 0
        while i < #lootCards do
            local card = lootCards[i + 1]
            local x = panelX + i * (btnW + padding)
            suit.layout:reset(x, cardsY)
            Draw:card(
                self.gameManager,
                card,
                btnW,
                btnH,
                true
            )
            i = i + 1
        end
    end
    local totalHeight = labelH + 8 + btnH
    return totalHeight
end
function WinScreen.prototype.renderContinueButton(self, panelX, panelY, panelW)
    local btnW = 200
    local btnH = 50
    suit.layout:reset(panelX + (panelW - btnW) / 2, panelY)
    local continueResult = suit.Button(
        "Continue",
        {},
        suit.layout:row(btnW, btnH)
    )
    if continueResult and continueResult.hit then
        local ____ = self.gameManager.player.addDiscardsToDeck and self.gameManager.player:addDiscardsToDeck()
        local ____isEmpty_2 = isEmpty
        local ____opt_0 = self.gameManager.board
        if not ____isEmpty_2(____opt_0 and ____opt_0.dealer) then
            self.gameManager.board.dealer:addLootCardsToPlayer()
        end
        self.gameManager.board = nil
        local ____ = self.gameManager.switchToBoard and self.gameManager:switchToBoard()
    end
end
function WinScreen.prototype.addLootCardsToPlayer(self)
    local lootCards = self.gameManager.board and self.gameManager.board.dealer and self.gameManager.board.dealer.lootCards or ({})
    do
        local i = 0
        while i < #lootCards do
            local card = lootCards[i + 1]
            if card.selected then
                local ____ = self.gameManager.player.addToHand and self.gameManager.player:addToHand(card)
            end
            i = i + 1
        end
    end
end
return ____exports
