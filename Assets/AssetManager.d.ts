import Asset from "./Asset";
import GameManager from "GameManager";
import TextManager from "Assets/TextManager";
export default class AssetManager {
    gameManager: GameManager;
    assets: Map<string, Asset[]>;
    textManager: TextManager;
    disabledSound: import("love.audio").Source;
    constructor(gameManager: GameManager);
    addAsset(id: string, asset: Asset): void;
    getAssets(baseId: string): Asset[] | undefined;
    getAsset(baseId: string, assetId: string): Asset | undefined;
    hideAsset(id: string): void;
    disableAsset(baseId: string): void;
    enableAsset(baseId: string): void;
    drawAssets(): void;
    private drawHoverables;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
    handleMouseHover(): void;
}
