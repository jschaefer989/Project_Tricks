/** @noSelfInFile */

import Perk from "Perk"
import Card from "./Card"
import Character from "./Character"
import { Perks } from "Enums"
import Dealer from "Dealer"
import GameManager from "GameManager"

interface PlayerData {
    name: string
    money: number
    experience: number
    level: number
    discards: number
    numberOfLootCards: number
    hand: Card[]
    deck: Card[]
    discardPile: Card[]
   perks: Perk[] 
}

export default class Player extends Character {
    gameManager: GameManager
    name: string
    money: number
    experience: number
    level: number
    discards: number
    numberOfLootCards: number
    perks: Perk[]

    constructor(gameManager: GameManager) {
        super()
        this.gameManager = gameManager
        this.name = "Player"
        this.money = 0
        this.experience = 0
        this.level = 1
        this.discards = 3
        this.numberOfLootCards = 3
        this.perks = []
    }

    load(data: PlayerData): void {
        this.name = data.name
        this.money = data.money
        this.experience = data.experience
        this.level = data.level
        this.discards = data.discards
        this.numberOfLootCards = data.numberOfLootCards
        this.hand = data.hand
        this.deck = data.deck
        this.discardPile = data.discardPile
        this.perks = data.perks
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
            discardPile: this.discardPile,
            perks: this.perks
        }
    }

    setup(): void {
        if (this.deck.length === 0) {
            Dealer.initializePlayerDeck(this.gameManager)
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
                card.selected = false
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

    hasPerk(perkType: Perks): boolean {
        for (const perk of this.perks) {
            if (perk.perkType === perkType) {
                return true
            }
        }
        return false
    }

    addPerk(perk: Perk): void {
        this.perks.push(perk)
    }

    gatherExperience(exp: number): boolean {
        this.experience += exp

        if (this.experience >= this.getNextLevelExperience()) {
            this.levelUp()
            return true
        }
        return false
    }

    getNextLevelExperience(): number {
        switch (this.level) {
            case 1:
                return 100
            case 2:
                return 150
            case 3:
                return 250
            case 4:
                return 500
            default:
                return 1000
        }
    }

    levelUp(): void {
        this.experience = 0
        this.level += 1
    }
}
