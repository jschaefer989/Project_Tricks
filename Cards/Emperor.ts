import { Suits, EdelRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Emperor extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, EdelRanks.EMPEROR, 13, 0, "Emperor")
    }
}