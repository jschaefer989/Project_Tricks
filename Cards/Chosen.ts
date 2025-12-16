import { Suits, TrumpRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Chosen extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, TrumpRanks.CHOSEN, 16, 11, "The Chosen")
    }
}