import Card from "Card";
import GameManager from "./GameManager";
import { Image } from "love.graphics";
export default class Draw {
    static card(gameManager: GameManager, card: Card, btnW: number, btnH: number, onlySelectOne?: boolean): void;
    static loadImage(path: string): Image | undefined;
    static drawBackgroundImage(image: Image): void;
    static setThemeColors(r: number, g: number, b: number): void;
}
