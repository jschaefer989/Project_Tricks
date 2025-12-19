import Card from "../Cards/Card";
import { Suits, Ranks, TrumpRanks } from "Enums";
import GameManager from "GameManager";
import Hoverable from "Hoverable";
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
    static getCardAssetId(card: Card): string;
    addSuitAsset(card: Card, x: number, y: number, width: number, height: number, hoverable: Hoverable): void;
    addRankAsset(card: Card, x: number, y: number, width: number, height: number, hoverable: Hoverable): void;
    static getSuitAssetPath(suit: Suits): string;
    static getSuitAssetId(card: Card, orientation: number): string;
    static getRankAssetPath(rank: Ranks | TrumpRanks): string;
    static getRankAssetId(card: Card, orientation: number): string;
    hideCardAssets(card: Card): void;
    centerCards(): void;
    updateCardPosition(card: Card, x: number, y: number): void;
    getCardPosition(): number;
    appendAsset(card: Card): void;
}
export {};
