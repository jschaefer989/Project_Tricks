/** @noSelfInFile */

import GameManager from "../GameManager";
import {
  AssetIds,
  HoverEffects,
  MousePressEffects,
  PopupIds,
  TextIds,
} from "Enums";
import Popup, { PopupSizes } from "./Popup/Popup";
import Asset from "Assets/Asset";
import FontWithPosition, { Format } from "Assets/Fonts/FontWithPosition";

const buttonWidth = 78;
const buttonHeight = 27;

export default class PerkScreen {
  gameManager: GameManager;

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  showPerks(): void {
    this.buildPerks();
    this.buildReturnButton();

    this.gameManager.popupManager.open(
      PopupIds.PERKS,
      "Perks",
      PopupSizes.MENU
    );
  }

  buildPerks(): void {
    const perks = this.gameManager.player.perks;
    if (perks.length === 0) {
      const noPerksText = new FontWithPosition(
        TextIds.PERKS_NO_PERKS_TEXT,
        Popup.getCenterOfPopup(PopupSizes.MENU),
        Popup.getTopOfPopup(PopupSizes.MENU) + 100,
        "No perks acquired yet.",
        { format: Format.CENTER, size: 18 }
      );
      this.gameManager.popupManager.addText(
        TextIds.PERKS_NO_PERKS_TEXT,
        noPerksText
      );
      return;
    }
    let currentY = Popup.getTopOfPopup(PopupSizes.MENU) + 50;
    const centerX = Popup.getCenterOfPopup(PopupSizes.MENU);
    for (const perk of perks) {
      const perkText = new FontWithPosition(
        perk.perkType,
        centerX,
        currentY,
        perk.getPerkName(),
        { format: Format.CENTER, size: 9 }
        );
        this.gameManager.popupManager.addText(
            perk.perkType,
            perkText
        );
        currentY += 30;
    }
  }

  buildReturnButton(): number {
    const returnButtonY = Popup.getBottomOfPopup(PopupSizes.MENU) - 50;
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MENU);

    const returnText = new FontWithPosition(
      TextIds.PERKS_RETURN_BUTTON_CAPTION,
      popupCenterX,
      returnButtonY + buttonHeight / 2 - 1,
      "Return",
      { format: Format.CENTER, size: 9 }
    );

    const returnButton = new Asset(
      this.gameManager,
      AssetIds.PERKS_RETURN_BUTTON,
      this.gameManager.assetManager.assetLoader.loadImage(
        "Assets/Images/MessageBoxButton.png"
      ),
      popupCenterX - buttonWidth / 2,
      returnButtonY,
      buttonWidth,
      buttonHeight,
      {
        onClick: () => {
          this.gameManager.popupManager.close();
        },
        associatedTexts: [returnText],
        clickSound: this.gameManager.assetManager.buttonClickSound,
        hoverEffect: [HoverEffects.CHANGE_COLOR],
        mousePressEffect: [
          MousePressEffects.DARKEN,
          MousePressEffects.SHIFT_DOWN,
        ],
      }
    );

    this.gameManager.popupManager.addText(
      TextIds.PERKS_RETURN_BUTTON_CAPTION,
      returnText
    );
    this.gameManager.popupManager.addAsset(
      AssetIds.PERKS_RETURN_BUTTON,
      returnButton
    );

    return returnButtonY;
  }
}
