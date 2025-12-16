import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"
import GameManager from "GameManager"

export default class Kobold extends Enemy {
    constructor(gameManager: GameManager, level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(gameManager, level, EnemyTypes.KOBOLD, 10 * level, "Kobold", numberOfHeldCards, numberOfCardsInDeck)
    }
}