import GameManager from "GameManager";
import Animation from "./Animation";
import WobbleAnimation from "./WobbleAnimation";
import CutAnimation from "./CutAnimation";
import FlickerAnimation from "./FlickerAnimation";
import { isEmpty } from "Helpers";

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
      if (this.shouldWaitForAnimations(animation)) {
        continue;
      }
      if (!isEmpty(animation.soundToPlay) && !animation.playedSound) {
        animation.soundToPlay.play();
        animation.playedSound = true;
      }
    

      animation.updateAnimation(dt);
      if (animation.isFinished) {
        this.animations.delete(id);
        animation.onFinish?.();
      }
    }
  }

  private shouldWaitForAnimations(animation: Animation): boolean {
    if (animation.waitForAnimationIds.length > 0) {
      for (const waitId of animation.waitForAnimationIds) {
        const waitForAnimation = this.animations.get(waitId);
        if (!isEmpty(waitForAnimation) && !waitForAnimation.isFinished) {
          return true;
        }
      }
    }
    return false;
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

  hasFlickerAnimation(): boolean {
    for (const animation of this.animations.values()) {
      if (animation instanceof FlickerAnimation) {
        return true;
      }
    }
    return false;
  }

  hasAnimations(): boolean {
    return this.animations.size > 0;
  }

  getCardAnimationIds(): string[] {
      return Array.from(this.animations.keys()).filter((id: string) => id.startsWith('CARD'));
  }
}