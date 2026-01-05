
import Asset from "../Asset"
import FontWithPosition from "Assets/FontWithPosition";

export interface ConstructionOptions {
    readonly animDuration?: number;    
}

export type AnimationAssets = Asset | FontWithPosition;

export default abstract class Animation {
    animDuration: number
    animElapsed = 0
    isAnimating = false
    assets: AnimationAssets[]
    originalX: Map<string, number> = new Map<string, number>()
    originalY: Map<string, number> = new Map<string, number>()

    constructor(assets: AnimationAssets[], constructionOptions?: ConstructionOptions) {
        this.animDuration = constructionOptions?.animDuration ?? 0.15
        this.animElapsed = 0
        this.isAnimating = true
        this.assets = assets
        this.originalX = new Map(assets.map(asset => [asset.id, asset.x]))
        this.originalY = new Map(assets.map(asset => [asset.id, asset.y]))
    }

    abstract updateAnimation(deltaTime: number): void

    get isFinished(): boolean {
        return !this.isAnimating
    }

    updateX(deltaX: number): void {
        this.assets.forEach(asset => {
            const originalX = this.originalX.get(asset.id);
            if (originalX !== undefined) {
                asset.x = originalX + deltaX;
            }
        });
    }

    updateY(deltaY: number): void {
        this.assets.forEach(asset => {
            const originalY = this.originalY.get(asset.id);
            if (originalY !== undefined) {
                asset.y = originalY + deltaY;
            }
        });
    }
}