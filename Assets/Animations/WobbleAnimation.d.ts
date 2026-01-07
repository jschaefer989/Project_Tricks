import Animation, { AnimationAssets, ConstructionOptions } from "./Animation";
export default class WobbleAnimation extends Animation {
    wobbleAmount: number;
    originalX: Map<string, number>;
    constructor(wobbleAmount: number, assets: AnimationAssets[], constructionOptions?: ConstructionOptions);
    updateAnimation(deltaTime: number): void;
}
