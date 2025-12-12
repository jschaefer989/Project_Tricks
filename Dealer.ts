/** @noSelfInFile */

import { Suits, Ranks, CharacterTypes, TrumpRanks } from "./Enums"
import { exhaustiveGuard, getRandomElementFromArray, getRandomElementFromEnum, isEmpty } from "./Helpers"
import Card from "Cards/Card"
import Banner from "Cards/Banner"
import GameManager from "./GameManager"
import Deuce from "Cards/Deuce"
import Jester from "Cards/Jester"
import King from "Cards/King"
import Overlord from "Cards/Overlord"
import Priest from "Cards/Priest"
import Sergeant from "Cards/Sergeant"
import Thief from "Cards/Thief"
import Soldier from "Cards/Soldier"
import Bard from "Cards/Bard"
import Devil from "Cards/Devil"
import Duke from "Cards/Duke"
import Emperor from "Cards/Emperor"
import Knight from "Cards/Knight"
import Pope from "Cards/Pope"
import Trick from "Cards/Trick"
import Baron from "Cards/Baron"

export default class Dealer {
    gameManager: GameManager
    lootCards: Card[]    

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.lootCards = []
    }

    setup(): void {
        if (this.gameManager.player.deck.length === 0) {
            Dealer.initializePlayerDeck(this.gameManager)
        }
        this.gameManager.player.deselectAllCards()
        this.initializeEnemyDeck()
        this.dealCards(CharacterTypes.PLAYER)
        this.dealCards(CharacterTypes.ENEMY)
        this.determineTrumpSuit()
    }

    startGame(): void {
        this.gameManager.player.putHandBackInDeck()
        this.gameManager.board?.enemy.putHandBackInDeck()
        this.convertToTrumpSuitForCharacter(CharacterTypes.PLAYER)
        this.convertToTrumpSuitForCharacter(CharacterTypes.ENEMY)
        Dealer.shuffle(this.gameManager, CharacterTypes.PLAYER)
        Dealer.shuffle(this.gameManager, CharacterTypes.ENEMY)
        this.dealCards(CharacterTypes.PLAYER)
        this.dealCards(CharacterTypes.ENEMY)
    }

    // This needs to be static so it can be called when the player is initialized
    static initializePlayerDeck(gameManager: GameManager): void {
        // TODO: We're just gonna insert all of the cards into the player deck for now
        // Eventually, we might want to let players pick their starting cards and then they'll
        // add to their deck based on what they loot from fights and get from shops
        for (const suit of Object.values(Suits)) {
            for (const rank of Object.values(Ranks)) {
                gameManager.player.addToDeck(Dealer.getNewCard(gameManager, rank, suit))
            }
        }
        Dealer.shuffle(gameManager, CharacterTypes.PLAYER)
    }

    static shuffle(gameManager: GameManager, characterType: string): void {
        const character = gameManager.getCharacter(characterType)
        if (isEmpty(character)) {   
            return
        }

        for (let i = character.deck.length - 1; i >= 1; i--) {
            const j = Math.floor(Math.random() * (i + 1))
            const temp = character.deck[i]
            character.deck[i] = character.deck[j]
            character.deck[j] = temp
        }
    }

    static getNewCard(gameManager: GameManager, rank: Ranks | TrumpRanks, suit: Suits): Card {
        switch (rank) {
            case Ranks.BANNER:
                return new Banner(gameManager, suit)
            case Ranks.BARON:
                return new Baron(gameManager, suit)
            case Ranks.DEUCE:
                return new Deuce(gameManager, suit)
            case Ranks.JESTER:
                return new Jester(gameManager, suit)
            case Ranks.KING:
                return new King(gameManager, suit)
            case Ranks.OVERLORD:   
                return new Overlord(gameManager, suit)
            case Ranks.PRIEST:
                return new Priest(gameManager, suit)
            case Ranks.SERGEANT:
                return new Sergeant(gameManager, suit)
            case Ranks.THIEF:
                return new Thief(gameManager, suit)
            case Ranks.SOLDIER:
                return new Soldier(gameManager, suit)  
            case TrumpRanks.BARD:
                return new Bard(gameManager, suit)
            case TrumpRanks.DEVIL:
                return new Devil(gameManager, suit)
            case TrumpRanks.DUKE:
                return new Duke(gameManager, suit)
            case TrumpRanks.EMPEROR:
                return new Emperor(gameManager, suit)
            case TrumpRanks.KNIGHT:
                return new Knight(gameManager, suit)
            case TrumpRanks.POPE:
                return new Pope(gameManager, suit)
            case TrumpRanks.TRICK:
                return new Trick(gameManager, suit)
            default:
                exhaustiveGuard(rank)
        }
    }

    static getRandomCard(gameManager: GameManager): Card {
        const suit = getRandomElementFromEnum(Suits)
        const rank = getRandomElementFromEnum(Ranks)
        return Dealer.getNewCard(gameManager, rank, suit)
    }

    dealCards(characterType: string): void {
        const character = this.gameManager.getCharacter(characterType)
        if (isEmpty(character)) {   
            return
        }

        const cardsToDeal = character.numberOfHeldCards - character.hand.length
        for (let i = 0; i < cardsToDeal; i++) {
            const card = character.deck.pop()
            if (card) {
                character.addToHand(card)
            }
        }

        if (characterType === CharacterTypes.ENEMY && !isEmpty(this.gameManager.board)) {
            this.gameManager.board.enemyPower = this.gameManager.board.enemy.getCardPower()
            this.gameManager.board.enemyValue = this.gameManager.board.enemy.getCardValue()
        }
    }

    initializeEnemyDeck(): void {
        if (!this.gameManager.board || !this.gameManager.board.enemy) {
            return
        }

        for (let i = 0; i < this.gameManager.board.enemy.numberOfCardsInDeck; i++) {
            this.gameManager.board.enemy.addToDeck(Dealer.getRandomCard(this.gameManager))
        }
        Dealer.shuffle(this.gameManager, CharacterTypes.ENEMY)
    }

    determineTrumpSuit(): void {
        if (isEmpty(this.gameManager.board)) {
            return
        }

        const player = this.gameManager.player
        const cardsToDeal = player.numberOfHeldCards - player.hand.length
        let trumpSuit: Suits = Suits.HEARTS
        let lowestPower: number = 100
        for (let index = 0; index < cardsToDeal; index++) {
            const card = player.deck[index]
            if (index === 0 || card.power < lowestPower) {
                lowestPower = card.power
                trumpSuit = card.suit
            }
        }
        this.gameManager.board.trumpSuit = trumpSuit
    }

    convertToTrumpSuit(card: Card): Card {
        if (isEmpty(this.gameManager.board)) {
            return card
        }

        if (card.suit !== this.gameManager.board.trumpSuit) {
            return card
        }

        switch (card.rank) {
            case Ranks.SOLDIER:
                return new Knight(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.BARON:
                return new Duke(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.JESTER:
                return new Bard(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.DEUCE:
                return new Emperor(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.PRIEST:
                return new Pope(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.THIEF:
                return new Devil(this.gameManager, this.gameManager.board.trumpSuit)
            case Ranks.SERGEANT:
                return new Trick(this.gameManager, this.gameManager.board.trumpSuit)
            default:
                return card
        }
    }

    convertToTrumpSuitForCharacter(characterType: string): void {
        const character = this.gameManager.getCharacter(characterType)

        if (isEmpty(character) || isEmpty(this.gameManager.board)) {
            return
        }

        for (const card of character.deck) {
            if (card.suit !== this.gameManager.board.trumpSuit) {
                continue
            }
            const trumpCard = this.convertToTrumpSuit(card)
            if (trumpCard !== card) {
                character.removeFromDeck(card)
                character.addToDeck(trumpCard)
            }
        }
    }

    convertBackToOriginalSuit(card: Card): Card {
        if (isEmpty(this.gameManager.board)) {
            return card
        }

        if (card.suit !== this.gameManager.board.trumpSuit) {
            return card
        }

        switch (card.rank) {
            case TrumpRanks.KNIGHT:
                return new Soldier(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.DUKE:
                return new Baron(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.BARD:
                return new Jester(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.EMPEROR:
                return new Deuce(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.POPE:
                return new Priest(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.DEVIL:
                return new Thief(this.gameManager, this.gameManager.board.trumpSuit)
            case TrumpRanks.TRICK:
                return new Sergeant(this.gameManager, this.gameManager.board.trumpSuit)
            default:
                return card
        }
    }

    convertBackToOriginalSuitForCharacter(characterType: string): void {
        const character = this.gameManager.getCharacter(characterType)

        if (isEmpty(character) || isEmpty(this.gameManager.board)) {
            return
        }

        for (const trumpCard of character.deck) {
            if (trumpCard.suit !== this.gameManager.board.trumpSuit) {
                continue
            }
            const originalCard = this.convertBackToOriginalSuit(trumpCard)
            if (originalCard !== trumpCard) {
                character.removeFromDeck(trumpCard)
                character.addToDeck(originalCard)
            }
        }
    }

    getLootCards(): Card[] {
        if (!this.gameManager.board || !this.gameManager.board.enemy) {
            return []
        }

        this.lootCards = []
        for (let i = 0; i < this.gameManager.player.numberOfLootCards; i++) {
            const card = getRandomElementFromArray(this.gameManager.board.enemy.discardPile) as Card | undefined
            if (card && !this.hasLootCard(card)) {
                this.addLootCard(card)
            } else {
                i-- // try again
            }
        }
        return this.lootCards
    }

    addLootCard(card: Card): void {
        this.lootCards.push(card)
    }

    hasLootCard(card: Card): boolean {
        for (const lootCard of this.lootCards) {
            if (lootCard.isEqual(card)) {
                return true
            }
        }
        return false
    }

    deselectLootCards(): void {
        for (const card of this.lootCards) {
            card.isSelected = false
        }
    }

    addLootCardsToPlayer(): void {
        for (const card of this.lootCards) {
            if (card.isSelected) {
                this.gameManager.player.addToDeck(card)
            }
        }
    }
}
