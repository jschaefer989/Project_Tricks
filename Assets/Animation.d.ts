import Asset from "./Asset";
export default class Animation {
    animDuration: number;
    animElapsed: number;
    animOffsetX: number;
    animOffsetY: number;
    animTargetOffsetX: number;
    animTargetOffsetY: number;
    isAnimating: boolean;
    originalX: number;
    originalY: number;
    asset: Asset;
    constructor(offsetX: number, offsetY: number, asset: Asset);
    updateAnimation(deltaTime: number): void;
    get isFinished(): boolean;
}
