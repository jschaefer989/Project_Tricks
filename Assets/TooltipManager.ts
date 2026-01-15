import { AssetIds } from "Enums";
import Asset from "./Asset";
import FontWithPosition from "./Fonts/FontWithPosition";
import Tooltip from "./Tooltip";
import { isEmpty } from "Helpers";
import { Image } from "love.graphics";
import GameManager from "GameManager";
import * as push from "Libraries.push";

export default class TooltipManager {
  gameManager: GameManager;
  tooltips: Map<string, Tooltip[]> = new Map<string, Tooltip[]>();

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  drawTooltips(): void {
    for (const tooltips of this.tooltips.values()) {
      if (isEmpty(tooltips) || tooltips.length === 0) {
        continue;
      }
      for (const tooltip of tooltips) {
        tooltip.asset.drawAsset();
        for (const text of tooltip.texts) {
          text.printText();
        }
      }
    }
  }

  addTooltip(texts: FontWithPosition[], associatedAsset: Asset): void {
    const padding = 10;
    const tooltipWidth = 128;

    const screenW = push.getWidth();
    const defaultX = associatedAsset.x + associatedAsset.getWidth() + padding;
    const placeRight = defaultX + tooltipWidth <= screenW;
    const tooltipX = placeRight
      ? defaultX
      : math.max(padding, associatedAsset.x - padding - tooltipWidth);
    const tooltipY = associatedAsset.y;

    // Update text positions based on calculated tooltip position
    for (const text of texts) {
      text.x = text.x + tooltipX;
      text.y = text.y + tooltipY;

      text.limit = 120;
      text.alignMode = "center";
    }

    // Draw background with dynamic sizing
    const tooltipImage = this.getTooltipBackground(texts);
    if (isEmpty(tooltipImage)) {
      throw new Error("No tooltip background found for the given texts.");
    }
    this.addAsset(
      AssetIds.TOOLTIP_BACKGROUND,
      new Asset(
        this.gameManager,
        AssetIds.TOOLTIP_BACKGROUND,
        tooltipImage,
        tooltipX,
        tooltipY,
        tooltipWidth,
        this.getTooltipHeight(texts)
      ),
      texts
    );
  }

  private getTooltipBackground(texts: FontWithPosition[]): Image | undefined {
    if (texts.length === 2) {
      return love.graphics.newImage("Assets/Images/TooltipTwo.png");
    }
    if (texts.length === 3) {
      return love.graphics.newImage("Assets/Images/TooltipThree.png");
    }
  }

  private getTooltipHeight(texts: FontWithPosition[]): number {
    if (texts.length === 3) {
      return 44;
    }
    return 0;
  }

  private addAsset(id: string, asset: Asset, texts: FontWithPosition[]): void {
    if (!this.tooltips.has(id)) {
      this.tooltips.set(id, []);
    }
    this.tooltips.get(id)?.push(new Tooltip(asset, texts));
  }

  hideTooltip(): void {
    this.tooltips.delete(AssetIds.TOOLTIP_BACKGROUND);
  }
}
