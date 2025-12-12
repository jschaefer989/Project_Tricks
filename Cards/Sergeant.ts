import { Ranks, Suits } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Sergeant extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.SERGEANT, 8, 11, "Sergeant")
    }
}