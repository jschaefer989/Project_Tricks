/** @noSelfInFile */

import { Ranks, Suits } from "./Enums"

export default class Card {
    suit: Suits
    rank: Ranks
    power: number
    value: number
    selected: boolean

    constructor(suit: Suits, rank: Ranks) {
        this.suit = suit
        this.rank = rank
        this.power = this.getPower(suit, rank)
        this.value = this.getValue(rank)
        this.selected = false
    }

    isEqual(otherCard: Card): boolean {
        return this.suit === otherCard.suit && this.rank === otherCard.rank
    }

    getPower(suit: string, rank: string): number {
        // Handle trump cards
        if (rank === Ranks.QUEEN || rank === Ranks.JACK || suit === Suits.DIAMONDS) {
            if (rank === Ranks.QUEEN) {
                switch (suit) {
                    case Suits.HEARTS: return 19
                    case Suits.SPADES: return 18
                    case Suits.CLUBS: return 17
                    case Suits.DIAMONDS: return 16
                }
            } else if (rank === Ranks.JACK) {
                switch (suit) {
                    case Suits.HEARTS: return 15
                    case Suits.SPADES: return 14
                    case Suits.CLUBS: return 13
                    case Suits.DIAMONDS: return 12
                }
            } else if (suit === Suits.DIAMONDS) {
                switch (rank) {
                    case Ranks.ACE: return 11
                    case Ranks.TEN: return 10
                    case Ranks.KING: return 9
                    case Ranks.NINE: return 8
                    case Ranks.EIGHT: return 7
                    case Ranks.SEVEN: return 6
                }
            }
        }
        // Other cards have the same power regardless of suit
        switch (rank) {
            case Ranks.ACE: return 5
            case Ranks.TEN: return 4
            case Ranks.KING: return 3
            case Ranks.QUEEN: return 2
            case Ranks.JACK: return 1
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
}
