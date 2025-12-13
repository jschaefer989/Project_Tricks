import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"

export default class Tatzelwurm extends Enemy {
    constructor(level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(level, EnemyTypes.TATZELWURM, 50 * level, "Tatzelwurm", numberOfHeldCards, numberOfCardsInDeck)
    }
}