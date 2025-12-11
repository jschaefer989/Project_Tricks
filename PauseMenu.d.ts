/** @noSelfInFile */
import GameManager from "GameManager";
export default class PauseMenu {
    gameManager: GameManager;
    constructor(gameManager: GameManager);
    drawScreen(): void;
    renderDisplayTitle(panelX: number): void;
    renderContinueButton(panelX: number): number;
    renderSaveButton(panelX: number, continueBtnY: number): number;
    renderQuitButton(panelX: number, saveBtnY: number): void;
}
