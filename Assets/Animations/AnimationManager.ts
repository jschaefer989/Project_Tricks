import GameManager from "GameManager";
import Animation from "./Animation";
import WobbleAnimation from "./WobbleAnimation";
import CutAnimation from "./CutAnimation"

export default class AnimationManager {
  gameManager: GameManager;
  animations: Map<string, Animation> = new Map<string, Animation>();

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  startAnimation(id: string, animation: Animation): void {
    this.animations.set(id, animation);
  }

  updateAnimations(dt: number): void {
    for (const [id, animation] of this.animations) {
      animation.updateAnimation(dt);
      if (animation.isFinished) {
        this.animations.delete(id);
        animation.onFinish?.();
      }
    }
  }

  drawAnimations(): void {
    for (const animation of this.animations.values()) {
      animation.drawAnimation();
    }
  }

  hasWobbleAnimation(): boolean {
    for (const animation of this.animations.values()) {
      if (animation instanceof WobbleAnimation) {
        return true;
      }
    }
    return false;
  }

  hasCutAnimation(): boolean {
    for (const animation of this.animations.values()) {
      if (animation instanceof CutAnimation) {
        return true;
      }
    }
    return false;
  }
}
