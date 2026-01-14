import Asset from "Assets/Asset";
import FontWithPosition from "Assets/Fonts/FontWithPosition";
import GameManager from "GameManager";
import { Shader as LoveShader } from "love.graphics";
export type ShaderAssets = Asset | FontWithPosition;
export default class Shader {
    gameManager: GameManager;
    stopCondition: () => boolean;
    assets: ShaderAssets[];
    isShading: boolean;
    elapsedTime: number;
    shader: LoveShader;
    constructor(gameManager: GameManager, shader: LoveShader, stopCondition: () => boolean, assets: ShaderAssets[]);
    updateShader(deltaTime: number): void;
    get isFinished(): boolean;
}
