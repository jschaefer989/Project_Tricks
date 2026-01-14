import { CharacterTypes, Suits } from "Enums";
import GameManager from "GameManager";
import { Image } from "love.graphics";
import Point from "Point";
import Board from "Screens/Board";
import Card from "../Cards/Card";
import Asset, { ConstructionOptions } from "./Asset";
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
    board: Board;
    baseCard: Image;
    edelCard: Image;
    cardClick: import("love.audio").Source;
    hoverSound: import("love.audio").Source;
    cardAssetConstructionOptions: (includeClickHandler: boolean, card: Card) => ConstructionOptions;
    constructor(gameManager: GameManager, board: Board);
    addAsset(card: Card, cardX: number, cardY: number, includeClickHandler?: boolean): void;
    static getBaseAssetId(card: Card): string;
    addSuitAsset(card: Card, x: number, y: number, includeClickHandler?: boolean): void;
    getNormalSuitPosition(x: number, y: number): Point;
    getFlippedSuitPosition(x: number, y: number): Point;
    addRankAsset(card: Card, x: number, y: number, includeClickHandler?: boolean): void;
    getRankPosition(x: number, y: number, rankImage: Image): Point;
    static getSuitAssetPath(suit: Suits): string;
    static getSuitAssetId(card: Card, orientation: number): string;
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
    redrawCard(card: Card): void;
}
export {};
