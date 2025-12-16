import Card from "../Cards/Card";
import { Suits } from "Enums";
import GameManager from "GameManager";
interface CardOptions {
    multiSelect?: boolean;
    /**
     * Overrides the onSelect/onUnselect behavior for the card, which generally assumes that the card is rendered on the board
     * @param card
     * @returns
     */
    onClick?: (card: Card) => void;
    displayCost?: boolean;
}
export default class CardAssets {
    gameManager: GameManager;
    baseCard: import("love.graphics").Image;
    baseW: number;
    baseH: number;
    constructor(gameManager: GameManager);
    addAsset(card: Card, cardX: number, cardY: number, options?: CardOptions): void;
    addSuitAsset(card: Card, x: number, y: number, width: number, height: number): void;
    getSuitAssetPath(suit: Suits): string;
    getSuitAssetId(suit: Suits, card: Card, orientation: number): string;
}
export {};
