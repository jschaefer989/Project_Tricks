import Card from "Cards/Card"
import { CharacterTypes } from "Enums"
import GameManager from "GameManager"

export default class Character {
    gameManager: GameManager
    deck: Card[]
    hand: Card[]
    discardPile: Card[]
    numberOfHeldCards: number
    type: CharacterTypes

    constructor(gameManager: GameManager, type: CharacterTypes) {
        this.gameManager = gameManager
        this.type = type
        this.deck = []
        this.hand = []
        this.discardPile = []
        this.numberOfHeldCards = 5
    }

    addToHand(card: Card): void {
        this.hand.push(card)
        this.gameManager.board?.cardAssets.appendAsset(card, this.type)        
    }

    getCardFromHand(position: number): Card | undefined {
        return this.hand[position]
    }

    addToDeck(card: Card): void {
        this.deck.push(card)
        this.gameManager.board?.cardAssets.hideCardAssets(card)
    }

    getCardFromDeck(position: number): Card | undefined {
        return this.deck[position]
    }

    addToDiscards(card: Card): void {
        this.discardPile.push(card)        
        this.gameManager.board?.cardAssets.hideCardAssets(card)
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
            card.onUnselect()
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
        const board = this.gameManager.board
        
        // Hide all card assets first without centering
        for (const card of this.hand) {
            this.deck.push(card)
            board?.cardAssets.hideCardAssets(card)
        }
        
        this.hand = []
    }
}