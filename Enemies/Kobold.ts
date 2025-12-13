import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"

export default class Kobold extends Enemy {
    constructor(level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(level, EnemyTypes.KOBOLD, 10 * level, "Kobold", numberOfHeldCards, numberOfCardsInDeck)
    }
}