import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
import GameManager from "GameManager";
interface ConstructionOptions extends AnimationOptions {
    readonly glowStrength?: number;
    readonly glowPeriodSeconds?: number;
}
export default class GlowAnimation extends Animation {
    private originalColors;
    private glowStrength;
    private pulsePeriod;
    constructor(gameManager: GameManager, id: string, stopCondition: () => boolean, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
    private storeOriginalColors;
    private restoreOriginalColors;
}
export {};
