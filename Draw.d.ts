import Card from "Card";
import { Image } from "love.graphics";
import Player from "Player";
import GameManager from "GameManager";
interface CardOptions {
    multiSelect?: boolean;
    onClick?: (card: Card) => void;
    displayCost?: boolean;
}
interface PlayerDeckOptions {
    showDiscards?: boolean;
}
export default class Draw {
    static card(card: Card, btnW: number, btnH: number, options?: CardOptions): void;
    static loadImage(path: string): Image | undefined;
    static drawBackgroundImage(image: Image): void;
    static setThemeColors(r: number, g: number, b: number): void;
    static playerInfo(player: Player, gameManager: GameManager): void;
    static playerDeck(player: Player, options?: PlayerDeckOptions): void;
}
export {};
