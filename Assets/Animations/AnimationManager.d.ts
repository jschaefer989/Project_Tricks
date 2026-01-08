import GameManager from "GameManager";
import Animation from "./Animation";
export default class AnimationManager {
    gameManager: GameManager;
    animations: Map<string, Animation>;
    constructor(gameManager: GameManager);
    startAnimation(id: string, animation: Animation): void;
    updateAnimations(dt: number): void;
    private shouldWaitForAnimations;
    hasWobbleAnimation(): boolean;
    hasCutAnimation(): boolean;
    hasFlickerAnimation(): boolean;
    hasAnimations(): boolean;
    getCardAnimationIds(): string[];
}
