import { Ranks, Suits } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Soldier extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.SOLDIER, 3, 0, "Soldier")
    }
}