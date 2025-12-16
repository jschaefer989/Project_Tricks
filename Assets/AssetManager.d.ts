import Asset from "./Asset";
export default class AssetManager {
    assets: Map<string, Asset>;
    constructor();
    addAsset(id: string, asset: Asset): void;
    getAsset(id: string): Asset | undefined;
    drawAssets(): void;
    handleMousePressed(x: number, y: number, button: number): void;
    handleMouseReleased(x: number, y: number, button: number): void;
}
