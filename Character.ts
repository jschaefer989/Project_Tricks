import Card from "Cards/Card"
import GameManager from "GameManager"
import { isEmpty } from "Helpers"

export default class Character {
    gameManager: GameManager
    deck: Card[]
    hand: Card[]
    discardPile: Card[]
    numberOfHeldCards: number

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.deck = []
        this.hand = []
        this.discardPile = []
        this.numberOfHeldCards = 5
    }

    addToHand(card: Card): void {
        this.hand.push(card)
        const board = this.gameManager.board
        if (!isEmpty(board)) {
            board.cardAssets.appendAsset(card)
            board.cardAssets.centerCards()
        }
    }

    getCardFromHand(position: number): Card | undefined {
        return this.hand[position]
    }

    addToDeck(card: Card): void {
        card.id = `${card.suit}-${card.rank}-${this.deck.length}`
        this.deck.push(card)
    }

    getCardFromDeck(position: number): Card | undefined {
        return this.deck[position]
    }

    addToDiscards(card: Card): void {
        this.discardPile.push(card)
        const board = this.gameManager.board
        if (!isEmpty(board)) {
            board.cardAssets.hideCardAssets(card)
            board.cardAssets.centerCards()
        }
    }

    getCardFromDiscards(position: number): Card | undefined {
        return this.discardPile[position]
    }

    addDiscardsToDeck(): void {
        for (const card of this.discardPile) {
            this.addToDeck(card)
        }
        this.discardPile = []
    }

    deselectAllCards(): void {
        for (const card of this.hand) {
            card.isSelected = false
        }
    }

    getCardPower(): number {
        let power = 0
        for (const card of this.hand) {
            power += card.power
        }
        return power
    }

    getCardValue(): number {
        let value = 0
        for (const card of this.hand) {
            value += card.value
        }
        return value
    }

    removeAllCardsFromHand(): void {
        for (let i = this.hand.length - 1; i >= 0; i--) {
            const card = this.hand[i]
            this.addToDiscards(card)
            this.hand.splice(i, 1)
        }
    }

    removeFromDeck(card: Card): void {      
        for (let index = 0; index < this.deck.length; index++) {
            const otherCard = this.deck[index]
            if (card.isEqual(otherCard)) {
                this.deck.splice(index, 1)
            }
        }
    }

    putHandBackInDeck(): void {
        for (const card of this.hand) {
            this.addToDeck(card)
        }
        this.removeAllCardsFromHand()
    }
}