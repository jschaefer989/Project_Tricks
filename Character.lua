local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArrayPushArray = ____lualib.__TS__ArrayPushArray
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local SortMode
local ____FontWithPosition = require("Assets.Fonts.FontWithPosition")
local FontWithPosition = ____FontWithPosition.default
local ____Enums = require("Enums")
local CharacterTypes = ____Enums.CharacterTypes
local PopupIds = ____Enums.PopupIds
local TextIds = ____Enums.TextIds
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
local ____Popup = require("Screens.Popup.Popup")
local PopupSizes = ____Popup.PopupSizes
____exports.default = __TS__Class()
local Character = ____exports.default
Character.name = "Character"
function Character.prototype.____constructor(self, gameManager, ____type)
    self.name = "Character"
    self.level = 1
    self.lastSortTime = 0
    self.sortMode = SortMode.POWER
    self.gameManager = gameManager
    self.type = ____type
    self.deck = {}
    self.hand = {}
    self.discardPile = {}
    self.numberOfHeldCards = 5
end
function Character.prototype.addToHand(self, card, index)
    if not isEmpty(index) and index >= 0 and index < #self.hand then
        __TS__ArraySplice(self.hand, index, 0, card)
    else
        local ____self_hand_0 = self.hand
        ____self_hand_0[#____self_hand_0 + 1] = card
    end
end
function Character.prototype.removeFromHand(self, card)
    do
        local index = 0
        while index < #self.hand do
            local otherCard = self.hand[index + 1]
            if card:isEqual(otherCard) then
                __TS__ArraySplice(self.hand, index, 1)
                break
            end
            index = index + 1
        end
    end
end
function Character.prototype.addToDeck(self, card)
    local ____self_deck_1 = self.deck
    ____self_deck_1[#____self_deck_1 + 1] = card
end
function Character.prototype.addToDiscards(self, card)
    local ____self_discardPile_2 = self.discardPile
    ____self_discardPile_2[#____self_discardPile_2 + 1] = card
end
function Character.prototype.addDiscardsToDeck(self)
    for ____, card in ipairs(self.discardPile) do
        self:addToDeck(card)
    end
    self.discardPile = {}
end
function Character.prototype.getCardPower(self)
    local power = 0
    for ____, card in ipairs(self.hand) do
        power = power + card:getPower()
    end
    return power
end
function Character.prototype.getCardValue(self)
    local value = 0
    for ____, card in ipairs(self.hand) do
        value = value + card:getValue()
    end
    return value
end
function Character.prototype.removeAllCardsFromHand(self)
    do
        local i = #self.hand - 1
        while i >= 0 do
            local card = self.hand[i + 1]
            self:addToDiscards(card)
            __TS__ArraySplice(self.hand, i, 1)
            i = i - 1
        end
    end
end
function Character.prototype.removeFromDeck(self, card)
    do
        local index = 0
        while index < #self.deck do
            local otherCard = self.deck[index + 1]
            if card:isEqual(otherCard) then
                __TS__ArraySplice(self.deck, index, 1)
            end
            index = index + 1
        end
    end
end
function Character.prototype.putHandBackInDeck(self)
    for ____, card in ipairs(self.hand) do
        self:addToDeck(card)
        if card.isSelected then
            card:onDiscard()
        end
    end
    self.hand = {}
end
function Character.prototype.showDeckOverview(self, asset)
    local tooltipLines = {
        __TS__New(
            FontWithPosition,
            TextIds.TOOLTIP_DECK_OVERVIEW_CARDS,
            0,
            10,
            ((" Deck: " .. tostring(#self.deck)) .. "/") .. tostring(self:getTotalCards())
        ),
        __TS__New(
            FontWithPosition,
            TextIds.TOOLTIP_DECK_OVERVIEW_DISCARDS,
            0,
            20,
            "Discards: " .. tostring(#self.discardPile)
        )
    }
    if self.type == CharacterTypes.ENEMY then
        local yOffset = 35
        local cardsToShow = __TS__ArraySlice(self.deck, #self.deck - self.numberOfHeldCards, #self.deck)
        for ____, card in ipairs(cardsToShow) do
            local cardTooltip = card:getShortCardInfo(0, yOffset)
            __TS__ArrayPushArray(tooltipLines, cardTooltip)
            yOffset = yOffset + 35
        end
    end
    self.gameManager.assetManager.tooltipManager:addTooltip(tooltipLines, asset)
end
function Character.prototype.getTotalCards(self)
    return #self.deck + #self.hand + #self.discardPile
end
function Character.prototype.showDeckContents(self)
    self.gameManager.popupManager:open(PopupIds.DECK_CONTENTS, self.name .. " Deck", PopupSizes.MENU)
end
function Character.prototype.sortCards(self)
    local now = os.time() * 1000
    local timeSinceLastSort = now - self.lastSortTime
    local threshold = 3000
    self:getSortMode(timeSinceLastSort, threshold)
    self.lastSortTime = now
    self:applySort()
    self:redrawHand()
end
function Character.prototype.getSortMode(self, timeSinceLastSort, threshold)
    if timeSinceLastSort < threshold then
        repeat
            local ____switch41 = self.sortMode
            local ____cond41 = ____switch41 == SortMode.POWER
            if ____cond41 then
                self.sortMode = SortMode.VALUE
                break
            end
            ____cond41 = ____cond41 or ____switch41 == SortMode.VALUE
            if ____cond41 then
                self.sortMode = SortMode.SUIT
                break
            end
            ____cond41 = ____cond41 or ____switch41 == SortMode.SUIT
            if ____cond41 then
                self.sortMode = SortMode.POWER
                break
            end
        until true
    else
        self.sortMode = SortMode.POWER
    end
end
function Character.prototype.applySort(self)
    repeat
        local ____switch44 = self.sortMode
        local ____cond44 = ____switch44 == SortMode.POWER
        if ____cond44 then
            self:sortByPower()
            break
        end
        ____cond44 = ____cond44 or ____switch44 == SortMode.VALUE
        if ____cond44 then
            self:sortByValue()
            break
        end
        ____cond44 = ____cond44 or ____switch44 == SortMode.SUIT
        if ____cond44 then
            self:sortBySuit()
            break
        end
    until true
end
function Character.prototype.sortByPower(self)
    self.hand = __TS__ArraySort(
        self.hand,
        function(____, a, b) return b:getPower() - a:getPower() end
    )
    lovelyToasts.show("Sorted by Power", 2, "bottom")
end
function Character.prototype.sortByValue(self)
    self.hand = __TS__ArraySort(
        self.hand,
        function(____, a, b) return b:getValue() - a:getValue() end
    )
    lovelyToasts.show("Sorted by Value", 2, "bottom")
end
function Character.prototype.sortBySuit(self)
    self.hand = __TS__ArraySort(
        self.hand,
        function(____, a, b) return a.suit == b.suit and 0 or (a.suit < b.suit and -1 or 1) end
    )
    lovelyToasts.show("Sorted by Suit", 2, "bottom")
end
function Character.prototype.redrawHand(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local cardAssets = self.gameManager.board.cardAssets
    local y = cardAssets:getHandYCoordinate(CharacterTypes.PLAYER)
    do
        local index = 0
        while index < #self.hand do
            local card = self.hand[index + 1]
            local ____temp_3 = self.gameManager.board.dealer:getCardPointInHand(CharacterTypes.PLAYER, index, #self.hand)
            local targetX = ____temp_3.x
            cardAssets:repositionCard(card, targetX, y)
            cardAssets:redrawCard(card)
            index = index + 1
        end
    end
    self.gameManager.board.cardAssets:disableAllCards(false)
end
SortMode = SortMode or ({})
SortMode.POWER = "POWER"
SortMode.VALUE = "VALUE"
SortMode.SUIT = "SUIT"
return ____exports
