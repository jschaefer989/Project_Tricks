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
function Dealer.prototype.dealHand(self)
    for ____, character in ipairs({CharacterTypes.PLAYER, CharacterTypes.ENEMY}) do
        self:putHandBackInDeck(character)
        self:convertToEdelSuitForCharacter(character)
        ____exports.default:shuffle(self.gameManager, character)
        self:dealCards(character)
    end
end
function Dealer.prototype.putHandBackInDeck(self, characterType)
    local handBefore = self:getCharacterHand(characterType)
    self:putCharacterHandBackInDeck(characterType)
    self:startReturnToDeckAnimation(characterType, handBefore)
end
function Dealer.prototype.getCharacterHand(self, characterType)
    repeat
        local ____switch11 = characterType
        local ____cond11 = ____switch11 == CharacterTypes.PLAYER
        if ____cond11 then
            return self.gameManager.player.hand
        end
        ____cond11 = ____cond11 or ____switch11 == CharacterTypes.ENEMY
        if ____cond11 then
            local ____opt_0 = self.gameManager.board
            return ____opt_0 and ____opt_0.enemy.hand or ({})
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.putCharacterHandBackInDeck(self, characterType)
    repeat
        local ____switch13 = characterType
        local ____cond13 = ____switch13 == CharacterTypes.PLAYER
        if ____cond13 then
            self.gameManager.player:putHandBackInDeck()
            break
        end
        ____cond13 = ____cond13 or ____switch13 == CharacterTypes.ENEMY
        if ____cond13 then
            local ____opt_2 = self.gameManager.board
            if ____opt_2 ~= nil then
                ____opt_2.enemy:putHandBackInDeck()
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
        local ____switch24 = rank
        local ____cond24 = ____switch24 == Ranks.BANNER
        if ____cond24 then
            return __TS__New(Banner, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.BARON
        if ____cond24 then
            return __TS__New(Baron, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.DEUCE
        if ____cond24 then
            return __TS__New(Deuce, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.JESTER
        if ____cond24 then
            return __TS__New(Jester, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.KING
        if ____cond24 then
            return __TS__New(King, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.OVERLORD
        if ____cond24 then
            return __TS__New(Overlord, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.PRIEST
        if ____cond24 then
            return __TS__New(Priest, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.SERGEANT
        if ____cond24 then
            return __TS__New(Sergeant, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.THIEF
        if ____cond24 then
            return __TS__New(Thief, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == Ranks.SOLDIER
        if ____cond24 then
            return __TS__New(Soldier, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.BARD
        if ____cond24 then
            return __TS__New(Bard, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.DEVIL
        if ____cond24 then
            return __TS__New(Devil, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.DUKE
        if ____cond24 then
            return __TS__New(Duke, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.EMPEROR
        if ____cond24 then
            return __TS__New(Emperor, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.KNIGHT
        if ____cond24 then
            return __TS__New(Knight, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.POPE
        if ____cond24 then
            return __TS__New(Pope, gameManager, suit)
        end
        ____cond24 = ____cond24 or ____switch24 == EdelRanks.CHOSEN
        if ____cond24 then
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
function Dealer.prototype.dealCards(self, characterType)
    local character = self.gameManager:getCharacter(characterType)
    if isEmpty(character) then
        return
    end
    local cardsToDeal = character.numberOfHeldCards - #character.hand
    local deckPosition = self:getDeckPosition(characterType)
    local finalCardCount = #character.hand + cardsToDeal
    local dealtCount = 0
    while dealtCount < cardsToDeal do
        local card = table.remove(character.deck)
        if isEmpty(card) then
            break
        end
        character:addToHand(card)
        dealtCount = dealtCount + 1
        local cardIndex = #character.hand - 1
        local finalPosition = self:getFinalCardPosition(characterType, cardIndex, finalCardCount)
        local ____opt_4 = self.gameManager.board
        if ____opt_4 ~= nil then
            ____opt_4.cardAssets:addAsset(card, deckPosition.x, deckPosition.y, characterType == CharacterTypes.PLAYER and not self.gameManager.board.showingEdelView)
        end
        self:startDealAnimation(card, finalPosition.x, finalPosition.y)
    end
    self:redrawDeck(characterType)
    if characterType == CharacterTypes.ENEMY and not isEmpty(self.gameManager.board) then
        self.gameManager.board:addEnemyPower(self.gameManager.board.enemy:getCardPower())
        self.gameManager.board:addEnemyValue(self.gameManager.board.enemy:getCardValue())
    end
end
function Dealer.prototype.redrawDeck(self, characterType)
    repeat
        local ____switch32 = characterType
        local ____cond32 = ____switch32 == CharacterTypes.PLAYER
        if ____cond32 then
            self.gameManager.assetManager:removeAssets(AssetIds.PLAYER_DECK)
            local ____opt_6 = self.gameManager.board
            if ____opt_6 ~= nil then
                ____opt_6:buildPlayerDeck()
            end
            break
        end
        ____cond32 = ____cond32 or ____switch32 == CharacterTypes.ENEMY
        if ____cond32 then
            self.gameManager.assetManager:removeAssets(AssetIds.ENEMY_DECK)
            local ____opt_8 = self.gameManager.board
            if ____opt_8 ~= nil then
                ____opt_8:buildEnemyDeck()
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
        return
    end
    for ____, card in ipairs(cards) do
        character:removeFromHand(card)
        character:addToDiscards(card)
    end
    self:startDiscardAnimation(characterType, cards)
end
function Dealer.prototype.dealNextRound(self)
    if isEmpty(self.gameManager.board) then
        return
    end
    for ____, card in ipairs(self.gameManager.player:getSelectedCards()) do
        self.gameManager.board.cardAssets:removeCardAssets(card)
    end
    self.gameManager.player:removeSelectedCardsFromHand()
    self:dealCards(CharacterTypes.PLAYER)
    for ____, card in ipairs(self.gameManager.board.enemy.hand) do
        self.gameManager.board.cardAssets:removeCardAssets(card)
    end
    local ____opt_10 = self.gameManager.board
    if ____opt_10 ~= nil then
        ____opt_10.enemy:removeAllCardsFromHand()
    end
    self:dealCards(CharacterTypes.ENEMY)
end
function Dealer.prototype.getDeckPosition(self, characterType)
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local ____opt_12 = self.gameManager.board
    local portraitPosition = ____opt_12 and ____opt_12:getPortraitPosition(characterType)
    repeat
        local ____switch44 = characterType
        local ____cond44 = ____switch44 == CharacterTypes.PLAYER
        if ____cond44 then
            return {x = screenW - 120, y = portraitPosition or screenH - 5}
        end
        ____cond44 = ____cond44 or ____switch44 == CharacterTypes.ENEMY
        if ____cond44 then
            return {x = screenW - 120, y = portraitPosition or 5}
        end
        do
            exhaustiveGuard(characterType)
        end
    until true
end
function Dealer.prototype.getFinalCardPosition(self, characterType, cardIndex, totalCardCount)
    local screenW = push:getWidth()
    local screenH = push:getHeight()
    local totalW = totalCardCount * cardWidth + math.max(0, totalCardCount - 1) * padding
    local startX = math.floor((screenW - totalW) / 2)
    local ____opt_14 = self.gameManager.board
    local cardY = ____opt_14 and ____opt_14.cardAssets:getCardPosition(characterType) or (characterType == CharacterTypes.PLAYER and screenH - cardHeight - 20 or 20)
    return {x = startX + cardIndex * (cardWidth + padding), y = cardY}
end
function Dealer.prototype.startDealAnimation(self, card, targetX, targetY)
    if isEmpty(self.gameManager.board) then
        return
    end
    local ____temp_16 = self.gameManager.board.cardAssets:getCardAssets(card)
    local baseAsset = ____temp_16.baseAsset
    local ____opt_17 = self.gameManager.board
    local slideAssets = ____opt_17 and ____opt_17.cardAssets:getCardAssetList(card)
    if #slideAssets == 0 then
        return
    end
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
                onFinish = self.gameManager.board.showingEdelView and (function()
                    local ____opt_23 = self.gameManager.board
                    return ____opt_23 and ____opt_23:displayEdel()
                end) or (function()
                    local ____opt_25 = self.gameManager.board
                    return ____opt_25 and ____opt_25:displayFight()
                end)
            }
        )
    )
end
function Dealer.prototype.startDiscardAnimation(self, characterType, cards)
    if isEmpty(self.gameManager.board) or #cards == 0 then
        return
    end
    local targetY = self:getDiscardPosition(characterType)
    for ____, card in ipairs(cards) do
        do
            local ____temp_27 = self.gameManager.board.cardAssets:getCardAssets(card)
            local baseAsset = ____temp_27.baseAsset
            local ____opt_28 = self.gameManager.board
            local slideAssets = ____opt_28 and ____opt_28.cardAssets:getCardAssetList(card)
            if #slideAssets == 0 then
                goto __continue53
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
        ::__continue53::
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
function Dealer.prototype.startReturnToDeckAnimation(self, characterType, cards)
    if isEmpty(self.gameManager.board) or #cards == 0 then
        return
    end
    local deckPosition = self:getDeckPosition(characterType)
    for ____, card in ipairs(cards) do
        do
            local ____temp_32 = self.gameManager.board.cardAssets:getCardAssets(card)
            local baseAsset = ____temp_32.baseAsset
            local ____opt_33 = self.gameManager.board
            local slideAssets = ____opt_33 and ____opt_33.cardAssets:getCardAssetList(card)
            if #slideAssets == 0 then
                goto __continue61
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
                        onFinish = function() return self:finishUpAnimation(card) end,
                        waitForAnimationIds = self.gameManager.animationManager:getCardAnimationIds()
                    }
                )
            )
        end
        ::__continue61::
    end
end
function Dealer.prototype.finishUpAnimation(self, card)
    local ____opt_39 = self.gameManager.board
    if ____opt_39 ~= nil then
        ____opt_39.cardAssets:removeCardAssets(card)
    end
    if not self.gameManager.animationManager.hasAnimations then
        local ____opt_41 = self.gameManager.board
        if ____opt_41 ~= nil then
            ____opt_41.cardAssets:disableAllCards(false)
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
    local ____card_suit_45 = card.suit
    local ____opt_43 = self.gameManager.board.edelCard
    if ____card_suit_45 ~= (____opt_43 and ____opt_43.suit) then
        return card
    end
    repeat
        local ____switch82 = card.rank
        local ____cond82 = ____switch82 == Ranks.SOLDIER
        if ____cond82 then
            local ____Knight_49 = Knight
            local ____self_gameManager_48 = self.gameManager
            local ____opt_46 = self.gameManager.board.edelCard
            return __TS__New(____Knight_49, ____self_gameManager_48, ____opt_46 and ____opt_46.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.BARON
        if ____cond82 then
            local ____Duke_53 = Duke
            local ____self_gameManager_52 = self.gameManager
            local ____opt_50 = self.gameManager.board.edelCard
            return __TS__New(____Duke_53, ____self_gameManager_52, ____opt_50 and ____opt_50.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.JESTER
        if ____cond82 then
            local ____Bard_57 = Bard
            local ____self_gameManager_56 = self.gameManager
            local ____opt_54 = self.gameManager.board.edelCard
            return __TS__New(____Bard_57, ____self_gameManager_56, ____opt_54 and ____opt_54.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.DEUCE
        if ____cond82 then
            local ____Emperor_61 = Emperor
            local ____self_gameManager_60 = self.gameManager
            local ____opt_58 = self.gameManager.board.edelCard
            return __TS__New(____Emperor_61, ____self_gameManager_60, ____opt_58 and ____opt_58.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.PRIEST
        if ____cond82 then
            local ____Pope_65 = Pope
            local ____self_gameManager_64 = self.gameManager
            local ____opt_62 = self.gameManager.board.edelCard
            return __TS__New(____Pope_65, ____self_gameManager_64, ____opt_62 and ____opt_62.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.THIEF
        if ____cond82 then
            local ____Devil_69 = Devil
            local ____self_gameManager_68 = self.gameManager
            local ____opt_66 = self.gameManager.board.edelCard
            return __TS__New(____Devil_69, ____self_gameManager_68, ____opt_66 and ____opt_66.suit)
        end
        ____cond82 = ____cond82 or ____switch82 == Ranks.SERGEANT
        if ____cond82 then
            local ____Chosen_73 = Chosen
            local ____self_gameManager_72 = self.gameManager
            local ____opt_70 = self.gameManager.board.edelCard
            return __TS__New(____Chosen_73, ____self_gameManager_72, ____opt_70 and ____opt_70.suit)
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
            local ____card_suit_76 = card.suit
            local ____opt_74 = self.gameManager.board.edelCard
            if ____card_suit_76 ~= (____opt_74 and ____opt_74.suit) then
                goto __continue85
            end
            local edelCard = self:convertToEdelSuit(card)
            if edelCard ~= card then
                character:removeFromDeck(card)
                character:addToDeck(edelCard)
            end
        end
        ::__continue85::
    end
end
function Dealer.prototype.convertBackToOriginalSuit(self, card)
    if isEmpty(self.gameManager.board) then
        return card
    end
    local ____card_suit_79 = card.suit
    local ____opt_77 = self.gameManager.board.edelCard
    if ____card_suit_79 ~= (____opt_77 and ____opt_77.suit) then
        return card
    end
    repeat
        local ____switch92 = card.rank
        local ____cond92 = ____switch92 == EdelRanks.KNIGHT
        if ____cond92 then
            local ____Soldier_83 = Soldier
            local ____self_gameManager_82 = self.gameManager
            local ____opt_80 = self.gameManager.board.edelCard
            return __TS__New(____Soldier_83, ____self_gameManager_82, ____opt_80 and ____opt_80.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.DUKE
        if ____cond92 then
            local ____Baron_87 = Baron
            local ____self_gameManager_86 = self.gameManager
            local ____opt_84 = self.gameManager.board.edelCard
            return __TS__New(____Baron_87, ____self_gameManager_86, ____opt_84 and ____opt_84.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.BARD
        if ____cond92 then
            local ____Jester_91 = Jester
            local ____self_gameManager_90 = self.gameManager
            local ____opt_88 = self.gameManager.board.edelCard
            return __TS__New(____Jester_91, ____self_gameManager_90, ____opt_88 and ____opt_88.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.EMPEROR
        if ____cond92 then
            local ____Deuce_95 = Deuce
            local ____self_gameManager_94 = self.gameManager
            local ____opt_92 = self.gameManager.board.edelCard
            return __TS__New(____Deuce_95, ____self_gameManager_94, ____opt_92 and ____opt_92.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.POPE
        if ____cond92 then
            local ____Priest_99 = Priest
            local ____self_gameManager_98 = self.gameManager
            local ____opt_96 = self.gameManager.board.edelCard
            return __TS__New(____Priest_99, ____self_gameManager_98, ____opt_96 and ____opt_96.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.DEVIL
        if ____cond92 then
            local ____Thief_103 = Thief
            local ____self_gameManager_102 = self.gameManager
            local ____opt_100 = self.gameManager.board.edelCard
            return __TS__New(____Thief_103, ____self_gameManager_102, ____opt_100 and ____opt_100.suit)
        end
        ____cond92 = ____cond92 or ____switch92 == EdelRanks.CHOSEN
        if ____cond92 then
            local ____Sergeant_107 = Sergeant
            local ____self_gameManager_106 = self.gameManager
            local ____opt_104 = self.gameManager.board.edelCard
            return __TS__New(____Sergeant_107, ____self_gameManager_106, ____opt_104 and ____opt_104.suit)
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
            local ____edelCard_suit_110 = edelCard.suit
            local ____opt_108 = self.gameManager.board.edelCard
            if ____edelCard_suit_110 ~= (____opt_108 and ____opt_108.suit) then
                goto __continue95
            end
            local originalCard = self:convertBackToOriginalSuit(edelCard)
            if originalCard ~= edelCard then
                character:removeFromDeck(edelCard)
                character:addToDeck(originalCard)
            end
        end
        ::__continue95::
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
    local ____self_lootCards_111 = self.lootCards
    ____self_lootCards_111[#____self_lootCards_111 + 1] = card
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
