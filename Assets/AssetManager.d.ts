import Asset from "./Asset";
import GameManager from "GameManager";
import TextManager from "Assets/TextManager";
import TooltipManager from "./TooltipManager";
export default class AssetManager {
    gameManager: GameManager;
    assets: Map<string, Asset[]>;
    tooltipManager: TooltipManager;
    textManager: TextManager;
    disabledSound: import("love.audio").Source;
    constructor(gameManager: GameManager);
    addAsset(id: string, asset: Asset): void;
    getAssets(baseId: string): Asset[] | undefined;
    getAsset(baseId: string, assetId: string): Asset | undefined;
    hideAssets(id: string): void;
    hideAsset(baseId: string, assetId: string): void;
    disableAsset(baseId: string): void;
    enableAsset(baseId: string): void;
    drawAssets(): void;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
    handleDisabledAssetClick(assets: Asset[]): void;
    triggerWobbleAnimation(assets: Asset[]): void;
    handleAssetClick(asset: Asset): void;
    handleMouseHover(): void;
}
