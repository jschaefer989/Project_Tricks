import { Image } from "love.graphics";
import { ConstructionOptions } from "./Asset";
import Asset from "./Asset";

export default class IconAsset extends Asset {

    constructor(
        id: string,
        image: Image,
        width: number,
        height: number,
        constructionOptions?: ConstructionOptions
    ) {
        super(id, image, 0, 0, width, height, constructionOptions);
    }

    static getPowerIconAsset(id: string): IconAsset {
        return new IconAsset(id, love.graphics.newImage("Assets/Images/AttackPower.png"),  9, 9)
    }

    static getValueIconAsset(id: string): IconAsset {
        return new IconAsset(id, love.graphics.newImage("Assets/Images/Value.png"), 9, 9)
    }
}