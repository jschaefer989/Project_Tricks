import { Ranks, Suits } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Overlord extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.OVERLORD, 10, 2, "Overlord")
    }
}