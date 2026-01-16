import { Image } from "love.graphics";
export default class AssetLoader {
    loadedAssets: Map<string, Image>;
    loadImage(path: string): Image;
}
