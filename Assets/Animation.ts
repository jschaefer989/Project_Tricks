import Asset from "./Asset"

export default class Animation {
    animDuration: number = 0.15  // seconds
    animElapsed: number = 0
    animOffsetX: number = 0  // Current animation offset
    animOffsetY: number = 0  // Current animation offset
    animTargetOffsetX: number = 0  // Target animation offset
    animTargetOffsetY: number = 0  // Target animation offset (e.g., -20 for up)
    isAnimating: boolean = false
    originalX: number = 0
    originalY: number = 0   
    asset: Asset 

    constructor(offsetX: number, offsetY: number, asset: Asset) {
        this.originalX = asset.x
        this.originalY = asset.y
        this.animTargetOffsetX = offsetX
        this.animTargetOffsetY = offsetY
        this.animElapsed = 0
        this.isAnimating = true
        this.asset = asset
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
        
        this.asset.y = this.originalY + this.animOffsetY
        this.asset.x = this.originalX + this.animOffsetX
    }

    get isFinished(): boolean {
        return !this.isAnimating
    }
}