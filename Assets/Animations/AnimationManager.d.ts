import Animation from "./Animation";
export default class AnimationManager {
    animations: Map<string, Animation>;
    constructor();
    startAnimation(id: string, animation: Animation): void;
    updateAnimations(dt: number): void;
    hasWobbleAnimation(): boolean;
}
