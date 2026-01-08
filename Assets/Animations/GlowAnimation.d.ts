import Animation, { AnimationAssets, AnimationOptions } from "./Animation";
interface ConstructionOptions extends AnimationOptions {
    readonly glowStrength?: number;
    readonly glowPeriodSeconds?: number;
}
export default class GlowAnimation extends Animation {
    private originalColors;
    private glowStrength;
    private pulsePeriod;
    constructor(stopCondition: () => boolean, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
    private storeOriginalColors;
    private restoreOriginalColors;
}
export {};
