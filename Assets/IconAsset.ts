import { Image } from "love.graphics";
import { ConstructionOptions } from "./Asset";
import Asset from "./Asset";
import GameManager from "GameManager";

export default class IconAsset extends Asset {

    constructor(
        gameManager: GameManager,
        id: string,
        image: Image,
        width: number,
        height: number,
        constructionOptions?: ConstructionOptions
    ) {
        super(gameManager, id, image, 0, 0, width, height, constructionOptions);
    }

    static getPowerIconAsset(gameManager: GameManager, id: string): IconAsset {
        return new IconAsset(gameManager, id, love.graphics.newImage("Assets/Images/AttackPower.png"),  9, 9)
    }

    static getValueIconAsset(gameManager: GameManager, id: string): IconAsset {
        return new IconAsset(gameManager, id, love.graphics.newImage("Assets/Images/Value.png"), 9, 9)
    }
}