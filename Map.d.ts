/** @noSelfInFile */
import GameManager from "GameManager";
import MapTier, { MapTierData } from "MapTier";
interface MapData {
    tiers: MapTierData[];
    currentTierIndex: number;
}
export default class Map {
    gameManager: GameManager;
    tiers: MapTier[];
    currentTierIndex: number;
    backgroundImage?: any;
    constructor(gameManager: GameManager);
    load(data: MapData): void;
    save(): MapData;
    drawMap(): void;
    drawBackground(): void;
    drawTiers(): void;
    generateNewMap(): void;
    advanceToNextTier(): void;
}
export {};
