/** @noSelfInFile */

import Card from "Card"
import Character from "./Character"
import { EnemyTypes } from "Enums"

export interface EnemyData {
    hand: Card[]
    deck: Card[]
    discardPile: Card[]
    level: number
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    enemyType: EnemyTypes
}

export default class Enemy extends Character {
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    level: number
    enemyType: EnemyTypes

    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number, level?: number, enemyType?: EnemyTypes) {
        super()
        this.numberOfHeldCards = numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = numberOfCardsInDeck ?? 9
        this.level = level ?? 1
        this.enemyType = enemyType ?? EnemyTypes.GOBLIN
    }

    load(data?: EnemyData): void {
        this.hand = data?.hand ?? []
        this.deck = data?.deck ?? []
        this.discardPile = data?.discardPile ?? []
        this.level = data?.level ?? 1
        this.numberOfHeldCards = data?.numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = data?.numberOfCardsInDeck ?? 9
        this.enemyType = data?.enemyType ?? EnemyTypes.GOBLIN
    }

    save(): EnemyData {
      return {  
        hand: this.hand,
        deck: this.deck,
        discardPile: this.discardPile,
        level: this.level,
        numberOfHeldCards: this.numberOfHeldCards,
        numberOfCardsInDeck: this.numberOfCardsInDeck,
        enemyType: this.enemyType
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

    getEnemyName(): string {
        switch (this.enemyType) {
            case EnemyTypes.GOBLIN:
                return "Goblin"
            case EnemyTypes.ORC:
                return "Orc"
            case EnemyTypes.TROLL:
                return "Troll"
            case EnemyTypes.DRAGON:
                return "Dragon"
            default:
                return "Unknown"
        }
    }
}
