/** @noSelfInFile */

import { Ranks, Suits } from "../Enums"
import Card from "./Card"
import GameManager from "../GameManager"

export default class Banner extends Card {
    constructor(gameManager: GameManager, suit: Suits) {
        super(gameManager, suit, Ranks.BANNER, 6, 3, "Banner")
    }
}