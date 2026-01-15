/** @noSelfInFile */
import GameManager from "GameManager";
export default class PauseMenu {
    gameManager: GameManager;
    button: import("love.graphics").Image;
    isOpen: boolean;
    constructor(gameManager: GameManager);
    showPauseMenu(): void;
    buildContinueButton(): number;
    buildSaveButton(continueButtonY: number): number;
    buildQuitButton(saveButtonY: number): void;
    canSave(): boolean;
    promptToQuit(): void;
}
