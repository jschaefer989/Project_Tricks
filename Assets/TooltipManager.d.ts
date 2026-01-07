import Asset from "./Asset";
import FontWithPosition from "./FontWithPosition";
import Tooltip from "./Tooltip";
export default class TooltipManager {
    tooltips: Map<string, Tooltip[]>;
    constructor();
    drawTooltips(): void;
    addTooltip(texts: FontWithPosition[], associatedAsset: Asset): void;
    private getTooltipBackground;
    private getTooltipHeight;
    private addAsset;
    hideTooltip(): void;
}
