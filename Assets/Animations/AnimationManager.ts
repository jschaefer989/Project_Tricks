import Animation from "./Animation"
import WobbleAnimation from "./WobbleAnimation"

export default class AnimationManager {
    animations: Map<string, Animation> = new Map<string, Animation>()

    constructor() {

    }

    startAnimation(id: string, animation: Animation): void {
        this.animations.set(id, animation)
    }

    updateAnimations(dt: number): void {
        for (const [id, animation] of this.animations) {
            animation.updateAnimation(dt)
            if (animation.isFinished) {
                this.animations.delete(id)
            }
        }
    }

    hasWobbleAnimation(): boolean {
        for (const animation of this.animations.values()) {
            if (animation instanceof WobbleAnimation) {
                return true
            }
        }
        return false
    }
}
