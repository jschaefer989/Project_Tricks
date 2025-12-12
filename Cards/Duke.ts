import { Suits, TrumpRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Duke extends Card {
    constructor (gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, TrumpRanks.DUKE, 9, 5, "Duke")
    }
}