import GameManager from "GameManager";
import Popup, { PopupConstructionOptions, PopupSizes } from "./Popup";
export default class PopupManager {
    gameManager: GameManager;
    popups: Popup[];
    popupAssetIds: string[];
    popupTextIds: string[];
    constructor(gameManager: GameManager);
    open(id: string, title: string, popupSize: PopupSizes, constructionOptions?: PopupConstructionOptions): void;
    close(): void;
    getActivePopup(): Popup | undefined;
    handleMousePressed(x: number, y: number, button: number): boolean;
    handleMouseReleased(x: number, y: number, button: number): boolean;
    drawPopups(): void;
}
