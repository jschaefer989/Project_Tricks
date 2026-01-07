import { Image } from "love.graphics";
import { ConstructionOptions } from "./Asset";
import Asset from "./Asset";
export default class IconAsset extends Asset {
    constructor(id: string, image: Image, width: number, height: number, constructionOptions?: ConstructionOptions);
    static getPowerIconAsset(id: string): IconAsset;
    static getValueIconAsset(id: string): IconAsset;
}
