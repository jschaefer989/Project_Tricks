import Card from "../Cards/Card";
import Asset, { ConstructionOptions } from "./Asset";
import { Suits, Ranks, EdelRanks, CharacterTypes } from "Enums";
import GameManager from "GameManager";
import Point from "Point";
import { Image } from "love.graphics";
export declare const padding = 5;
export declare const cardWidth = 70;
export declare const cardHeight = 96;
interface AssetsForCard {
    baseAsset?: Asset;
    suitAssets: (Asset | undefined)[];
    rankAsset?: Asset;
}
export default class CardAssets {
    gameManager: GameManager;
    baseCard: Image;
    cardClick: import("love.audio").Source;
    cardAssetConstructionOptions: (includeClickHandler: boolean, card: Card, orientation?: number) => ConstructionOptions;
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
    removeCardAssets(card: Card): void;
    hideCardAssets(card: Card): void;
    getRankAsset(card: Card): Asset | undefined;
    getHandYCoordinate(characterType: CharacterTypes): number;
    getHeightModifier(characterType: CharacterTypes): number;
    determineCardStartingPosition(characterType: CharacterTypes): Point;
    appendAsset(card: Card, characterType: CharacterTypes): void;
    getCardAssets(card: Card): AssetsForCard;
    getCardAssetList(card: Card): Asset[];
    disableAllCards(disable: boolean): void;
}
export {};
