import { Suits, EdelRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Duke extends Card {
    constructor (gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, EdelRanks.DUKE, 9, 5, "Duke")
    }
}