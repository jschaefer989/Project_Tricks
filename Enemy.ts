/** @noSelfInFile */

import Card from "Card"
import Character from "./Character"
import { EnemyTypes } from "Enums"
import { exhaustiveGuard } from "Helpers"

export interface EnemyData {
    hand: Card[]
    deck: Card[]
    discardPile: Card[]
    level: number
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    enemyType: EnemyTypes
    experience: number
}

export default class Enemy extends Character {
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    level: number
    enemyType: EnemyTypes
    experience: number

    constructor(numberOfHeldCards?: number, numberOfCardsInDeck?: number, level?: number, enemyType?: EnemyTypes, experience?: number) {
        super()
        this.numberOfHeldCards = numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = numberOfCardsInDeck ?? 9
        this.level = level ?? 1
        this.enemyType = enemyType ?? EnemyTypes.GOBLIN
        this.experience = experience ?? this.getExpeierenceReward()
    }

    load(data?: EnemyData): void {
        this.hand = data?.hand ?? []
        this.deck = data?.deck ?? []
        this.discardPile = data?.discardPile ?? []
        this.level = data?.level ?? 1
        this.numberOfHeldCards = data?.numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = data?.numberOfCardsInDeck ?? 9
        this.enemyType = data?.enemyType ?? EnemyTypes.GOBLIN
        this.experience = data?.experience ?? this.getExpeierenceReward()
    }

    save(): EnemyData {
      return {  
        hand: this.hand,
        deck: this.deck,
        discardPile: this.discardPile,
        level: this.level,
        numberOfHeldCards: this.numberOfHeldCards,
        numberOfCardsInDeck: this.numberOfCardsInDeck,
        enemyType: this.enemyType,
        experience: this.experience
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
                exhaustiveGuard(this.enemyType)
        }
    }

    getExpeierenceReward(): number {
        switch (this.enemyType) {
            case EnemyTypes.GOBLIN:
                return 10 * this.level
            case EnemyTypes.ORC:
                return 20 * this.level
            case EnemyTypes.TROLL:
                return 30 * this.level
            case EnemyTypes.DRAGON:
                return 50 * this.level
            default:
                exhaustiveGuard(this.enemyType)
        }
    }
}
