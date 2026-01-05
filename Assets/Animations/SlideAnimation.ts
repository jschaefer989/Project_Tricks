import { isEmpty } from "Helpers";
import Asset from "../Asset"
import Animation, { AnimationAssets } from "./Animation"

interface ConstructionOptions {
    readonly animDuration?: number;    
}

export default class SlideAnimation extends Animation {
    animOffsetX: number = 0  // Current animation offset
    animOffsetY: number = 0  // Current animation offset
    animTargetOffsetX: number = 0  // Target animation offset
    animTargetOffsetY: number = 0  // Target animation offset (e.g., -20 for up)

    constructor(offsetX: number, offsetY: number, assets: AnimationAssets[], constructionOptions?: ConstructionOptions) {
        super(assets, constructionOptions);
        this.animTargetOffsetX = offsetX
        this.animTargetOffsetY = offsetY
        this.animElapsed = 0
        this.isAnimating = true
        this.assets = assets
    }

    updateAnimation(deltaTime: number): void {
        if (!this.isAnimating) {
            return
        }

        this.animElapsed += deltaTime
        
        if (this.animElapsed >= this.animDuration) {
            // Animation complete
            this.animElapsed = this.animDuration
            this.isAnimating = false
        }

        // Interpolate animation offset
        const progress = this.animElapsed / this.animDuration
        this.animOffsetX = this.animTargetOffsetX * progress
        this.animOffsetY = this.animTargetOffsetY * progress

        this.updateX(this.animOffsetX)
        this.updateY(this.animOffsetY)
    }

    get isFinished(): boolean {
        return !this.isAnimating
    }
}