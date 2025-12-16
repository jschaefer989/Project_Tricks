import Enemy from "./Enemy"
import { EnemyTypes } from "../Enums"
import GameManager from "GameManager"

export default class Tatzelwurm extends Enemy {
    constructor(gameManager: GameManager, level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number) {
        super(gameManager, level, EnemyTypes.TATZELWURM, 50 * level, "Tatzelwurm", numberOfHeldCards, numberOfCardsInDeck)
    }
}