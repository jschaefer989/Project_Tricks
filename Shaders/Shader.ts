import Asset from "Assets/Asset";
import FontWithPosition from "Assets/FontWithPosition";
import GameManager from "GameManager";
import { Shader as LoveShader } from "love.graphics";

export type ShaderAssets = Asset | FontWithPosition;

export default class Shader {
    gameManager: GameManager;
    stopCondition: () => boolean;
    assets: ShaderAssets[];
    isShading: boolean = true;
    elapsedTime = 0;
    shader: LoveShader;
    
    constructor(gameManager: GameManager, shader: LoveShader, stopCondition: () => boolean, assets: ShaderAssets[]) {
        this.gameManager = gameManager;
        this.shader = shader;
        this.stopCondition = stopCondition;
        this.assets = assets;
    }

      updateShader(deltaTime: number): void {
        if (!this.isShading) {
          return;
        }
    
        if (this.stopCondition && this.stopCondition()) {
          this.isShading = false;
          return;
        }

        this.elapsedTime += deltaTime;
      }

      get isFinished(): boolean {
        return !this.isShading;
      }
}