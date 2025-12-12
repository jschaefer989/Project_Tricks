import { Suits, TrumpRanks } from "../Enums"
import GameManager from "../GameManager"
import Card from "./Card"

export default class Knight extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, TrumpRanks.KNIGHT, 7, 0, "Knight")
    }
}