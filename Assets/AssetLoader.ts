import { Image } from "love.graphics";

export default class AssetLoader {
  loadedAssets: Map<string, Image> = new Map<string, Image>();

  loadImage(path: string): Image {
    if (this.loadedAssets.has(path)) {
      return this.loadedAssets.get(path)!;
    }
    const image = love.graphics.newImage(path);
    this.loadedAssets.set(path, image);
    return image;
  }
}
