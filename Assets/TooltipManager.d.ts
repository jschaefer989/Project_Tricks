import Asset from "./Asset";
import FontWithPosition from "./FontWithPosition";
import Tooltip from "./Tooltip";
import GameManager from "GameManager";
export default class TooltipManager {
    gameManager: GameManager;
    tooltips: Map<string, Tooltip[]>;
    constructor(gameManager: GameManager);
    drawTooltips(): void;
    addTooltip(texts: FontWithPosition[], associatedAsset: Asset): void;
    private getTooltipBackground;
    private getTooltipHeight;
    private addAsset;
    hideTooltip(): void;
}
