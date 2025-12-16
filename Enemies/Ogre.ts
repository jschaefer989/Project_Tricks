import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"
import GameManager from "GameManager"

export default class Ogre extends Enemy {
    constructor(gameManager: GameManager, level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(gameManager, level, EnemyTypes.OGRE, 30 * level, "Ogre", numberOfHeldCards, numberOfCardsInDeck)
    }
}