import Enemy from "./Enemy";
import GameManager from "GameManager";
export default class Kobold extends Enemy {
    constructor(gameManager: GameManager, level: number, numberOfHeldCards?: number, numberOfCardsInDeck?: number);
}
