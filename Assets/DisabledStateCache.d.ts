import GameManager from "GameManager";
import Asset from "./Asset";
export default class DisabledStateCache {
    gameManager: GameManager;
    private cache;
    constructor(gameManager: GameManager);
    cacheState(asset: Asset): void;
    restore(idsToSkip?: string[]): void;
}
