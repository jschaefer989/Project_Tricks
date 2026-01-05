import Asset from "../Asset";
import FontWithPosition from "Assets/FontWithPosition";
export interface ConstructionOptions {
    readonly animDuration?: number;
}
export type AnimationAssets = Asset | FontWithPosition;
export default abstract class Animation {
    animDuration: number;
    animElapsed: number;
    isAnimating: boolean;
    assets: AnimationAssets[];
    originalX: Map<string, number>;
    originalY: Map<string, number>;
    constructor(assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    abstract updateAnimation(deltaTime: number): void;
    get isFinished(): boolean;
    updateX(deltaX: number): void;
    updateY(deltaY: number): void;
}
