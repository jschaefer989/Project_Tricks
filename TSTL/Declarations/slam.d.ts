// Typings for SLAM (Simple LÖVE Audio Manager)
// https://github.com/vrld/slam

// Usage at runtime (once):
//   require("Libraries.slam-master.slam")
// or in TS to get types + side effects:
//   import "Libraries.slam-master.slam";

// Augment love.audio with SLAM-specific APIs
declare module "love.audio" {
  // SLAM augments Love's Source instances with these additional APIs at runtime
  interface Source {
    // Playback controls across all managed instances
    resume(): void;

    // Tagging helpers
    addTags(...tags: string[]): void;
    removeTags(...tags: string[]): void;

    // Utility specific to SLAM's wrapped source
    isStatic(): boolean;
  }

  // A tag proxy that forwards any method to all sources with that tag
  interface SlamTag {
    // Commonly used methods (forwarded to all tagged sources)
    setVolume(volume: number): void;
    setPitch(pitch: number): void;
    setLooping(looping: boolean): void;
    play(): void;
    stop(): void;
    pause(): void;
    resume(): void;

    // Fallback for additional forwarded functions
    [forwardedFunction: string]: (...args: any[]) => void;
  }

  interface SlamTags {
    readonly [tag: string]: SlamTag;
  }

  // Tag entry-point exposed by SLAM at runtime
  const tags: SlamTags;
}

// Module declaration so you can import for side effects and type discovery
declare module "Libraries.slam-master.slam" {
  // No exports; requiring this module augments love.audio at runtime
}
