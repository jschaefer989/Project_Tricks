import Asset from "../Asset";
import FontWithPosition from "Assets/Fonts/FontWithPosition";
import { Source } from "love.audio";
import GameManager from "GameManager";
export interface AnimationOptions {
    readonly animDuration?: number;
    readonly onFinish?: () => void;
    readonly waitForAnimationIds?: string[];
    readonly stopAnimationCondition?: () => boolean;
    readonly soundToPlay?: Source;
}
export type AnimationAssets = Asset | FontWithPosition;
export default abstract class Animation {
    gameManager: GameManager;
    id: string;
    animDuration?: number;
    animElapsed: number;
    isAnimating: boolean;
    hasStarted: boolean;
    assets: AnimationAssets[];
    originalX: Map<string, number>;
    originalY: Map<string, number>;
    onFinish?: () => void;
    waitForAnimationIds: string[];
    stopAnimationCondition?: () => boolean;
    soundToPlay?: Source;
    playedSound: boolean;
    isPaused: boolean;
    constructor(gameManager: GameManager, id: string, assets: AnimationAssets[], constructionOptions?: AnimationOptions);
    updateAnimation(deltaTime: number): void;
    get isFinished(): boolean;
    getAssets(): AnimationAssets[];
    updateX(deltaX: number): void;
    updateY(deltaY: number): void;
    shouldWaitForAnimations(): boolean;
}
