import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"

export default class Nixie extends Enemy {
    constructor(level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(level, EnemyTypes.NIXIE, 20 * level, "Nixie", numberOfHeldCards, numberOfCardsInDeck)
    }
}