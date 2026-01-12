import { Ranks, Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";

export default class King extends Card {
  constructor(gameManager: GameManager, suit: Suits) {
    super(
      gameManager,
      suit,
      Ranks.KING,
      12,
      3,
      "King",
      "Assets/Images/KingRank.png",
      {
        edelName: "Emperor",
        edelPower: 13,
        edelValue: 0,
        edelRankAssetPath: "Assets/Images/EmperorRank.png",
      }
    );
  }
}
