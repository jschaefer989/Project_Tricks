import Card from "../Cards/Card";
import Asset from "./Asset";
import { Suits, Ranks, EdelRanks, CharacterTypes } from "Enums";
import GameManager from "GameManager";
import Point from "Point";
import { Image } from "love.graphics";
export declare const padding = 5;
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
    cardClick: import("love.audio").Source;
    constructor(gameManager: GameManager);
    addAsset(card: Card, cardX: number, cardY: number, includeClickHandler?: boolean): void;
    static getBaseAssetId(card: Card): string;
    addSuitAsset(card: Card, x: number, y: number, includeClickHandler?: boolean): void;
    getNormalSuitPosition(x: number, y: number): Point;
    getFlippedSuitPosition(x: number, y: number): Point;
    addRankAsset(card: Card, x: number, y: number, includeClickHandler?: boolean): void;
    getRankPosition(x: number, y: number, rankImage: Image): Point;
    static getSuitAssetPath(suit: Suits): string;
    static getSuitAssetId(card: Card, orientation: number): string;
    static getRankAssetPath(rank: Ranks | EdelRanks): string;
    static getRankAssetId(card: Card, orientation: number): string;
    hideCardAssets(card: Card): void;
    centerCards(characterType: CharacterTypes): void;
    updateCardPosition(card: Card, x: number, y: number): void;
    getRankAsset(card: Card): Asset | undefined;
    getCardPosition(characterType: CharacterTypes): number;
    getHeightModifier(characterType: CharacterTypes): number;
    determineCardStartingPosition(characterType: CharacterTypes): Point;
    appendAsset(card: Card, characterType: CharacterTypes): void;
    getCardAssets(card: Card): AssetsForCard;
}
export {};
