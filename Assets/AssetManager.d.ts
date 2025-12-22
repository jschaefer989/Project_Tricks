import Asset from "./Asset";
import GameManager from "GameManager";
import FontManager from "Assets/FontManager";
export default class AssetManager {
    gameManager: GameManager;
    assets: Map<string, Asset>;
    fontManager: FontManager;
    constructor(gameManager: GameManager);
    addAsset(id: string, asset: Asset): void;
    getAsset(id: string): Asset | undefined;
    hideAsset(id: string): void;
    drawAssets(): void;
    private drawHoverables;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
    handleMouseHover(): void;
}
