import { Ranks, Suits } from "Enums";
import GameManager from "GameManager";
import Card from "./Card";
export default class CardGenerator {
    static getNewCard(gameManager: GameManager, rank: Ranks, suit: Suits): Card;
    static getRandomCard(gameManager: GameManager): Card;
}
