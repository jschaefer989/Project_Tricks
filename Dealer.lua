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
    self:dealCards(CharacterTypes.PLAYER)
    self:dealCards(CharacterTypes.ENEMY)
    self:determineEdelSuit()
end
function Dealer.prototype.startGame(self)
    self.gameManager.player:putHandBackInDeck()
    local ____opt_0 = self.gameManager.board
    if ____opt_0 ~= nil then
        ____opt_0.enemy:putHandBackInDeck()
    end
    self:convertToEdelSuitForCharacter(CharacterTypes.PLAYER)
    self:convertToEdelSuitForCharacter(CharacterTypes.ENEMY)
    ____exports.default:shuffle(self.gameManager, CharacterTypes.PLAYER)
    ____exports.default:shuffle(self.gameManager, CharacterTypes.ENEMY)
    self:dealCards(CharacterTypes.PLAYER)
    self:dealCards(CharacterTypes.ENEMY)
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
        local ____switch16 = rank
        local ____cond16 = ____switch16 == Ranks.BANNER
        if ____cond16 then
            return __TS__New(Banner, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.BARON
        if ____cond16 then
            return __TS__New(Baron, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.DEUCE
        if ____cond16 then
            return __TS__New(Deuce, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.JESTER
        if ____cond16 then
            return __TS__New(Jester, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.KING
        if ____cond16 then
            return __TS__New(King, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.OVERLORD
        if ____cond16 then
            return __TS__New(Overlord, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.PRIEST
        if ____cond16 then
            return __TS__New(Priest, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.SERGEANT
        if ____cond16 then
            return __TS__New(Sergeant, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.THIEF
        if ____cond16 then
            return __TS__New(Thief, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == Ranks.SOLDIER
        if ____cond16 then
            return __TS__New(Soldier, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.BARD
        if ____cond16 then
            return __TS__New(Bard, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.DEVIL
        if ____cond16 then
            return __TS__New(Devil, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.DUKE
        if ____cond16 then
            return __TS__New(Duke, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.EMPEROR
        if ____cond16 then
            return __TS__New(Emperor, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.KNIGHT
        if ____cond16 then
            return __TS__New(Knight, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.POPE
        if ____cond16 then
            return __TS__New(Pope, gameManager, suit)
        end
        ____cond16 = ____cond16 or ____switch16 == EdelRanks.CHOSEN
        if ____cond16 then
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
    do
        local i = 0
        while i < cardsToDeal do
            local card = table.remove(character.deck)
            if not isEmpty(card) then
                character:addToHand(card)
            end
            i = i + 1
        end
    end
    local ____opt_2 = self.gameManager.board
    if ____opt_2 ~= nil then
        ____opt_2.cardAssets:centerCards(characterType)
    end
    if characterType == CharacterTypes.ENEMY and not isEmpty(self.gameManager.board) then
        self.gameManager.board:addEnemyPower(self.gameManager.board.enemy:getCardPower())
        self.gameManager.board:addEnemyValue(self.gameManager.board.enemy:getCardValue())
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
    local edelSuit = Suits.HEARTS
    local lowestPower = 100
    do
        local index = 0
        while index < #player.hand do
            local card = player.hand[index + 1]
            if index == 0 or card.power < lowestPower then
                lowestPower = card.power
                edelSuit = card.suit
            end
            index = index + 1
        end
    end
    for ____, card in ipairs(self.gameManager.board.enemy.hand) do
        if card.power < lowestPower then
            lowestPower = card.power
            edelSuit = card.suit
        end
    end
    self.gameManager.board.edelSuit = edelSuit
end
function Dealer.prototype.convertToEdelSuit(self, card)
    if isEmpty(self.gameManager.board) then
        return card
    end
    if card.suit ~= self.gameManager.board.edelSuit then
        return card
    end
    repeat
        local ____switch39 = card.rank
        local ____cond39 = ____switch39 == Ranks.SOLDIER
        if ____cond39 then
            return __TS__New(Knight, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.BARON
        if ____cond39 then
            return __TS__New(Duke, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.JESTER
        if ____cond39 then
            return __TS__New(Bard, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.DEUCE
        if ____cond39 then
            return __TS__New(Emperor, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.PRIEST
        if ____cond39 then
            return __TS__New(Pope, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.THIEF
        if ____cond39 then
            return __TS__New(Devil, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond39 = ____cond39 or ____switch39 == Ranks.SERGEANT
        if ____cond39 then
            return __TS__New(Chosen, self.gameManager, self.gameManager.board.edelSuit)
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
            if card.suit ~= self.gameManager.board.edelSuit then
                goto __continue42
            end
            local edelCard = self:convertToEdelSuit(card)
            if edelCard ~= card then
                character:removeFromDeck(card)
                character:addToDeck(edelCard)
            end
        end
        ::__continue42::
    end
end
function Dealer.prototype.convertBackToOriginalSuit(self, card)
    if isEmpty(self.gameManager.board) then
        return card
    end
    if card.suit ~= self.gameManager.board.edelSuit then
        return card
    end
    repeat
        local ____switch49 = card.rank
        local ____cond49 = ____switch49 == EdelRanks.KNIGHT
        if ____cond49 then
            return __TS__New(Soldier, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.DUKE
        if ____cond49 then
            return __TS__New(Baron, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.BARD
        if ____cond49 then
            return __TS__New(Jester, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.EMPEROR
        if ____cond49 then
            return __TS__New(Deuce, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.POPE
        if ____cond49 then
            return __TS__New(Priest, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.DEVIL
        if ____cond49 then
            return __TS__New(Thief, self.gameManager, self.gameManager.board.edelSuit)
        end
        ____cond49 = ____cond49 or ____switch49 == EdelRanks.CHOSEN
        if ____cond49 then
            return __TS__New(Sergeant, self.gameManager, self.gameManager.board.edelSuit)
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
            if edelCard.suit ~= self.gameManager.board.edelSuit then
                goto __continue52
            end
            local originalCard = self:convertBackToOriginalSuit(edelCard)
            if originalCard ~= edelCard then
                character:removeFromDeck(edelCard)
                character:addToDeck(originalCard)
            end
        end
        ::__continue52::
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
    local ____self_lootCards_4 = self.lootCards
    ____self_lootCards_4[#____self_lootCards_4 + 1] = card
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
