import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"

export default class Ogre extends Enemy {
    constructor(level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(level, EnemyTypes.OGRE, 30 * level, "Ogre", numberOfHeldCards, numberOfCardsInDeck)
    }
}