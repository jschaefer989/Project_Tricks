import { Ranks, Suits } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Priest extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.PRIEST, 4, 4, "Priest")
    }
}