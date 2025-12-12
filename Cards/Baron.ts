import { Ranks, Suits } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Baron extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.BARON, 2, 5, "Baron")
    }
}