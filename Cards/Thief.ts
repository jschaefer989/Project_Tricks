import { Ranks, Suits } from "../Enums";
import GameManager from "../GameManager";
import Card from "./Card";

export default class Thief extends Card {
  constructor(gameManager: GameManager, suit: Suits) {
    super(
      gameManager,
      suit,
      Ranks.THIEF,
      5,
      4,
      "Thief",
      "Assets/Images/ThiefRank.png",
      {
        edelName: "Devil",
        edelPower: 15,
        edelValue: 4,
        edelRankAssetPath: "Assets/Images/DevilRank.png",
      }
    );
  }
}
