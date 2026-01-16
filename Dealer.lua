local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____CardAssets = require("Assets.CardAssets")
local cardHeight = ____CardAssets.cardHeight
local cardWidth = ____CardAssets.cardWidth
local padding = ____CardAssets.padding
local ____CardGenerator = require("Cards.CardGenerator")
local CardGenerator = ____CardGenerator.default
local push = require("Libraries.push")
local ____Enums = require("Enums")
local AssetIds = ____Enums.AssetIds
local CharacterTypes = ____Enums.CharacterTypes
local Ranks = ____Enums.Ranks
local Suits = ____Enums.Suits
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local getRandomElementFromArray = ____Helpers.getRandomElementFromArray
local isEmpty = ____Helpers.isEmpty
____exports.default = __TS__Class()
local Dealer = ____exports.default
Dealer.name = "Dealer"
function Dealer.prototype.____constructor(self, gameManager, board)
    self.dealSound = love.audio.newSource("Assets/Sounds/Deal.wav", "static")
    self.gameManager = gameManager
    self.board = board
    self.lootCards = {}
end
function Dealer.prototype.setup(self)
    if #self.gameManager.player.deck == 0 then
        ____exports.default:initializePlayerDeck(self.gameManager)
    end
    self.gameManager.player:unselectCards()
    self:initializeEnemyDeck()
end
function Dealer.prototype.dealEdel(self)
    self:dealCards(CharacterTypes.PLAYER)
    self:dealCards(CharacterTypes.ENEMY)
    self:determineEdelSuit()
end
function Dealer.prototype.dealHandAtStartOfFight(self)
    self.board.cardAssets:disableAllCards(true)
    local playerHandBefore = self:getCharacterHand(CharacterTypes.PLAYER)
    self:putCharacterHandBackInDeck(CharacterTypes.PLAYER)
    self:startReturnToDeckAnimation(
        CharacterTypes.PLAYER,
        playerHandBefore,
        function() return self:finishPlayerDeal() end
    )
end
function Dealer.prototype.dealAtStartOfFightForCharacter(self, character)
    ____exports.default:shuffle(self.gameManager, character)
    self:dealCards(character)
    if character == CharacterTypes.ENEMY then
        self.board:tallyEnemyPowerAndValue()
    end
end
function Dealer.prototype.finishPlayerDeal(self)
    self:dealAtStartOfFightForCharacter(CharacterTypes.PLAYER)
    local enemyHandBefore = self:getCharacterHand(CharacterTypes.ENEMY)
    self:putCharacterHandBackInDeck(CharacterTypes.ENEMY)
    self:startReturnToDeckAnimation(
        CharacterTypes.ENEMY,
        enemyHandBefore,
        function()
            self:dealAtStartOfFightForCharacter(CharacterTypes.ENEMY)
        end
    )
end
function Dealer.prototype.getCharacterHand(self, characterType)
    repeat
        local ____switch13 = characterType
        local ____cond13 = ____switch13 == CharacterTypes.PLAYER
        if ____cond13 then
            return self.gameManager.player.hand
        end
        ____cond13 = ____cond13 or ____switch13 == CharacterTypes.ENEMY
        if ____cond13 then
            return self.board.enemy.hand or ({})
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.putCharacterHandBackInDeck(self, characterType)
    repeat
        local ____switch15 = characterType
        local ____cond15 = ____switch15 == CharacterTypes.PLAYER
        if ____cond15 then
            self.gameManager.player:putHandBackInDeck()
            break
        end
        ____cond15 = ____cond15 or ____switch15 == CharacterTypes.ENEMY
        if ____cond15 then
            self.board.enemy:putHandBackInDeck()
            break
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.initializePlayerDeck(self, gameManager)
    for ____, suit in ipairs(__TS__ObjectValues(Suits)) do
        for ____, rank in ipairs(__TS__ObjectValues(Ranks)) do
            gameManager.player:addToDeck(CardGenerator:getNewCard(gameManager, rank, suit))
        end
    end
    ____exports.default:shuffle(gameManager, CharacterTypes.PLAYER)
end
function Dealer.shuffle(self, gameManager, characterType)
    local character = gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    do
        local i = #character.deck - 1
        while i >= 1 do
            local j = math.floor(math.random() * (i + 1))
            local temp = character.deck[i + 1]
            character.deck[i + 1] = character.deck[j + 1]
            character.deck[j + 1] = temp
            i = i - 1
        end
    end
end
function Dealer.prototype.dealCards(self, characterType, removedIndices)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardsToDeal = character.numberOfHeldCards - #character.hand
    local deckPosition = self:getDeckPosition(characterType)
    local finalCardCount = #character.hand + cardsToDeal
    do
        local index = 0
        while index < cardsToDeal do
            do
                local card = table.remove(character.deck)
                if isEmpty(card) then
                    goto __continue28
                end
                local indexToUse = removedIndices and removedIndices[index + 1] or index
                character:addToHand(card, indexToUse)
                self.board.cardAssets:addAsset(card, deckPosition.x, deckPosition.y, characterType == CharacterTypes.PLAYER and not self.board.showingEdelView)
                local handPosition = self:getCardPointInHand(characterType, indexToUse, finalCardCount)
                self:startDealAnimation(characterType, card, handPosition.x, handPosition.y)
            end
            ::__continue28::
            index = index + 1
        end
    end
    self:redrawDeck(characterType)
end
function Dealer.prototype.redrawDeck(self, characterType)
    repeat
        local ____switch31 = characterType
        local playerDeck, enemyDeck
        local ____cond31 = ____switch31 == CharacterTypes.PLAYER
        if ____cond31 then
            playerDeck = self.gameManager.assetManager:getAsset(AssetIds.PLAYER_DECK, AssetIds.PLAYER_DECK)
            self.gameManager.assetManager:removeAssets(AssetIds.PLAYER_DECK)
            if not isEmpty(playerDeck) then
                self.gameManager.assetManager:addAsset(AssetIds.PLAYER_DECK, playerDeck)
            end
            break
        end
        ____cond31 = ____cond31 or ____switch31 == CharacterTypes.ENEMY
        if ____cond31 then
            enemyDeck = self.gameManager.assetManager:getAsset(AssetIds.ENEMY_DECK, AssetIds.ENEMY_DECK)
            self.gameManager.assetManager:removeAssets(AssetIds.ENEMY_DECK)
            if not isEmpty(enemyDeck) then
                self.gameManager.assetManager:addAsset(AssetIds.ENEMY_DECK, enemyDeck)
            end
            break
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.discardCards(self, characterType, cards)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return {}
    end
    local removedIndices = self:discardForCharacter(characterType)
    self:startDiscardAnimation(characterType, cards)
    return removedIndices
end
function Dealer.prototype.discardForCharacter(self, characterType)
    repeat
        local ____switch37 = characterType
        local ____cond37 = ____switch37 == CharacterTypes.PLAYER
        if ____cond37 then
            return self.gameManager.player:discard()
        end
        ____cond37 = ____cond37 or ____switch37 == CharacterTypes.ENEMY
        if ____cond37 then
            return self.board.enemy:discard() or ({})
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.dealNextHand(self)
    local playerIndices = self:discardCards(
        CharacterTypes.PLAYER,
        self.gameManager.player:getSelectedCards()
    )
    self:dealCards(CharacterTypes.PLAYER, playerIndices)
    local enemyIndices = self:discardCards(CharacterTypes.ENEMY, self.board.enemy.hand or ({}))
    self:dealCards(CharacterTypes.ENEMY, enemyIndices)
end
function Dealer.prototype.getDeckPosition(self, characterType)
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local portraitPosition = self.board:getPortraitPosition(characterType)
    repeat
        local ____switch40 = characterType
        local ____cond40 = ____switch40 == CharacterTypes.PLAYER
        if ____cond40 then
            return {x = screenW - cardWidth - 5, y = portraitPosition or screenH - 5}
        end
        ____cond40 = ____cond40 or ____switch40 == CharacterTypes.ENEMY
        if ____cond40 then
            return {x = screenW - cardWidth - 5, y = portraitPosition or 5}
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.getCardPointInHand(self, characterType, cardIndex, totalCardCount)
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local individualCardWidth = cardWidth + padding
    local totalW = individualCardWidth * totalCardCount - padding
    local startX = math.floor((screenW - totalW) / 2)
    local cardY = self.board.cardAssets:getHandYCoordinate(characterType) or (characterType == CharacterTypes.PLAYER and screenH - cardHeight - 20 or 20)
    return {x = startX + cardIndex * individualCardWidth, y = cardY}
end
function Dealer.prototype.startDealAnimation(self, characterType, card, targetX, targetY)
    local ____temp_0 = self.board.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_0.baseAsset
    local slideAssets = self.board.cardAssets:getCardAssetList(card)
    local startX = baseAsset and baseAsset.x or 0
    local startY = baseAsset and baseAsset.y or 0
    local offsetX = targetX - startX
    local offsetY = targetY - startY
    self.gameManager.animationManager:startAnimation(
        card.id,
        __TS__New(
            SlideAnimation,
            self.gameManager,
            card.id,
            self.gameManager.settings.dealerSpeed,
            offsetX,
            offsetY,
            slideAssets,
            {
                waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds(),
                onFinish = self:getDealFinishMethod(characterType),
                soundToPlay = self.dealSound
            }
        )
    )
end
function Dealer.prototype.getDealFinishMethod(self, characterType)
    if self.board.showingEdelView then
        return function() return self.board:displayEdel() end
    elseif self.board.playerPoints == 0 and self.board.enemyPoints == 0 then
        return function() return self.board:displayFight() end
    else
        return function() return self:finishDeal(characterType) end
    end
end
function Dealer.prototype.finishDeal(self, characterType)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    self.gameManager.assetManager:disableAllClickableAssets(false)
    self.board.cardAssets:disableAllCards(false)
    self.board:updatePrimaryButtonStates()
    if characterType == CharacterTypes.ENEMY then
        self.board:tallyEnemyPowerAndValue()
    end
end
function Dealer.prototype.startDiscardAnimation(self, characterType, cards)
    local targetY = self:getDiscardPosition(characterType)
    for ____, card in ipairs(cards) do
        local ____temp_5 = self.board.cardAssets:getCardAssets(card)
        local baseAsset = ____temp_5.baseAsset
        local slideAssets = self.board.cardAssets:getCardAssetList(card)
        local startY = baseAsset and baseAsset.y or 0
        local offsetX = 0
        local offsetY = targetY - startY
        self.gameManager.animationManager:startAnimation(
            card.id,
            __TS__New(
                SlideAnimation,
                self.gameManager,
                card.id,
                self.gameManager.settings.dealerSpeed,
                offsetX,
                offsetY,
                slideAssets,
                {
                    onFinish = function() return self:finishUpRemoveCardAnimation(card) end,
                    waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds()
                }
            )
        )
    end
end
function Dealer.prototype.getDiscardPosition(self, characterType)
    local screenH = push:getHeight()
    repeat
        local ____switch58 = characterType
        local ____cond58 = ____switch58 == CharacterTypes.PLAYER
        if ____cond58 then
            return screenH + cardHeight + 40
        end
        ____cond58 = ____cond58 or ____switch58 == CharacterTypes.ENEMY
        if ____cond58 then
            return -cardHeight - 40
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.startReturnToDeckAnimation(self, characterType, cards, onFinish)
    local deckPosition = self:getDeckPosition(characterType)
    for ____, card in ipairs(cards) do
        local ____temp_8 = self.board.cardAssets:getCardAssets(card)
        local baseAsset = ____temp_8.baseAsset
        local slideAssets = self.board.cardAssets:getCardAssetList(card)
        local startX = baseAsset and baseAsset.x or 0
        local startY = baseAsset and baseAsset.y or 0
        local offsetX = deckPosition.x - startX
        local offsetY = deckPosition.y - startY
        self.gameManager.animationManager:startAnimation(
            card.id,
            __TS__New(
                SlideAnimation,
                self.gameManager,
                card.id,
                self.gameManager.settings.dealerSpeed,
                offsetX,
                offsetY,
                slideAssets,
                {
                    onFinish = function() return self:finishUpRemoveCardAnimation(card, onFinish) end,
                    waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds(),
                    soundToPlay = self.dealSound
                }
            )
        )
    end
end
function Dealer.prototype.finishUpRemoveCardAnimation(self, card, onFinish)
    self.board.cardAssets:removeCardAssets(card)
    if not self.gameManager.animationManager:hasAnimations() then
        if onFinish ~= nil then
            onFinish()
        end
    end
end
function Dealer.prototype.initializeEnemyDeck(self)
    do
        local i = 0
        while i < self.board.enemy.numberOfCardsInDeck do
            self.board.enemy:addToDeck(CardGenerator:getRandomCard(self.gameManager))
            i = i + 1
        end
    end
    ____exports.default:shuffle(self.gameManager, CharacterTypes.ENEMY)
end
function Dealer.prototype.determineEdelSuit(self)
    local player = self.gameManager.player
    local edelCard = nil
    local lowestPower = 100
    do
        local index = 0
        while index < #player.hand do
            local card = player.hand[index + 1]
            if index == 0 or card:getPower() < lowestPower then
                lowestPower = card:getPower()
                edelCard = card
            end
            index = index + 1
        end
    end
    for ____, card in ipairs(self.board.enemy.hand) do
        if card:getPower() < lowestPower then
            lowestPower = card:getPower()
            edelCard = card
        end
    end
    self.board.edelCard = edelCard
end
function Dealer.prototype.getLootCards(self)
    self.lootCards = {}
    do
        local i = 0
        while i < self.gameManager.player.numberOfLootCards do
            local card = getRandomElementFromArray(self.board.enemy.discardPile)
            if card and not self:hasLootCard(card) then
                self:addLootCard(card)
            else
                i = i - 1
            end
            i = i + 1
        end
    end
    return self.lootCards
end
function Dealer.prototype.addLootCard(self, card)
    local ____self_lootCards_15 = self.lootCards
    ____self_lootCards_15[#____self_lootCards_15 + 1] = card
end
function Dealer.prototype.hasLootCard(self, card)
    for ____, lootCard in ipairs(self.lootCards) do
        if lootCard:isEqual(card) then
            return true
        end
    end
    return false
end
function Dealer.prototype.deselectLootCards(self)
    for ____, card in ipairs(self.lootCards) do
        card:onDiscard()
    end
end
function Dealer.prototype.addLootCardsToPlayer(self)
    for ____, card in ipairs(self.lootCards) do
        if card.isSelected then
            self.gameManager.player:addToDeck(card)
        end
    end
end
return ____exports
