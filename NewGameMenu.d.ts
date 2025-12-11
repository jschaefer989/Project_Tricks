/** @noSelfInFile */
import GameManager from "GameManager";
export default class NewGameMenu {
    gameManager: GameManager;
    nameInput: {
        text: string;
        forcefocus?: boolean;
    };
    constructor(gameManager: GameManager);
    drawScreen(): void;
    renderDisplayTitle(panelX: number): void;
    renderPlayerNameLabel(panelX: number): number;
    renderPlayerNameField(panelX: number, inputY: number): void;
    renderStartButton(panelX: number, inputY: number): number;
    renderBackButton(panelX: number, startBtnY: number): void;
    handleStartGame(): void;
}
