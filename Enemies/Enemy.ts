/** @noSelfInFile */

import Card from "Cards/Card"
import Character from "../Character"
import { EnemyTypes } from "Enums"
import GameManager from "GameManager"

interface CardData {
    id: string
    suit: any
    rank: any
    power: number
    value: number
    isSelected: boolean
    cost: number
    isTrump: boolean
    name: string
}

export interface EnemyData {
    hand: CardData[]
    deck: CardData[]
    discardPile: CardData[]
    level: number
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    enemyType: EnemyTypes
    experience: number
}

export default class Enemy extends Character {
    gameManager?: GameManager
    numberOfHeldCards: number
    numberOfCardsInDeck: number
    level: number
    enemyType: EnemyTypes
    experience: number
    name: string

    constructor(level?: number, enemyType?: EnemyTypes, experience?: number, name?: string, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super()
        this.numberOfHeldCards = numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = numberOfCardsInDeck ?? 9
        this.level = level ?? 1
        this.enemyType = enemyType ?? EnemyTypes.KOBOLD
        this.experience = experience ?? 0
        this.name = name ?? "Enemy"
    }

    load(gameManager: GameManager, data?: EnemyData): void {
        this.gameManager = gameManager
        this.hand = data?.hand ? data.hand.map(cardData => Card.load(gameManager, cardData)) : []
        this.deck = data?.deck ? data.deck.map(cardData => Card.load(gameManager, cardData)) : []
        this.discardPile = data?.discardPile ? data.discardPile.map(cardData => Card.load(gameManager, cardData)) : []
        this.level = data?.level ?? 1
        this.numberOfHeldCards = data?.numberOfHeldCards ?? 3
        this.numberOfCardsInDeck = data?.numberOfCardsInDeck ?? 9
        this.enemyType = data?.enemyType ?? EnemyTypes.KOBOLD
        this.experience = data?.experience ?? 0
    }

    save(): EnemyData {
      return {  
        hand: this.hand.map(card => card.save()),
        deck: this.deck.map(card => card.save()),
        discardPile: this.discardPile.map(card => card.save()),
        level: this.level,
        numberOfHeldCards: this.numberOfHeldCards,
        numberOfCardsInDeck: this.numberOfCardsInDeck,
        enemyType: this.enemyType,
        experience: this.experience
      }
    }
}
