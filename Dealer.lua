require "Enums"
require "Card"
require "GameManager"
require "Helpers"

local object = require('Libraries.classic-master.classic')
Dealer = object:extend()

function Dealer:new()
    self.lootCards = {}
end

function Dealer:setup()
    self:initializeEnemyDeck()
    self:dealCards(CharacterTypes.PLAYER)
    self:dealCards(CharacterTypes.ENEMY)
end

function Dealer:initializePlayerDeck()
    -- We're just gonna insert all of the cards into the player deck for now
    -- Eventuall, we might want to let players pick their starting cards and then they'll
    -- add to their deck based on what they loot from fights and get from shops
    for suit in pairs(Suits) do
        for rank in pairs(Ranks) do
            Player:addToDeck(Card(suit, rank))
        end
    end
    self:shuffle(CharacterTypes.PLAYER)
end

function Dealer:initializeEnemyDeck()
    for i = 1, GameManager.board.enemy.numberOfCardsInDeck do
        local suit = getRandomElementFromTable(Suits)
        local rank = getRandomElementFromTable(Ranks)
        GameManager.board.enemy:addToDeck(Card(suit, rank))
    end
    self:shuffle(CharacterTypes.ENEMY)
end

function Dealer:shuffle(characterType)    
    local character = GameManager:getCharacter(characterType)
    for i = #character.deck, 2, -1 do
        local j = math.random(i)
        character.deck[i], character.deck[j] = character.deck[j], character.deck[i]
    end
end

function Dealer:dealCards(characterType)
    local character = GameManager:getCharacter(characterType)
    for i = 1, character.numberOfHeldCards - #character.hand do
        local card = table.remove(character.deck)
        character:addToHand(card)
    end
end

function Dealer:getLootCards()
    self.lootCards = {}
    for i = 1, Player.numberOfLootCards do
        local card = getRandomElementFromTable(GameManager.board.enemy.discardPile)
        if not self:hasLootCard(card) then
            self:addLootCard(card)
        else
            i = i - 1 -- try again
        end
    end
    return self.lootCards
end

function Dealer:addLootCard(card)
    table.insert(self.lootCards, card)
end

function Dealer:hasLootCard(card)
    for _, lootCard in ipairs(self.lootCards) do
        if lootCard:isEqual(card) then
            return true
        end
    end
    return false
end

function Dealer:deselectAllCards()
    for _, card in ipairs(self.lootCards) do
        card.selected = false
    end
end

function Dealer:addLootCardsToPlayer()
    for _, card in ipairs(self.lootCards) do
        if card.selected then 
            Player:addToDeck(card)
        end
    end
end
