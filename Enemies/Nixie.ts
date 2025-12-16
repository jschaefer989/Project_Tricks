import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"
import GameManager from "GameManager"

export default class Nixie extends Enemy {
    constructor(gameManager: GameManager, level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(gameManager, level, EnemyTypes.NIXIE, 20 * level, "Nixie", numberOfHeldCards, numberOfCardsInDeck)
    }
}