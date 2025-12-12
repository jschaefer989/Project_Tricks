/** @noSelfInFile */

import { Suits, Ranks, CharacterTypes } from "./Enums"
import { getRandomElementFromArray, getRandomElementFromEnum, isEmpty } from "./Helpers"
import Card from "./Card"
import GameManager from "./GameManager"

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
        Dealer.dealCards(this.gameManager, CharacterTypes.PLAYER)
        Dealer.dealCards(this.gameManager, CharacterTypes.ENEMY)
    }

    static initializePlayerDeck(gameManager: GameManager): void {
        // We're just gonna insert all of the cards into the player deck for now
        // Eventually, we might want to let players pick their starting cards and then they'll
        // add to their deck based on what they loot from fights and get from shops
        for (const suit of Object.values(Suits)) {
            for (const rank of Object.values(Ranks)) {
                gameManager.player.addToDeck(new Card(suit, rank))
            }
        }
        Dealer.shuffle(gameManager,CharacterTypes.PLAYER)
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

    static dealCards(gameManager: GameManager, characterType: string): void {
        const character = gameManager.getCharacter(characterType)
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
    }

    static getRandomCard(): Card {
            const suit = getRandomElementFromEnum(Suits)
            const rank = getRandomElementFromEnum(Ranks)
            return new Card(suit, rank)
    }

    initializeEnemyDeck(): void {
        if (!this.gameManager.board || !this.gameManager.board.enemy) {
            return
        }

        for (let i = 0; i < this.gameManager.board.enemy.numberOfCardsInDeck; i++) {
            this.gameManager.board.enemy.addToDeck(Dealer.getRandomCard())
        }
        Dealer.shuffle(this.gameManager, CharacterTypes.ENEMY)
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
            card.selected = false
        }
    }

    addLootCardsToPlayer(): void {
        for (const card of this.lootCards) {
            if (card.selected) {
                this.gameManager.player.addToDeck(card)
            }
        }
    }
}
