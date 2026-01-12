import { Ranks, Suits } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard, getRandomElementFromEnum } from "Helpers";
import Banner from "./Banner";
import Baron from "./Baron";
import Card from "./Card";
import Deuce from "./Deuce";
import Jester from "./Jester";
import King from "./King";
import Overlord from "./Overlord";
import Priest from "./Priest";
import Sergeant from "./Sergeant";
import Soldier from "./Soldier";
import Thief from "./Thief";

export default class CardGenerator {
  static getNewCard(gameManager: GameManager, rank: Ranks, suit: Suits): Card {
    switch (rank) {
      case Ranks.BANNER:
        return new Banner(gameManager, suit);
      case Ranks.BARON:
        return new Baron(gameManager, suit);
      case Ranks.DEUCE:
        return new Deuce(gameManager, suit);
      case Ranks.JESTER:
        return new Jester(gameManager, suit);
      case Ranks.KING:
        return new King(gameManager, suit);
      case Ranks.OVERLORD:
        return new Overlord(gameManager, suit);
      case Ranks.PRIEST:
        return new Priest(gameManager, suit);
      case Ranks.SERGEANT:
        return new Sergeant(gameManager, suit);
      case Ranks.THIEF:
        return new Thief(gameManager, suit);
      case Ranks.SOLDIER:
        return new Soldier(gameManager, suit);
      default:
        exhaustiveGuard(rank);
    }
  }

    static getRandomCard(gameManager: GameManager): Card {
      const suit = getRandomElementFromEnum(Suits);
      const rank = getRandomElementFromEnum(Ranks);
      return CardGenerator.getNewCard(gameManager, rank, suit);
    }
  
}
