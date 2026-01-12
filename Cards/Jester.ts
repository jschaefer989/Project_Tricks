import { Ranks, Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";

export default class Jester extends Card {
  constructor(gameManager: GameManager, suit: Suits) {
    super(
      gameManager,
      suit,
      Ranks.JESTER,
      1,
      0,
      "Jester",
      "Assets/Images/JesterRank.png",
      {
        edelName: "Bard",
        edelPower: 11,
        edelValue: 0,
        edelRankAssetPath: "Assets/Images/BardRank.png",
      }
    );
  }
}
