/** @noSelfInFile */
import Asset from "Assets/Asset";
import GameManager from "GameManager";
import { Ranks, Suits } from "../Enums";
export interface CardData {
    id: string;
    suit: Suits;
    rank: Ranks;
    power: number;
    value: number;
    isSelected: boolean;
    cost: number;
    name: string;
}
interface EdelConstructionOptions {
    edelName: string;
    edelPower: number;
    edelValue: number;
    edelRankAssetPath: string;
}
export default abstract class Card {
    gameManager: GameManager;
    id: string;
    suit: Suits;
    rank: Ranks;
    private rankAssetPath;
    private power;
    private value;
    isSelected: boolean;
    cost: number;
    private name;
    private edelName?;
    private edelPower?;
    private edelValue?;
    private edelRankAssetPath?;
    constructor(gameManager: GameManager, suit: Suits, rank: Ranks, power: number, value: number, name: string, rankAssetPath: string, edelConstructionOptions?: EdelConstructionOptions);
    isEqual(otherCard: Card): boolean;
    getCost(): number;
    getBaseCost(): number;
    save(): CardData;
    static load(gameManager: GameManager, data: CardData): Card;
    onClick(): void;
    onSelect(): void;
    onUnselect(): void;
    onHover(asset: Asset): void;
    onUnhover(asset: Asset): void;
    static getSuitName(suit: Suits): string;
    get isEdel(): boolean;
    getPower(): number;
    getValue(): number;
    getName(): string;
    getRankAssetPath(): string;
}
export {};
