/** @noSelfInFile */

import Asset from "Assets/Asset";
import FontWithPosition, { Format } from "Assets/Fonts/FontWithPosition";
import { AssetIds, HoverEffects, MousePressEffects, PopupIds, TextIds } from "Enums";
import GameManager from "GameManager";
import Save from "Save";
import Popup, { PopupSizes } from "./Popup/Popup";
import Prompt from "./Prompt";

const buttonWidth = 192;
const buttonHeight = 64;

export default class PauseMenu {
  gameManager: GameManager;
  isOpen = false;

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  showPauseMenu(): void {
    const continueButtonY = this.buildContinueButton();
    const saveButtonY = this.buildSaveButton(continueButtonY);
    this.buildQuitButton(saveButtonY);

    this.gameManager.popupManager.open(PopupIds.PAUSE_MENU, "Paused", PopupSizes.MENU, {
      onClose: () => {
        this.isOpen = false;
      },
    });
    this.isOpen = true;
  }

  buildContinueButton(): number {
    const continueButtonY = 50;
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MENU);

    const continueText = new FontWithPosition(
      TextIds.PAUSE_CONTINUE_BUTTON_CAPTION,
      popupCenterX,
      continueButtonY + buttonHeight / 2 - 1,
      "Continue",
      { format: Format.CENTER, size: 18 }
    );

    const continueButton = new Asset(
      this.gameManager,
      AssetIds.PAUSE_CONTINUE_BUTTON,
      this.gameManager.assetManager.assetLoader.loadImage("Assets/Images/PauseMenuButton.png"),
      popupCenterX - buttonWidth / 2,
      continueButtonY,
      buttonWidth,
      buttonHeight,
      {
        onClick: () => {
          this.gameManager.popupManager.close();
        },
        associatedTexts: [continueText],
        clickSound: this.gameManager.assetManager.buttonClickSound,
        hoverEffect: [HoverEffects.CHANGE_COLOR],
        mousePressEffect: [
          MousePressEffects.DARKEN,
          MousePressEffects.SHIFT_DOWN,
        ],
      }
    );

    this.gameManager.popupManager.addText(
      TextIds.PAUSE_CONTINUE_BUTTON_CAPTION,
      continueText
    );
    this.gameManager.popupManager.addAsset(
      AssetIds.PAUSE_CONTINUE_BUTTON,
      continueButton
    );

    return continueButtonY;
  }

  buildSaveButton(continueButtonY: number): number {
    const saveButtonY = continueButtonY + buttonHeight + 10;
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MENU);

    const saveText = new FontWithPosition(
      TextIds.PAUSE_SAVE_BUTTON_CAPTION,
      popupCenterX,
      saveButtonY + buttonHeight / 2 - 1,
      "Save",
      { format: Format.CENTER, size: 18 }
    );

    const saveButton = new Asset(
      this.gameManager,
      AssetIds.PAUSE_SAVE_BUTTON,
      this.gameManager.assetManager.assetLoader.loadImage("Assets/Images/PauseMenuButton.png"),
      popupCenterX - buttonWidth / 2,
      saveButtonY,
      buttonWidth,
      buttonHeight,
      {
        onClick: () => {
          Save.save(this.gameManager);
        },
        associatedTexts: [saveText],
        isDisabled: !this.canSave(),
        clickSound: this.gameManager.assetManager.buttonClickSound,
        hoverEffect: [HoverEffects.CHANGE_COLOR],
        mousePressEffect: [
          MousePressEffects.DARKEN,
          MousePressEffects.SHIFT_DOWN,
        ],
      }
    );

    this.gameManager.popupManager.addText(
      TextIds.PAUSE_SAVE_BUTTON_CAPTION,
      saveText
    );
    this.gameManager.popupManager.addAsset(
      AssetIds.PAUSE_SAVE_BUTTON,
      saveButton
    );

    return saveButtonY;
  }

  buildQuitButton(saveButtonY: number): void {
    const quitButtonY = saveButtonY + buttonHeight + 10;
    const popupCenterX = Popup.getCenterOfPopup(PopupSizes.MENU);

    const quitText = new FontWithPosition(
      TextIds.PAUSE_QUIT_BUTTON_CAPTION,
      popupCenterX,
      quitButtonY + buttonHeight / 2 - 1,
      "Quit",
      { format: Format.CENTER, size: 18 }
    );

    const quitButton = new Asset(
      this.gameManager,
      AssetIds.PAUSE_QUIT_BUTTON,
      this.gameManager.assetManager.assetLoader.loadImage("Assets/Images/PauseMenuButton.png"),
      popupCenterX - buttonWidth / 2,
      quitButtonY,
      buttonWidth,
      buttonHeight,
      {
        onClick: () => this.promptToQuit(),
        associatedTexts: [quitText],
        clickSound: this.gameManager.assetManager.buttonClickSound,
        hoverEffect: [HoverEffects.CHANGE_COLOR],
        mousePressEffect: [
          MousePressEffects.DARKEN,
          MousePressEffects.SHIFT_DOWN,
        ],
      }
    );

    this.gameManager.popupManager.addText(
      TextIds.PAUSE_QUIT_BUTTON_CAPTION,
      quitText
    );
    this.gameManager.popupManager.addAsset(
      AssetIds.PAUSE_QUIT_BUTTON,
      quitButton
    );
  }

  canSave(): boolean {
    // TODO: we'll want to control when saving is allowed
    return true;
  }

  promptToQuit(): void {
    const prompt = new Prompt(
      this.gameManager,
      "Are you sure you want to quit?",
      () =>  love.event.quit(),
      () => this.gameManager.popupManager.close(),
      { secondaryMessage: "All unsaved progress will be lost." }
    );
    prompt.open(PopupIds.QUIT_PROMPT);
  }
}
