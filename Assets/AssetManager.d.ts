import Asset from "./Asset";
import GameManager from "GameManager";
export default class AssetManager {
    gameManager: GameManager;
    assets: Map<string, Asset>;
    constructor(gameManager: GameManager);
    addAsset(id: string, asset: Asset): void;
    getAsset(id: string): Asset | undefined;
    drawAssets(): void;
    drawCards(): void;
    drawHoverables(): void;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
    handleMouseHover(): void;
}
