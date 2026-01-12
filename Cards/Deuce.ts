import { Ranks, Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";

export default class Deuce extends Card {
  constructor(gameManager: GameManager, suit: Suits) {
    super(
      gameManager,
      suit,
      Ranks.DEUCE,
      1,
      0,
      "Deuce",
      "Assets/Images/DeuceRank.png",
      {
        edelName: "The Chosen",
        edelPower: 16,
        edelValue: 11,
        edelRankAssetPath: "Assets/Images/ChosenRank.png",
      }
    );
  }
}
