import { Suits, EdelRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Pope extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, EdelRanks.POPE, 14, 4, "Pope")
    }
}