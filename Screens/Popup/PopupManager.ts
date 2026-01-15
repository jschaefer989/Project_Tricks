import GameManager from "GameManager";
import Popup, { PopupConstructionOptions, PopupSizes } from "./Popup";
import { isEmpty } from "Helpers";

export default class PopupManager {
  gameManager: GameManager;
  popups: Popup[] = [];
  popupAssetIds: string[] = [];
  popupTextIds: string[] = [];

  constructor(gameManager: GameManager) {
    this.gameManager = gameManager;
  }

  open(id: string, title: string, popupSize: PopupSizes, constructionOptions?: PopupConstructionOptions): void {
    const popup = new Popup(this.gameManager, id, popupSize, title, this.popupAssetIds, this.popupTextIds, constructionOptions);
    const activePopup = this.getActivePopup();
    if (!isEmpty(activePopup)) {
      activePopup.isActive = false;
    }
    this.popups.push(popup);
    this.popupAssetIds = [];
    this.popupTextIds = [];
  }

  close(): void {
    const popup = this.popups.pop();
    if (isEmpty(popup)) return;
    popup.close();
    const activePopup = this.getActivePopup();
    if (!isEmpty(activePopup)) {
      activePopup.isActive = true;
    }
  }

  getActivePopup(): Popup | undefined {
    return this.popups[this.popups.length - 1];
  }

  handleMousePressed(x: number, y: number, button: number): boolean {
    const activePopup = this.getActivePopup();
    return activePopup ? activePopup.handleMousePressed(x, y, button) : false;
  }

  handleMouseReleased(x: number, y: number, button: number): boolean {
    const activePopup = this.getActivePopup();
    return activePopup ? activePopup.handleMouseReleased(x, y, button) : false;
  }

  drawPopups(): void {
    for (const popup of this.popups) {
      popup.drawPopup();
    }
  }
}
