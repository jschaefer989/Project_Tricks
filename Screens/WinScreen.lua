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
    local lootStartY = labelY + labelHeight + 10
    self:renderLootCards(panelX, lootStartY, panelW)
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player)
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
                card,
                btnW,
                btnH,
                {onClick = function() return self:handleLootCardSelection(card) end}
            )
            i = i + 1
        end
    end
    local totalHeight = labelH + 8 + btnH
    return totalHeight
end
function WinScreen.prototype.handleLootCardSelection(self, card)
    local ____self_2 = self.gameManager.player
    local ____self_2_gatherExperience_3 = ____self_2.gatherExperience
    local ____opt_0 = self.gameManager.board
    local levelUp = ____self_2_gatherExperience_3(____self_2, ____opt_0 and ____opt_0.enemy.experience or 0)
    self.gameManager.player:addToDeck(card)
    self.gameManager.board = nil
    if levelUp then
        self.gameManager:switchToLevelUpScreen()
        return
    end
    local ____opt_4 = self.gameManager.map
    if ____opt_4 ~= nil then
        ____opt_4:advanceToNextTier()
    end
    self.gameManager:switchToMap()
end
function WinScreen.prototype.addLootCardsToPlayer(self)
    local ____opt_6 = self.gameManager.board
    local lootCards = ____opt_6 and ____opt_6.dealer.lootCards
    if isEmpty(lootCards) then
        return
    end
    for ____, card in ipairs(lootCards) do
        if card.selected then
            self.gameManager.player:addToDeck(card)
        end
    end
end
return ____exports
