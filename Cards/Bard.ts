import { Suits, EdelRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Bard extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, EdelRanks.BARD, 11, 0, "Bard")
    }
}