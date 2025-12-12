import { Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";
export default class Trick extends Card {
    constructor(gameManager: GameManager, suit: Suits);
}
