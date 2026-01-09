local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectValues = ____lualib.__TS__ObjectValues
local __TS__New = ____lualib.__TS__New
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
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
function Dealer.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
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
    local ____opt_0 = self.gameManager.board
    if ____opt_0 ~= nil then
        ____opt_0.cardAssets:disableAllCards(true)
    end
    self:convertToEdelSuitForCharacter(character)
    ____exports.default:shuffle(self.gameManager, character)
    self:dealCards(character)
    if character == CharacterTypes.ENEMY then
        local ____opt_2 = self.gameManager.board
        if ____opt_2 ~= nil then
            ____opt_2:tallyEnemyPowerAndValue()
        end
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
            local ____opt_4 = self.gameManager.board
            return ____opt_4 and ____opt_4.enemy.hand or ({})
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
            local ____opt_6 = self.gameManager.board
            if ____opt_6 ~= nil then
                ____opt_6.enemy:putHandBackInDeck()
            end
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
    local dealCount = 0
    do
        local index = 0
        while index < cardsToDeal do
            local card = table.remove(character.deck)
            if isEmpty(card) then
                error(
                    __TS__New(Error, "Not enough cards in deck to deal for " .. characterType),
                    0
                )
            end
            local indexToUse = removedIndices and removedIndices[index + 1] or index
            character:addToHand(card, indexToUse)
            local ____opt_8 = self.gameManager.board
            if ____opt_8 ~= nil then
                ____opt_8.cardAssets:addAsset(card, deckPosition.x, deckPosition.y, characterType == CharacterTypes.PLAYER and not self.gameManager.board.showingEdelView)
            end
            local handPosition = self:getCardPointInHand(characterType, indexToUse, finalCardCount)
            self:startDealAnimation(characterType, card, handPosition.x, handPosition.y)
            dealCount = dealCount + 1
            index = index + 1
        end
    end
    if dealCount < cardsToDeal then
        error(
            __TS__New(
                Error,
                (((("Dealt fewer cards (" .. tostring(dealCount)) .. ") than expected (") .. tostring(cardsToDeal)) .. ") for ") .. characterType
            ),
            0
        )
    end
    self:redrawDeck(characterType)
end
function Dealer.prototype.redrawDeck(self, characterType)
    repeat
        local ____switch35 = characterType
        local ____cond35 = ____switch35 == CharacterTypes.PLAYER
        if ____cond35 then
            self.gameManager.assetManager:removeAssets(AssetIds.PLAYER_DECK)
            local ____opt_10 = self.gameManager.board
            if ____opt_10 ~= nil then
                ____opt_10:buildPlayerDeck()
            end
            break
        end
        ____cond35 = ____cond35 or ____switch35 == CharacterTypes.ENEMY
        if ____cond35 then
            self.gameManager.assetManager:removeAssets(AssetIds.ENEMY_DECK)
            local ____opt_12 = self.gameManager.board
            if ____opt_12 ~= nil then
                ____opt_12:buildEnemyDeck()
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
        local ____switch39 = characterType
        local ____cond39 = ____switch39 == CharacterTypes.PLAYER
        if ____cond39 then
            return self.gameManager.player:discard()
        end
        ____cond39 = ____cond39 or ____switch39 == CharacterTypes.ENEMY
        if ____cond39 then
            local ____opt_14 = self.gameManager.board
            return ____opt_14 and ____opt_14.enemy:discard() or ({})
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.dealNextHand(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    local playerIndices = self:discardCards(
        CharacterTypes.PLAYER,
        self.gameManager.player:getSelectedCards()
    )
    self:dealCards(CharacterTypes.PLAYER, playerIndices)
    local enemyIndices = self:discardCards(CharacterTypes.ENEMY, self.gameManager.board.enemy.hand or ({}))
    self:dealCards(CharacterTypes.ENEMY, enemyIndices)
end
function Dealer.prototype.getDeckPosition(self, characterType)
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local ____opt_16 = self.gameManager.board
    local portraitPosition = ____opt_16 and ____opt_16:getPortraitPosition(characterType)
    repeat
        local ____switch43 = characterType
        local ____cond43 = ____switch43 == CharacterTypes.PLAYER
        if ____cond43 then
            return {x = screenW - cardWidth - 5, y = portraitPosition or screenH - 5}
        end
        ____cond43 = ____cond43 or ____switch43 == CharacterTypes.ENEMY
        if ____cond43 then
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
    local ____opt_18 = self.gameManager.board
    local cardY = ____opt_18 and ____opt_18.cardAssets:getHandYCoordinate(characterType) or (characterType == CharacterTypes.PLAYER and screenH - cardHeight - 20 or 20)
    return {x = startX + cardIndex * individualCardWidth, y = cardY}
end
function Dealer.prototype.startDealAnimation(self, characterType, card, targetX, targetY)
    if isEmpty(self.gameManager.board) then
        error(
            __TS__New(Error, "Board is not initialized"),
            0
        )
    end
    local ____temp_20 = self.gameManager.board.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_20.baseAsset
    local ____opt_21 = self.gameManager.board
    local slideAssets = ____opt_21 and ____opt_21.cardAssets:getCardAssetList(card)
    if #slideAssets == 0 then
        error(
            __TS__New(Error, "No assets found for card animation"),
            0
        )
    end
    local startX = baseAsset and baseAsset.x or 0
    local startY = baseAsset and baseAsset.y or 0
    local offsetX = targetX - startX
    local offsetY = targetY - startY
    if offsetX == 0 and offsetY == 0 then
        error(
            __TS__New(Error, "Card is already at target position"),
            0
        )
    end
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
    local ____opt_27 = self.gameManager.board
    if ____opt_27 and ____opt_27.showingEdelView then
        return function()
            local ____opt_29 = self.gameManager.board
            return ____opt_29 and ____opt_29:displayEdel()
        end
    else
        local ____opt_31 = self.gameManager.board
        local ____temp_35 = (____opt_31 and ____opt_31.playerPoints) == 0
        if ____temp_35 then
            local ____opt_33 = self.gameManager.board
            ____temp_35 = (____opt_33 and ____opt_33.enemyPoints) == 0
        end
        if ____temp_35 then
            return function()
                local ____opt_36 = self.gameManager.board
                return ____opt_36 and ____opt_36:displayFight()
            end
        else
            return function() return self:finishDeal(characterType) end
        end
    end
end
function Dealer.prototype.finishDeal(self, characterType)
    if self.gameManager.animationManager:hasAnimations() then
        return
    end
    local ____opt_38 = self.gameManager.board
    if ____opt_38 ~= nil then
        ____opt_38.cardAssets:disableAllCards(false)
    end
    if characterType == CharacterTypes.ENEMY then
        local ____opt_40 = self.gameManager.board
        if ____opt_40 ~= nil then
            ____opt_40:tallyEnemyPowerAndValue()
        end
    end
end
function Dealer.prototype.startDiscardAnimation(self, characterType, cards)
    if isEmpty(self.gameManager.board) or #cards == 0 then
        return
    end
    local targetY = self:getDiscardPosition(characterType)
    for ____, card in ipairs(cards) do
        do
            local ____temp_42 = self.gameManager.board.cardAssets:getCardAssets(card)
            local baseAsset = ____temp_42.baseAsset
            local ____opt_43 = self.gameManager.board
            local slideAssets = ____opt_43 and ____opt_43.cardAssets:getCardAssetList(card)
            if #slideAssets == 0 then
                goto __continue61
            end
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
        ::__continue61::
    end
end
function Dealer.prototype.getDiscardPosition(self, characterType)
    local screenH = push:getHeight()
    repeat
        local ____switch66 = characterType
        local ____cond66 = ____switch66 == CharacterTypes.PLAYER
        if ____cond66 then
            return screenH + cardHeight + 40
        end
        ____cond66 = ____cond66 or ____switch66 == CharacterTypes.ENEMY
        if ____cond66 then
            return -cardHeight - 40
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.startReturnToDeckAnimation(self, characterType, cards, onFinish)
    if isEmpty(self.gameManager.board) or #cards == 0 then
        return
    end
    local deckPosition = self:getDeckPosition(characterType)
    for ____, card in ipairs(cards) do
        do
            local ____temp_47 = self.gameManager.board.cardAssets:getCardAssets(card)
            local baseAsset = ____temp_47.baseAsset
            local ____opt_48 = self.gameManager.board
            local slideAssets = ____opt_48 and ____opt_48.cardAssets:getCardAssetList(card)
            if #slideAssets == 0 then
                goto __continue69
            end
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
        ::__continue69::
    end
end
function Dealer.prototype.finishUpAnimation(self, card, onFinish)
    local ____opt_54 = self.gameManager.board
    if ____opt_54 ~= nil then
        ____opt_54.cardAssets:removeCardAssets(card)
    end
    if not self.gameManager.animationManager:hasAnimations() then
        local ____opt_56 = self.gameManager.board
        if ____opt_56 ~= nil then
            ____opt_56.cardAssets:disableAllCards(false)
        end
        if onFinish ~= nil then
            onFinish()
        end
    end
end
function Dealer.prototype.initializeEnemyDeck(self)
    if not self.gameManager.board or not self.gameManager.board.enemy then
        return
    end
    do
        local i = 0
        while i < self.gameManager.board.enemy.numberOfCardsInDeck do
            self.gameManager.board.enemy:addToDeck(____exports.default:getRandomCard(self.gameManager))
            i = i + 1
        end
    end
    ____exports.default:shuffle(self.gameManager, CharacterTypes.ENEMY)
end
function Dealer.prototype.determineEdelSuit(self)
    if isEmpty(self.gameManager.board) then
        return
    end
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
    for ____, card in ipairs(self.gameManager.board.enemy.hand) do
        if card.power < lowestPower then
            lowestPower = card.power
            edelCard = card
        end
    end
    self.gameManager.board.edelCard = edelCard
end
function Dealer.prototype.convertToEdelSuit(self, card)
    if isEmpty(self.gameManager.board) then
        return card
    end
    local ____card_suit_62 = card.suit
    local ____opt_60 = self.gameManager.board.edelCard
    if ____card_suit_62 ~= (____opt_60 and ____opt_60.suit) then
        return card
    end
    repeat
        local ____switch90 = card.rank
        local ____cond90 = ____switch90 == Ranks.SOLDIER
        if ____cond90 then
            local ____Knight_66 = Knight
            local ____self_gameManager_65 = self.gameManager
            local ____opt_63 = self.gameManager.board.edelCard
            return __TS__New(____Knight_66, ____self_gameManager_65, ____opt_63 and ____opt_63.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.BARON
        if ____cond90 then
            local ____Duke_70 = Duke
            local ____self_gameManager_69 = self.gameManager
            local ____opt_67 = self.gameManager.board.edelCard
            return __TS__New(____Duke_70, ____self_gameManager_69, ____opt_67 and ____opt_67.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.JESTER
        if ____cond90 then
            local ____Bard_74 = Bard
            local ____self_gameManager_73 = self.gameManager
            local ____opt_71 = self.gameManager.board.edelCard
            return __TS__New(____Bard_74, ____self_gameManager_73, ____opt_71 and ____opt_71.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.DEUCE
        if ____cond90 then
            local ____Emperor_78 = Emperor
            local ____self_gameManager_77 = self.gameManager
            local ____opt_75 = self.gameManager.board.edelCard
            return __TS__New(____Emperor_78, ____self_gameManager_77, ____opt_75 and ____opt_75.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.PRIEST
        if ____cond90 then
            local ____Pope_82 = Pope
            local ____self_gameManager_81 = self.gameManager
            local ____opt_79 = self.gameManager.board.edelCard
            return __TS__New(____Pope_82, ____self_gameManager_81, ____opt_79 and ____opt_79.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.THIEF
        if ____cond90 then
            local ____Devil_86 = Devil
            local ____self_gameManager_85 = self.gameManager
            local ____opt_83 = self.gameManager.board.edelCard
            return __TS__New(____Devil_86, ____self_gameManager_85, ____opt_83 and ____opt_83.suit)
        end
        ____cond90 = ____cond90 or ____switch90 == Ranks.SERGEANT
        if ____cond90 then
            local ____Chosen_90 = Chosen
            local ____self_gameManager_89 = self.gameManager
            local ____opt_87 = self.gameManager.board.edelCard
            return __TS__New(____Chosen_90, ____self_gameManager_89, ____opt_87 and ____opt_87.suit)
        end
        do
            return card
        end
    until true
end
function Dealer.prototype.convertToEdelSuitForCharacter(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) or isEmpty(self.gameManager.board) then
        return
    end
    for ____, card in ipairs(character.deck) do
        do
            local ____card_suit_93 = card.suit
            local ____opt_91 = self.gameManager.board.edelCard
            if ____card_suit_93 ~= (____opt_91 and ____opt_91.suit) then
                goto __continue93
            end
            local edelCard = self:convertToEdelSuit(card)
            if edelCard ~= card then
                character:removeFromDeck(card)
                character:addToDeck(edelCard)
            end
        end
        ::__continue93::
    end
end
function Dealer.prototype.convertBackToOriginalSuit(self, card)
    if isEmpty(self.gameManager.board) then
        return card
    end
    local ____card_suit_96 = card.suit
    local ____opt_94 = self.gameManager.board.edelCard
    if ____card_suit_96 ~= (____opt_94 and ____opt_94.suit) then
        return card
    end
    repeat
        local ____switch100 = card.rank
        local ____cond100 = ____switch100 == EdelRanks.KNIGHT
        if ____cond100 then
            local ____Soldier_100 = Soldier
            local ____self_gameManager_99 = self.gameManager
            local ____opt_97 = self.gameManager.board.edelCard
            return __TS__New(____Soldier_100, ____self_gameManager_99, ____opt_97 and ____opt_97.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.DUKE
        if ____cond100 then
            local ____Baron_104 = Baron
            local ____self_gameManager_103 = self.gameManager
            local ____opt_101 = self.gameManager.board.edelCard
            return __TS__New(____Baron_104, ____self_gameManager_103, ____opt_101 and ____opt_101.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.BARD
        if ____cond100 then
            local ____Jester_108 = Jester
            local ____self_gameManager_107 = self.gameManager
            local ____opt_105 = self.gameManager.board.edelCard
            return __TS__New(____Jester_108, ____self_gameManager_107, ____opt_105 and ____opt_105.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.EMPEROR
        if ____cond100 then
            local ____Deuce_112 = Deuce
            local ____self_gameManager_111 = self.gameManager
            local ____opt_109 = self.gameManager.board.edelCard
            return __TS__New(____Deuce_112, ____self_gameManager_111, ____opt_109 and ____opt_109.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.POPE
        if ____cond100 then
            local ____Priest_116 = Priest
            local ____self_gameManager_115 = self.gameManager
            local ____opt_113 = self.gameManager.board.edelCard
            return __TS__New(____Priest_116, ____self_gameManager_115, ____opt_113 and ____opt_113.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.DEVIL
        if ____cond100 then
            local ____Thief_120 = Thief
            local ____self_gameManager_119 = self.gameManager
            local ____opt_117 = self.gameManager.board.edelCard
            return __TS__New(____Thief_120, ____self_gameManager_119, ____opt_117 and ____opt_117.suit)
        end
        ____cond100 = ____cond100 or ____switch100 == EdelRanks.CHOSEN
        if ____cond100 then
            local ____Sergeant_124 = Sergeant
            local ____self_gameManager_123 = self.gameManager
            local ____opt_121 = self.gameManager.board.edelCard
            return __TS__New(____Sergeant_124, ____self_gameManager_123, ____opt_121 and ____opt_121.suit)
        end
        do
            return card
        end
    until true
end
function Dealer.prototype.convertBackToOriginalSuitForCharacter(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) or isEmpty(self.gameManager.board) then
        return
    end
    for ____, edelCard in ipairs(character.deck) do
        do
            local ____edelCard_suit_127 = edelCard.suit
            local ____opt_125 = self.gameManager.board.edelCard
            if ____edelCard_suit_127 ~= (____opt_125 and ____opt_125.suit) then
                goto __continue103
            end
            local originalCard = self:convertBackToOriginalSuit(edelCard)
            if originalCard ~= edelCard then
                character:removeFromDeck(edelCard)
                character:addToDeck(originalCard)
            end
        end
        ::__continue103::
    end
end
function Dealer.prototype.getLootCards(self)
    if not self.gameManager.board or not self.gameManager.board.enemy then
        return {}
    end
    self.lootCards = {}
    do
        local i = 0
        while i < self.gameManager.player.numberOfLootCards do
            local card = getRandomElementFromArray(self.gameManager.board.enemy.discardPile)
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
    local ____self_lootCards_128 = self.lootCards
    ____self_lootCards_128[#____self_lootCards_128 + 1] = card
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
