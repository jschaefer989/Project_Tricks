import Card from "../Cards/Card";
import Asset from "./Asset";
import { Suits, Ranks, TrumpRanks, CharacterTypes } from "Enums";
import GameManager from "GameManager";
import Point from "Point";
import { Image } from "love.graphics";
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
interface AssetsForCard {
    baseAsset: Asset;
    suitAssets: Asset[];
    rankAsset: Asset;
}
export default class CardAssets {
    gameManager: GameManager;
    baseCard: Image;
    baseW: number;
    baseH: number;
    constructor(gameManager: GameManager);
    addAsset(card: Card, cardX: number, cardY: number, options?: CardOptions): void;
    static getBaseAssetId(card: Card): string;
    addSuitAsset(card: Card, x: number, y: number): void;
    getNormalSuitPosition(x: number, y: number): Point;
    getFlippedSuitPosition(x: number, y: number): Point;
    addRankAsset(card: Card, x: number, y: number): void;
    getRankPosition(x: number, y: number, rankImage: Image): Point;
    static getSuitAssetPath(suit: Suits): string;
    static getSuitAssetId(card: Card, orientation: number): string;
    static getRankAssetPath(rank: Ranks | TrumpRanks): string;
    static getRankAssetId(card: Card, orientation: number): string;
    hideCardAssets(card: Card): void;
    centerCards(characterType: CharacterTypes, shiftUp?: boolean): void;
    updateCardPosition(card: Card, x: number, y: number): void;
    getRankAsset(card: Card): Asset | undefined;
    getCardPosition(characterType: CharacterTypes, shiftUp?: boolean): number;
    getHeightModifier(characterType: CharacterTypes, shiftUp?: boolean): number;
    determineCardStartingPosition(characterType: CharacterTypes): Point;
    appendAsset(card: Card, characterType: CharacterTypes): void;
    getCardAssets(card: Card): AssetsForCard;
}
export {};
