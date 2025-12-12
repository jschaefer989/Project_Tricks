local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____Dealer = require("Dealer")
local Dealer = ____Dealer.default
local ____Draw = require("Draw")
local Draw = ____Draw.default
local suit = require("Libraries.suit-master.suit")
____exports.default = __TS__Class()
local Shop = ____exports.default
Shop.name = "Shop"
function Shop.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
    self.cardsForSale = {}
end
function Shop.prototype.load(self, data)
    self.cardsForSale = data.cardsForSale or ({})
end
function Shop.prototype.save(self)
    return {cardsForSale = self.cardsForSale}
end
function Shop.prototype.drawShop(self)
    local screenW = love.graphics.getWidth()
    local panelW = 400
    local labelY = 50
    local panelX = (screenW - panelW) / 2
    local labelHeight = 36
    suit.layout:reset(panelX, labelY)
    suit.Label(
        "Shop",
        {align = "center"},
        suit.layout:row(panelW, labelHeight)
    )
    local btnW = 300
    local btnH = 50
    local cardStartY = labelY + labelHeight + 30
    local cardX = (screenW - btnW) / 2
    local cardPadding = 15
    local currentY = cardStartY
    for ____, card in ipairs(self.cardsForSale) do
        suit.layout:reset(cardX, currentY)
        Draw:card(
            card,
            btnW,
            btnH,
            {
                onClick = function() return self:buyCard(card) end,
                displayCost = true
            }
        )
        currentY = currentY + (btnH + cardPadding)
    end
    local leaveBtnY = currentY + 20
    suit.layout:reset(cardX, leaveBtnY)
    local leaveResult = suit.Button(
        "Leave Shop",
        {},
        suit.layout:row(btnW, btnH)
    )
    if leaveResult.hit then
        local ____opt_0 = self.gameManager.map
        if ____opt_0 ~= nil then
            ____opt_0:advanceToNextTier()
        end
        self.gameManager:switchToMap()
    end
    Draw:playerInfo(self.gameManager.player, self.gameManager)
    Draw:playerDeck(self.gameManager.player)
end
function Shop.prototype.setup(self)
    self:generateCardsForSale()
end
function Shop.prototype.generateCardsForSale(self)
    self.cardsForSale = {}
    do
        local i = 0
        while i < 3 do
            local ____self_cardsForSale_2 = self.cardsForSale
            ____self_cardsForSale_2[#____self_cardsForSale_2 + 1] = Dealer:getRandomCard()
            i = i + 1
        end
    end
end
function Shop.prototype.canAfford(self, card)
    return self.gameManager.player.money >= card.cost
end
function Shop.prototype.buyCard(self, card)
    if not self:canAfford(card) then
        return
    end
    local ____self_gameManager_player_3, ____money_4 = self.gameManager.player, "money"
    ____self_gameManager_player_3[____money_4] = ____self_gameManager_player_3[____money_4] - card.cost
    local ____self_gameManager_player_deck_5 = self.gameManager.player.deck
    ____self_gameManager_player_deck_5[#____self_gameManager_player_deck_5 + 1] = card
    self:removeCardFromSale(card)
end
function Shop.prototype.removeCardFromSale(self, card)
    self.cardsForSale = __TS__ArrayFilter(
        self.cardsForSale,
        function(____, c) return not c:isEqual(card) end
    )
end
return ____exports
