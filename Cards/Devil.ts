import { Suits, EdelRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Devil extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, EdelRanks.DEVIL, 15, 4, "Devil", true)
    }
}