/** @noSelfInFile */

import Card from "Card"
import Character from "./Character"

export interface EnemyData {
    hand: Card[]
    deck: Card[]
    discardPile: Card[]
}

export default class Enemy extends Character {
    numberOfHeldCards: number
    numberOfCardsInDeck: number

    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super()
        this.numberOfHeldCards = numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = numberOfCardsInDeck ?? 9
    }

    save(): EnemyData {
      return {  
        hand: this.hand,
        deck: this.deck,
        discardPile: this.discardPile
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
}
