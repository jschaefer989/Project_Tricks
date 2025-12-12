import { Ranks, Suits, TrumpRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Thief extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.THIEF, 5, 4, "Thief")
    }
}