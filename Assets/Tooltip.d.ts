import Asset from "./Asset";
import FontWithPosition from "./Fonts/FontWithPosition";
export default class Tooltip {
    asset: Asset;
    texts: FontWithPosition[];
    constructor(asset: Asset, texts: FontWithPosition[]);
}
