import GameManager from "GameManager";
import Shader from "./Shader";
import Asset from "Assets/Asset";
export default class ShaderManager {
    gameManager: GameManager;
    shaders: Map<string, Shader>;
    constructor(gameManager: GameManager);
    addShader(assetId: string, shader: Shader): void;
    getShader(assetId: string): Shader | undefined;
    updateShaders(dt: number): void;
    applyShaders(asset: Asset): void;
    removeShaders(): void;
}
