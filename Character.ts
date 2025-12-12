import Card from "Cards/Card"

export default class Character {
    deck: Card[]
    hand: Card[]
    discardPile: Card[]
    numberOfHeldCards: number

    constructor() {
        this.deck = []
        this.hand = []
        this.discardPile = []
        this.numberOfHeldCards = 5
    }

    addToHand(card: Card): void {
        this.hand.push(card)
    }

    getCardFromHand(position: number): Card | undefined {
        return this.hand[position]
    }

    addToDeck(card: Card): void {
        this.deck.push(card)
    }

    getCardFromDeck(position: number): Card | undefined {
        return this.deck[position]
    }

    addToDiscards(card: Card): void {
        this.discardPile.push(card)
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
            card.selected = false
        }
    }
}
