import Card from "Card";
import { Image } from "love.graphics";
import Player from "Player";
interface CardOptions {
    multiSelect?: boolean;
    onClick?: (card: Card) => void;
    displayCost?: boolean;
}
export default class Draw {
    static card(card: Card, btnW: number, btnH: number, options?: CardOptions): void;
    static loadImage(path: string): Image | undefined;
    static drawBackgroundImage(image: Image): void;
    static setThemeColors(r: number, g: number, b: number): void;
    static playerInfoPanel(player: Player): void;
    static playerDeckVisualization(player: Player): void;
}
export {};
