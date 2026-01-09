import GameManager from "GameManager";
import Shader, { ShaderAssets } from "./Shader";
export default class ShimmerShader extends Shader {
    private shimmerPhase;
    private sweepDuration;
    private delayDuration;
    private isSweeping;
    private delayTimer;
    constructor(gameManager: GameManager, stopCondition: () => boolean, assets: ShaderAssets[]);
    updateShader(deltaTime: number): void;
}
