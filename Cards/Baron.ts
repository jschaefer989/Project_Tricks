import { Ranks, Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";

export default class Baron extends Card {
  constructor(gameManager: GameManager, suit: Suits) {
    super(
      gameManager,
      suit,
      Ranks.BARON,
      2,
      5,
      "Baron",
      "Assets/Images/BaronRank.png",
      {
        edelName: "Duke",
        edelPower: 9,
        edelValue: 5,
        edelRankAssetPath: "Assets/Images/DukeRank.png",
      }
    );
  }
}
