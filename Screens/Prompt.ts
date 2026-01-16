import { AssetIds, HoverEffects, MousePressEffects, TextIds } from "Enums";
import GameManager from "GameManager";
import Popup, { PopupSizes } from "./Popup/Popup";
import FontWithPosition, { Format } from "Assets/Fonts/FontWithPosition";
import Asset from "Assets/Asset";
import { isEmpty } from "Helpers";

const buttonWidth = 78;
const buttonHeight = 27;

interface ConstructorOptions {
  secondaryMessage?: string;
}

export default class Prompt {
  gameManager: GameManager;
  private message: string;
  private onYesClick: () => void;
  private onNoClick: () => void;
  private button = love.graphics.newImage("Assets/Images/MessageBoxButton.png");

  constructor(
    gameManager: GameManager,
    message: string,
    onYesClick: () => void,
    onNoClick: () => void,
    constructionOptions?: ConstructorOptions
  ) {
    this.gameManager = gameManager;
    this.message = message;
    this.onYesClick = onYesClick;
    this.onNoClick = onNoClick;
    this.buildYesButton();
    this.buildNoButton();
    if (!isEmpty(constructionOptions?.secondaryMessage)) {
      const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MESSAGE_BOX);
      const secondaryMessageText = new FontWithPosition(
        TextIds.PROMPT_SECONDARY_MESSAGE,
        popupCenterX,
        Popup.getTopOfPopup(PopupSizes.MESSAGE_BOX) + 40,
        constructionOptions.secondaryMessage,
        { format: Format.CENTER, size: 9 }
      );
      this.gameManager.popupManager.addText(
        TextIds.PROMPT_SECONDARY_MESSAGE,
        secondaryMessageText
      );
    }
  }

  open(id: string): void {
    this.gameManager.popupManager.open(
      id,
      this.message,
      PopupSizes.MESSAGE_BOX,
      { animateIn: false }
    );
  }

  buildYesButton(): void {
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MESSAGE_BOX);

    const yesText = new FontWithPosition(
      TextIds.YES_BUTTON_CAPTION,
      popupCenterX,
      Popup.getTopOfPopup(PopupSizes.MESSAGE_BOX) + 61 + buttonHeight / 2,
      "Yes",
      { format: Format.CENTER, size: 9 }
    );

    const button = new Asset(
        this.gameManager,
        AssetIds.YES_BUTTON,
        this.button,
        popupCenterX - buttonWidth / 2,
        Popup.getTopOfPopup(PopupSizes.MESSAGE_BOX) + 60,
        buttonWidth,
        buttonHeight,
        {
          onClick: this.onYesClick,
          associatedTexts: [yesText],
          clickSound: this.gameManager.assetManager.buttonClickSound,
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
        }
      );

    this.gameManager.popupManager.addAsset(AssetIds.YES_BUTTON, button);
    this.gameManager.popupManager.addText(TextIds.YES_BUTTON_CAPTION, yesText);    
  }

  buildNoButton(): void {
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MESSAGE_BOX);
    const buttonY =
      Popup.getTopOfPopup(PopupSizes.MESSAGE_BOX) + 60 + buttonHeight + 10;
      
    const noText = new FontWithPosition(
      TextIds.NO_BUTTON_CAPTION,
      popupCenterX,
      buttonY + buttonHeight / 2 + 1,
      "No",
      { format: Format.CENTER, size: 9 }
    );

    const button = new Asset(
        this.gameManager,
        AssetIds.NO_BUTTON,
        this.button,
        popupCenterX - buttonWidth / 2,
        buttonY,
        buttonWidth,
        buttonHeight,
        {
          onClick: this.onNoClick,
          associatedTexts: [noText],
          clickSound: this.gameManager.assetManager.buttonClickSound,
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
        }
      )

    this.gameManager.popupManager.addAsset(AssetIds.NO_BUTTON, button);
    this.gameManager.popupManager.addText(TextIds.NO_BUTTON_CAPTION, noText);
  }
}
