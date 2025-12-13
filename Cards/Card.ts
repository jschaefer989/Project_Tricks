/** @noSelfInFile */

import GameManager from "GameManager"
import { Ranks, Suits, TrumpRanks } from "../Enums"
import { isEmpty } from "Helpers"

export default class Card {
    gameManager: GameManager
    id: string
    suit: Suits
    rank: Ranks | TrumpRanks
    power: number
    value: number
    isSelected: boolean
    cost: number
    isTrump: boolean
    name: string

    constructor(gameManager: GameManager, suit: Suits, rank: Ranks | TrumpRanks, power: number, value: number, name: string, isTrump: boolean = false) {
        this.gameManager = gameManager
        this.suit = suit
        this.rank = rank
        this.power = power
        this.value = value
        this.cost = this.getCost()
        this.isSelected = false
        this.isTrump = isTrump
        this.name = name
        this.id = `${this.suit}-${this.rank}`
    }

    isEqual(otherCard: Card): boolean {
        return this.id === otherCard.id
    }

    getCost(): number {
        let cost = 0
        cost += this.getBaseCost()
        return cost
    }

    getBaseCost(): number {
        return this.power * 10 + this.value * 5
    }

    onSelect(): void {
        if (isEmpty(this.gameManager.board)) {
            return  
        } 

        this.gameManager.board.playerPower += this.power
    }

    onUnselect(): void {
        if (isEmpty(this.gameManager.board)) {
            return  
        } 

        this.gameManager.board.playerPower -= this.power
    }
}
