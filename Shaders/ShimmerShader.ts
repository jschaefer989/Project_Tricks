import GameManager from "GameManager";
import Shader, { ShaderAssets } from "./Shader";

export default class ShimmerShader extends Shader {
  private shimmerPhase = 0;
  private sweepDuration = 0.4; // seconds for a quick pass
  private delayDuration = 2.0; // seconds to wait between passes
  private isSweeping = false;
  private delayTimer = 2.0; // Start with initial 2-second delay

  constructor(
    gameManager: GameManager,
    stopCondition: () => boolean,
    assets: ShaderAssets[]
  ) {
    const shader = love.graphics.newShader("Shaders/Shimmer.glsl");
    super(gameManager, shader, stopCondition, assets);
  }

  updateShader(deltaTime: number): void {
    super.updateShader(deltaTime);

    if (this.isSweeping) {
      const nextPhase = this.shimmerPhase + deltaTime / this.sweepDuration;
      
      // End sweep before it wraps around
      if (nextPhase >= 0.85) {
        this.isSweeping = false;
        this.delayTimer = this.delayDuration;
        this.shimmerPhase = 0;
        this.shader.send("shimmerPhase", -10.0);
      } else {
        this.shimmerPhase = nextPhase;
        this.shader.send("shimmerPhase", this.shimmerPhase);
      }
    } else {
      this.delayTimer -= deltaTime;
      if (this.delayTimer <= 0) {
        this.isSweeping = true;
        this.shimmerPhase = 0;
      }
      // Keep hidden during entire delay
      this.shader.send("shimmerPhase", -10.0);
    }
  }
}
