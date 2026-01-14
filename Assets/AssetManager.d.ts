import TextManager from "Assets/Fonts/TextManager";
import GameManager from "GameManager";
import Asset from "./Asset";
import TooltipManager from "./TooltipManager";
export default class AssetManager {
    gameManager: GameManager;
    assets: Map<string, Asset[]>;
    tooltipManager: TooltipManager;
    textManager: TextManager;
    disabledSound: import("love.audio").Source;
    buttonClickSound: import("love.audio").Source;
    constructor(gameManager: GameManager);
    addAsset(id: string, asset: Asset): void;
    getAssets(baseId: string): Asset[] | undefined;
    getAsset(baseId: string, assetId: string): Asset | undefined;
    removeAssets(id: string): void;
    removeAsset(baseId: string, assetId: string): void;
    disableAsset(baseId: string): void;
    enableAsset(baseId: string): void;
    hasAssets(baseId: string): boolean;
    hasAsset(baseId: string, assetId: string): boolean;
    drawAssets(): void;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
    handleDisabledAssetClick(assets: Asset[]): void;
    triggerWobbleAnimation(assets: Asset[]): void;
    handleAssetClick(asset: Asset): void;
    handleMouseHover(): void;
}
