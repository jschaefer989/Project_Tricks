import Asset from "./Asset";
import { AssetIds } from "Enums";
import GameManager from "GameManager";
interface ButtonOptions {
    onHover?: () => boolean;
}
export default class ButtonAssets {
    gameManager: GameManager;
    letsFightButton: import("love.graphics").Image;
    baseW: number;
    baseH: number;
    constructor(gameManager: GameManager);
    addAsset(buttonX: number, buttonY: number, onClick: () => void, options?: ButtonOptions): void;
    getAsset(assetId: AssetIds): Asset | undefined;
    hideButton(buttonId: AssetIds): void;
}
export {};
