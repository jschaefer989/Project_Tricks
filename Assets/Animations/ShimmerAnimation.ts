import Animation, { AnimationAssets, AnimationOptions } from "./Animation";

interface ConstructionOptions extends AnimationOptions {
  readonly shimmerSpeed?: number;
}

export default class ShimmerAnimation extends Animation {
  private shimmerSpeed = 0.015;
  private shimmerShader = love.graphics.newShader(`
        uniform float shimmerPhase;
        
        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) {
          vec4 pixel = Texel(tex, tc);
          
          // Create a diagonal streak based on shimmerPhase
          float streak = (tc.x + tc.y * 0.5 - shimmerPhase * 1.5);
          streak = mod(streak + 1.0, 1.0);
          
          // Make a sharp line with smooth edges
          float lineWidth = 0.15;
          float brightness = smoothstep(0.0, lineWidth * 0.3, streak) * 
                           (1.0 - smoothstep(lineWidth * 0.7, lineWidth, streak));
          
          // Add brightness to the streak
          pixel.rgb += vec3(brightness * 0.6);
          
          return pixel * color;
        }
      `);
  private shimmerPhase = 0;

  constructor(stopCondition: () => boolean, assets: AnimationAssets[], constructionOptions?: ConstructionOptions) {
    super(assets, constructionOptions);
    this.shimmerSpeed = constructionOptions?.shimmerSpeed ?? this.shimmerSpeed;
    this.stopAnimationCondition = stopCondition;

    
    // Create shimmer shader if SHIMMER effect is enabled
      this.shimmerShader 
    }

  updateAnimation(deltaTime: number): void {
    super.updateAnimation(deltaTime);
    if (!this.isAnimating) {    
      love.graphics.setShader();
      return;
    }

    // TODO: shader manager

    //love.graphics.setShader(this.shimmerShader);
    //   this.shimmerShader.send("shimmerPhase", this.shimmerPhase);

    //     this.shimmerPhase += this.shimmerSpeed;
    //     if (this.shimmerPhase > 1.0) {
    //       this.shimmerPhase = 0;
    //     }
  }
}
