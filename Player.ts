/** @noSelfInFile */

import Perk, { PerkData } from "Perk"
import Card from "Cards/Card"
import Character from "./Character"
import { Perks } from "Enums"
import Dealer from "Dealer"
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

interface PlayerData {
    name: string
    money: number
    experience: number
    level: number
    discards: number
    numberOfLootCards: number
    hand: CardData[]
    deck: CardData[]
    discardPile: CardData[]
   perks: PerkData[] 
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
        this.hand = data.hand.map(cardData => Card.load(this.gameManager, cardData))
        this.deck = data.deck.map(cardData => Card.load(this.gameManager, cardData))
        this.discardPile = data.discardPile.map(cardData => Card.load(this.gameManager, cardData))
        this.perks = data.perks.map(perkData => Perk.load(this.gameManager, perkData))
    }

    save(): PlayerData {
        return {
            name: this.name,
            money: this.money,
            experience: this.experience,
            level: this.level,
            discards: this.discards,
            numberOfLootCards: this.numberOfLootCards,
            hand: this.hand.map(card => card.save()),
            deck: this.deck.map(card => card.save()),
            discardPile: this.discardPile.map(card => card.save()),
            perks: this.perks.map(perk => perk.save())
        }
    }

    setup(): void {
        if (this.deck.length === 0) {
            Dealer.initializePlayerDeck(this.gameManager)
        }
    }

    removeSelectedCardsFromHand(): void {
        for (let i = this.hand.length - 1; i >= 0; i--) {
            const card = this.hand[i]
            if (card.isSelected) {
                card.isSelected = false
                this.addToDiscards(card)
                this.hand.splice(i, 1)
            }
        }
    }

    discard(): void {
        const newHand: Card[] = []

        for (const card of this.hand) {
            if (card.isSelected) {
                card.isSelected = false
                card.onUnselect()
                this.discardPile.push(card)
            } else {
                newHand.push(card)
            }
        }

        this.hand = newHand
    }

    anySelectedCards(): boolean {
        for (const card of this.hand) {
            if (card.isSelected) {
                return true
            }
        }
        return false
    }

    cashout(points: number): void {
        if (points < 0) return
        this.money += points
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

    unselectCards(): void {
        for (const card of this.hand) {
            if (card.isSelected) {
                card.isSelected = false
                card.onUnselect()
            }
        }
    }
}
