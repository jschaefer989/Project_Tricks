import Animation from "./Animation"

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
}
