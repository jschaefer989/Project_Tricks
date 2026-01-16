import GameManager from "GameManager";
import { Image } from "love.graphics";
export declare enum PopupSizes {
    MESSAGE_BOX = "MESSAGE_BOX",
    MENU = "MENU"
}
export interface PopupConstructionOptions {
    readonly onClose?: () => void;
    readonly animateIn?: boolean;
}
export default class Popup {
    gameManager: GameManager;
    id: string;
    isActive: boolean;
    associatedAssetIds: string[];
    associatedTextIds: string[];
    popupSize: PopupSizes;
    private savedMusicVolume;
    private pausedAnimationIds;
    private disabledStateCache;
    private pausedShaderIds;
    private pausedSources;
    private pausedTextIds;
    private onClose?;
    constructor(gameManager: GameManager, id: string, popupSize: PopupSizes, title: string, associatedAssetIds: string[], associatedTextIds: string[], options?: PopupConstructionOptions);
    close(): void;
    buildPopup(): void;
    getPopupBackground(): Image;
    startSlideAnimation(): void;
    buildCaches(): void;
    addTitle(title: string): void;
    getTitleOffset(): number;
    pauseAllAnimations(): void;
    pauseAllShaders(): void;
    disableAllAssets(): void;
    disableAllText(): void;
    lowerMusicVolume(): void;
    restoreMusicVolume(): void;
    resumeAllAnimations(): void;
    resumeAllShaders(): void;
    enableAllAssets(): void;
    enableAllText(): void;
    playPausedSounds(): void;
    handleMousePressed(x: number, y: number, button: number): boolean;
    handleMouseReleased(x: number, y: number, button: number): boolean;
    drawPopup(): void;
    removeAssets(): void;
    removeTexts(): void;
    static getPopupWidth(popupSize: PopupSizes): number;
    static getPopupHeight(popupSize: PopupSizes): number;
    static getTopOfPopup(popupSize: PopupSizes): number;
    static getCenterOfPopup(popupSize: PopupSizes): number;
    static getBottomOfPopup(popupSize: PopupSizes): number;
    getPopupBackgroundId(): string;
    getPopupTitleId(): string;
}
