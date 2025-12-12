/** @noSelfInFile */

import { exhaustiveGuard } from "Helpers"
import { Ranks, Suits } from "../Enums"

export default class Card {
    suit: Suits
    rank: Ranks
    power: number
    value: number
    selected: boolean
    cost: number

    constructor(suit: Suits, rank: Ranks) {
        this.suit = suit
        this.rank = rank
        this.power = this.getPower(suit, rank)
        this.value = this.getValue(rank)
        this.selected = false
        this.cost = this.getCost()
    }

    isEqual(otherCard: Card): boolean {
        return this.suit === otherCard.suit && this.rank === otherCard.rank
    }

    getPower(suit: string, rank: string): number {
        // Handle trump cards
        if (rank === Ranks.QUEEN || rank === Ranks.JACK || suit === Suits.DIAMONDS) {
            if (rank === Ranks.QUEEN) {
                switch (suit) {                 
                    case Suits.CLUBS: return 22  
                    case Suits.SPADES: return 21
                    case Suits.HEARTS: return 20
                    case Suits.DIAMONDS: return 19
                }
            } else if (rank === Ranks.JACK) {
                switch (suit) {
                    case Suits.CLUBS: return 18                   
                    case Suits.SPADES: return 17
                    case Suits.HEARTS: return 16
                    case Suits.DIAMONDS: return 15
                }
            } else if (suit === Suits.DIAMONDS) {
                switch (rank) {
                    case Ranks.ACE: return 14
                    case Ranks.TEN: return 13
                    case Ranks.KING: return 12
                    case Ranks.NINE: return 11
                    case Ranks.EIGHT: return 10
                    case Ranks.SEVEN: return 9
                }
            }
        }
        // Other cards have the same power regardless of suit
        switch (rank) {
            case Ranks.ACE: return 8
            case Ranks.TEN: return 7
            case Ranks.KING: return 6
            case Ranks.QUEEN: return 5
            case Ranks.JACK: return 4
            case Ranks.NINE: return 3
            case Ranks.EIGHT: return 2
            case Ranks.SEVEN: return 1
            default: return 0
        }
    }

    getValue(rank: string): number {
        switch (rank) {
            case Ranks.ACE: return 11
            case Ranks.TEN: return 10
            case Ranks.KING: return 4
            case Ranks.QUEEN: return 3
            case Ranks.JACK: return 2
            default: return 0
        }
    }

    getCost(): number {
        let cost = 0
        cost += this.getBaseCost()
        return cost
    }

    getBaseCost(): number {
        let cost = 10
        switch (this.rank) {
            case Ranks.SEVEN: 
                cost *= 1
                break
            case Ranks.EIGHT: 
                cost *= 1
                break
            case Ranks.NINE: 
                cost *= 1 
                break
            case Ranks.KING: cost += 2 
                cost *= 2 
                break
            case Ranks.TEN: 
                cost *= 3
                break
            case Ranks.JACK: 
                cost *= 3
                break
            case Ranks.QUEEN: 
                cost *= 4
                break
            case Ranks.ACE: 
                cost *= 4
                break
            default: exhaustiveGuard(this.rank)
        }
        switch (this.suit) {
            case Suits.DIAMONDS:
                cost *= 2
                break
            case Suits.CLUBS:
                cost *= 1
                break
            case Suits.HEARTS:
                cost *= 1
                break
            case Suits.SPADES:
                cost *= 1
                break
        }   
        return cost
    }
}
