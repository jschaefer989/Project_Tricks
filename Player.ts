/** @noSelfInFile */

import Card from "./Card"
import Character from "./Character"

interface PlayerData {
    name?: string
    money?: number
    experience?: number
    level?: number
    discards?: number
    numberOfLootCards?: number
    hand?: Card[]
    deck?: Card[]
    discardPile?: Card[]
}

export default class Player extends Character {
    name: string
    money: number
    experience: number
    level: number
    discards: number
    numberOfLootCards: number

    constructor() {
        super()
        this.name = "Player"
        this.money = 0
        this.experience = 0
        this.level = 1
        this.discards = 3
        this.numberOfLootCards = 3
    }

    load(data: PlayerData): void {
        this.name = data.name ?? "Player"
        this.money = data.money ?? 0
        this.experience = data.experience ?? 0
        this.level = data.level ?? 1
        this.discards = data.discards ?? 3
        this.numberOfLootCards = data.numberOfLootCards ?? 3
        this.hand = data.hand ?? []
        this.deck = data.deck ?? []
        this.discardPile = data.discardPile ?? []
    }

    save(): PlayerData {
        return {
            name: this.name,
            money: this.money,
            experience: this.experience,
            level: this.level,
            discards: this.discards,
            numberOfLootCards: this.numberOfLootCards,
            hand: this.hand,
            deck: this.deck,
            discardPile: this.discardPile
        }
    }

    getCardPower(): number {
        let power = 0
        for (const card of this.hand) {
            if (card.selected) {
                power += card.power
            }
        }
        return power
    }

    getCardValue(): number {
        let value = 0
        for (const card of this.hand) {
            if (card.selected) {
                value += card.value
            }
        }
        return value
    }

    removeSelectedCardsFromHand(): void {
        for (let i = this.hand.length - 1; i >= 0; i--) {
            const card = this.hand[i]
            if (card.selected) {
                this.addToDiscards(card)
                this.hand.splice(i, 1)
            }
        }
    }

    discard(): void {
        const newHand: Card[] = []

        for (const card of this.hand) {
            if (card.selected) {
                card.selected = false
                this.discardPile.push(card)
            } else {
                newHand.push(card)
            }
        }

        this.hand = newHand
    }

    anySelectedCards(): boolean {
        for (const card of this.hand) {
            if (card.selected) {
                return true
            }
        }
        return false
    }

    cashout(points: number): void {
        if (points < 0) return
        this.money += points
    }

    deselectAllCards(): void {
        for (const card of this.hand) {
            card.selected = false
        }
    }
}
