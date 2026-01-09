local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Enums = require("Enums")
local Suits = ____Enums.Suits
local Ranks = ____Enums.Ranks
local CharacterTypes = ____Enums.CharacterTypes
local EdelRanks = ____Enums.EdelRanks
local AnimationIds = ____Enums.AnimationIds
local AssetIds = ____Enums.AssetIds
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
local getRandomElementFromArray = ____Helpers.getRandomElementFromArray
local getRandomElementFromEnum = ____Helpers.getRandomElementFromEnum
local isEmpty = ____Helpers.isEmpty
local ____Banner = require("Cards.Banner")
local Banner = ____Banner.default
local ____Deuce = require("Cards.Deuce")
local Deuce = ____Deuce.default
local ____Jester = require("Cards.Jester")
local Jester = ____Jester.default
local ____King = require("Cards.King")
local King = ____King.default
local ____Overlord = require("Cards.Overlord")
local Overlord = ____Overlord.default
local ____Priest = require("Cards.Priest")
local Priest = ____Priest.default
local ____Sergeant = require("Cards.Sergeant")
local Sergeant = ____Sergeant.default
local ____Thief = require("Cards.Thief")
local Thief = ____Thief.default
local ____Soldier = require("Cards.Soldier")
local Soldier = ____Soldier.default
local ____Bard = require("Cards.Bard")
local Bard = ____Bard.default
local ____Devil = require("Cards.Devil")
local Devil = ____Devil.default
local ____Duke = require("Cards.Duke")
local Duke = ____Duke.default
local ____Emperor = require("Cards.Emperor")
local Emperor = ____Emperor.default
local ____Knight = require("Cards.Knight")
local Knight = ____Knight.default
local push = require("Libraries.push")
local ____CardAssets = require("Assets.CardAssets")
local cardWidth = ____CardAssets.cardWidth
local cardHeight = ____CardAssets.cardHeight
local padding = ____CardAssets.padding
local ____SlideAnimation = require("Assets.Animations.SlideAnimation")
local SlideAnimation = ____SlideAnimation.default
local ____Pope = require("Cards.Pope")
local Pope = ____Pope.default
local ____Chosen = require("Cards.Chosen")
local Chosen = ____Chosen.default
local ____Baron = require("Cards.Baron")
local Baron = ____Baron.default
____exports.default = __TS__Class()
local Dealer = ____exports.default
Dealer.name = "Dealer"
function Dealer.prototype.____constructor(self, gameManager, board)
    self.gameManager = gameManager
    self.board = board
    self.lootCards = {}
end
function Dealer.prototype.setup(self)
    if #self.gameManager.player.deck == 0 then
        ____exports.default:initializePlayerDeck(self.gameManager)
    end
    self.gameManager.player:deselectAllCards()
    self:initializeEnemyDeck()
end
function Dealer.prototype.dealEdel(self)
    self:dealCards(CharacterTypes.PLAYER)
    self:dealCards(CharacterTypes.ENEMY)
    self:determineEdelSuit()
end
function Dealer.prototype.dealHandAtStartOfFight(self)
    local playerHandBefore = self:getCharacterHand(CharacterTypes.PLAYER)
    self:putCharacterHandBackInDeck(CharacterTypes.PLAYER)
    self:startReturnToDeckAnimation(
        CharacterTypes.PLAYER,
        playerHandBefore,
        function() return self:finishPlayerDeal() end
    )
end
function Dealer.prototype.dealAtStartOfFightForCharacter(self, character)
    self.board.cardAssets:disableAllCards(true)
    self:convertToEdelSuitForCharacter(character)
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
            gameManager.player:addToDeck(____exports.default:getNewCard(gameManager, rank, suit))
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
function Dealer.getNewCard(self, gameManager, rank, suit)
    repeat
        local ____switch26 = rank
        local ____cond26 = ____switch26 == Ranks.BANNER
        if ____cond26 then
            return __TS__New(Banner, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.BARON
        if ____cond26 then
            return __TS__New(Baron, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.DEUCE
        if ____cond26 then
            return __TS__New(Deuce, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.JESTER
        if ____cond26 then
            return __TS__New(Jester, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.KING
        if ____cond26 then
            return __TS__New(King, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.OVERLORD
        if ____cond26 then
            return __TS__New(Overlord, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.PRIEST
        if ____cond26 then
            return __TS__New(Priest, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.SERGEANT
        if ____cond26 then
            return __TS__New(Sergeant, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.THIEF
        if ____cond26 then
            return __TS__New(Thief, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == Ranks.SOLDIER
        if ____cond26 then
            return __TS__New(Soldier, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.BARD
        if ____cond26 then
            return __TS__New(Bard, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.DEVIL
        if ____cond26 then
            return __TS__New(Devil, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.DUKE
        if ____cond26 then
            return __TS__New(Duke, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.EMPEROR
        if ____cond26 then
            return __TS__New(Emperor, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.KNIGHT
        if ____cond26 then
            return __TS__New(Knight, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.POPE
        if ____cond26 then
            return __TS__New(Pope, gameManager, suit)
        end
        ____cond26 = ____cond26 or ____switch26 == EdelRanks.CHOSEN
        if ____cond26 then
            return __TS__New(Chosen, gameManager, suit)
        end
        do
            exhaustiveGuard(rank)
        end
    until true
end
function Dealer.getRandomCard(self, gameManager)
    local suit = getRandomElementFromEnum(Suits)
    local rank = getRandomElementFromEnum(Ranks)
    return ____exports.default:getNewCard(gameManager, rank, suit)
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
                    goto __continue31
                end
                local indexToUse = removedIndices and removedIndices[index + 1] or index
                character:addToHand(card, indexToUse)
                self.board.cardAssets:addAsset(card, deckPosition.x, deckPosition.y, characterType == CharacterTypes.PLAYER and not self.board.showingEdelView)
                local handPosition = self:getCardPointInHand(characterType, indexToUse, finalCardCount)
                self:startDealAnimation(characterType, card, handPosition.x, handPosition.y)
            end
            ::__continue31::
            index = index + 1
        end
    end
    self:redrawDeck(characterType)
end
function Dealer.prototype.redrawDeck(self, characterType)
    repeat
        local ____switch34 = characterType
        local ____cond34 = ____switch34 == CharacterTypes.PLAYER
        if ____cond34 then
            self.gameManager.assetManager:removeAssets(AssetIds.PLAYER_DECK)
            self.board:buildPlayerDeck()
            break
        end
        ____cond34 = ____cond34 or ____switch34 == CharacterTypes.ENEMY
        if ____cond34 then
            self.gameManager.assetManager:removeAssets(AssetIds.ENEMY_DECK)
            self.board:buildEnemyDeck()
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
        local ____switch38 = characterType
        local ____cond38 = ____switch38 == CharacterTypes.PLAYER
        if ____cond38 then
            return self.gameManager.player:discard()
        end
        ____cond38 = ____cond38 or ____switch38 == CharacterTypes.ENEMY
        if ____cond38 then
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
        local ____switch41 = characterType
        local ____cond41 = ____switch41 == CharacterTypes.PLAYER
        if ____cond41 then
            return {x = screenW - cardWidth - 5, y = portraitPosition or screenH - 5}
        end
        ____cond41 = ____cond41 or ____switch41 == CharacterTypes.ENEMY
        if ____cond41 then
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
    self.gameManager.animationManager.animations:set(
        AnimationIds.CARD_DEAL .. card.id,
        __TS__New(
            SlideAnimation,
            self.gameManager.settings.dealerSpeed,
            offsetX,
            offsetY,
            slideAssets,
            {
                waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds(),
                onFinish = self:getDealFinishMethod(characterType)
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
    self.board.cardAssets:disableAllCards(false)
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
            AnimationIds.CARD_DISCARD .. card.id,
            __TS__New(
                SlideAnimation,
                self.gameManager.settings.dealerSpeed,
                offsetX,
                offsetY,
                slideAssets,
                {
                    onFinish = function() return self:finishUpAnimation(card) end,
                    waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds()
                }
            )
        )
    end
end
function Dealer.prototype.getDiscardPosition(self, characterType)
    local screenH = push:getHeight()
    repeat
        local ____switch59 = characterType
        local ____cond59 = ____switch59 == CharacterTypes.PLAYER
        if ____cond59 then
            return screenH + cardHeight + 40
        end
        ____cond59 = ____cond59 or ____switch59 == CharacterTypes.ENEMY
        if ____cond59 then
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
            AnimationIds.CARD_RETURN_TO_DECK .. card.id,
            __TS__New(
                SlideAnimation,
                self.gameManager.settings.dealerSpeed,
                offsetX,
                offsetY,
                slideAssets,
                {
                    onFinish = function() return self:finishUpAnimation(card, onFinish) end,
                    waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds()
                }
            )
        )
    end
end
function Dealer.prototype.finishUpAnimation(self, card, onFinish)
    self.board.cardAssets:removeCardAssets(card)
    if not self.gameManager.animationManager:hasAnimations() then
        self.board.cardAssets:disableAllCards(false)
        if onFinish ~= nil then
            onFinish()
        end
    end
end
function Dealer.prototype.initializeEnemyDeck(self)
    do
        local i = 0
        while i < self.board.enemy.numberOfCardsInDeck do
            self.board.enemy:addToDeck(____exports.default:getRandomCard(self.gameManager))
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
            if index == 0 or card.power < lowestPower then
                lowestPower = card.power
                edelCard = card
            end
            index = index + 1
        end
    end
    for ____, card in ipairs(self.board.enemy.hand) do
        if card.power < lowestPower then
            lowestPower = card.power
            edelCard = card
        end
    end
    self.board.edelCard = edelCard
end
function Dealer.prototype.convertToEdelSuit(self, card)
    local ____card_suit_17 = card.suit
    local ____opt_15 = self.board.edelCard
    if ____card_suit_17 ~= (____opt_15 and ____opt_15.suit) then
        return card
    end
    repeat
        local ____switch78 = card.rank
        local ____cond78 = ____switch78 == Ranks.SOLDIER
        if ____cond78 then
            local ____Knight_21 = Knight
            local ____self_gameManager_20 = self.gameManager
            local ____opt_18 = self.board.edelCard
            return __TS__New(____Knight_21, ____self_gameManager_20, ____opt_18 and ____opt_18.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.BARON
        if ____cond78 then
            local ____Duke_25 = Duke
            local ____self_gameManager_24 = self.gameManager
            local ____opt_22 = self.board.edelCard
            return __TS__New(____Duke_25, ____self_gameManager_24, ____opt_22 and ____opt_22.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.JESTER
        if ____cond78 then
            local ____Bard_29 = Bard
            local ____self_gameManager_28 = self.gameManager
            local ____opt_26 = self.board.edelCard
            return __TS__New(____Bard_29, ____self_gameManager_28, ____opt_26 and ____opt_26.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.DEUCE
        if ____cond78 then
            local ____Emperor_33 = Emperor
            local ____self_gameManager_32 = self.gameManager
            local ____opt_30 = self.board.edelCard
            return __TS__New(____Emperor_33, ____self_gameManager_32, ____opt_30 and ____opt_30.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.PRIEST
        if ____cond78 then
            local ____Pope_37 = Pope
            local ____self_gameManager_36 = self.gameManager
            local ____opt_34 = self.board.edelCard
            return __TS__New(____Pope_37, ____self_gameManager_36, ____opt_34 and ____opt_34.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.THIEF
        if ____cond78 then
            local ____Devil_41 = Devil
            local ____self_gameManager_40 = self.gameManager
            local ____opt_38 = self.board.edelCard
            return __TS__New(____Devil_41, ____self_gameManager_40, ____opt_38 and ____opt_38.suit)
        end
        ____cond78 = ____cond78 or ____switch78 == Ranks.SERGEANT
        if ____cond78 then
            local ____Chosen_45 = Chosen
            local ____self_gameManager_44 = self.gameManager
            local ____opt_42 = self.board.edelCard
            return __TS__New(____Chosen_45, ____self_gameManager_44, ____opt_42 and ____opt_42.suit)
        end
        do
            return card
        end
    until true
end
function Dealer.prototype.convertToEdelSuitForCharacter(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    for ____, card in ipairs(character.deck) do
        do
            local ____card_suit_48 = card.suit
            local ____opt_46 = self.board.edelCard
            if ____card_suit_48 ~= (____opt_46 and ____opt_46.suit) then
                goto __continue81
            end
            local edelCard = self:convertToEdelSuit(card)
            if edelCard ~= card then
                character:removeFromDeck(card)
                character:addToDeck(edelCard)
            end
        end
        ::__continue81::
    end
end
function Dealer.prototype.convertBackToOriginalSuit(self, card)
    local ____card_suit_51 = card.suit
    local ____opt_49 = self.board.edelCard
    if ____card_suit_51 ~= (____opt_49 and ____opt_49.suit) then
        return card
    end
    repeat
        local ____switch87 = card.rank
        local ____cond87 = ____switch87 == EdelRanks.KNIGHT
        if ____cond87 then
            local ____Soldier_55 = Soldier
            local ____self_gameManager_54 = self.gameManager
            local ____opt_52 = self.board.edelCard
            return __TS__New(____Soldier_55, ____self_gameManager_54, ____opt_52 and ____opt_52.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.DUKE
        if ____cond87 then
            local ____Baron_59 = Baron
            local ____self_gameManager_58 = self.gameManager
            local ____opt_56 = self.board.edelCard
            return __TS__New(____Baron_59, ____self_gameManager_58, ____opt_56 and ____opt_56.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.BARD
        if ____cond87 then
            local ____Jester_63 = Jester
            local ____self_gameManager_62 = self.gameManager
            local ____opt_60 = self.board.edelCard
            return __TS__New(____Jester_63, ____self_gameManager_62, ____opt_60 and ____opt_60.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.EMPEROR
        if ____cond87 then
            local ____Deuce_67 = Deuce
            local ____self_gameManager_66 = self.gameManager
            local ____opt_64 = self.board.edelCard
            return __TS__New(____Deuce_67, ____self_gameManager_66, ____opt_64 and ____opt_64.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.POPE
        if ____cond87 then
            local ____Priest_71 = Priest
            local ____self_gameManager_70 = self.gameManager
            local ____opt_68 = self.board.edelCard
            return __TS__New(____Priest_71, ____self_gameManager_70, ____opt_68 and ____opt_68.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.DEVIL
        if ____cond87 then
            local ____Thief_75 = Thief
            local ____self_gameManager_74 = self.gameManager
            local ____opt_72 = self.board.edelCard
            return __TS__New(____Thief_75, ____self_gameManager_74, ____opt_72 and ____opt_72.suit)
        end
        ____cond87 = ____cond87 or ____switch87 == EdelRanks.CHOSEN
        if ____cond87 then
            local ____Sergeant_79 = Sergeant
            local ____self_gameManager_78 = self.gameManager
            local ____opt_76 = self.board.edelCard
            return __TS__New(____Sergeant_79, ____self_gameManager_78, ____opt_76 and ____opt_76.suit)
        end
        do
            return card
        end
    until true
end
function Dealer.prototype.convertBackToOriginalSuitForCharacter(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    for ____, edelCard in ipairs(character.deck) do
        do
            local ____edelCard_suit_82 = edelCard.suit
            local ____opt_80 = self.board.edelCard
            if ____edelCard_suit_82 ~= (____opt_80 and ____opt_80.suit) then
                goto __continue90
            end
            local originalCard = self:convertBackToOriginalSuit(edelCard)
            if originalCard ~= edelCard then
                character:removeFromDeck(edelCard)
                character:addToDeck(originalCard)
            end
        end
        ::__continue90::
    end
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
    local ____self_lootCards_83 = self.lootCards
    ____self_lootCards_83[#____self_lootCards_83 + 1] = card
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
        card:onUnselect()
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
