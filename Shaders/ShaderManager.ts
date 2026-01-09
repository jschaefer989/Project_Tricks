import GameManager from "GameManager";
import Shader from "./Shader";
import Asset from "Assets/Asset";

export default class ShaderManager {
  gameManager: GameManager;
  shaders: Map<string, Shader> = new Map<string, Shader>();

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  addShader(assetId: string, shader: Shader): void {
    this.shaders.set(assetId, shader);
  }

  getShader(assetId: string): Shader | undefined {
    return this.shaders.get(assetId);
  }

  updateShaders(dt: number): void {
    for (const [id, shader] of this.shaders) {
      shader.updateShader(dt);
      if (shader.isFinished) {
        this.shaders.delete(id);
      }
    }
  }

  applyShaders(asset: Asset): void {
    const shader = this.shaders.get(asset.id);
    if (shader && shader.isShading) {
      love.graphics.setShader(shader.shader);
    }
  }

  removeShaders(): void {
    love.graphics.setShader();
  }
}
