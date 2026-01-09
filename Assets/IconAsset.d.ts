import { Image } from "love.graphics";
import { ConstructionOptions } from "./Asset";
import Asset from "./Asset";
import GameManager from "GameManager";
export default class IconAsset extends Asset {
    constructor(gameManager: GameManager, id: string, image: Image, width: number, height: number, constructionOptions?: ConstructionOptions);
    static getPowerIconAsset(gameManager: GameManager, id: string): IconAsset;
    static getValueIconAsset(gameManager: GameManager, id: string): IconAsset;
}
