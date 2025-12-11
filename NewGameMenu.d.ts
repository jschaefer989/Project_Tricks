/** @noSelfInFile */
import GameManager from "GameManager";
export default class NewGameMenu {
    gameManager: GameManager;
    nameInput: {
        text: string;
    };
    constructor(gameManager: GameManager);
    drawScreen(): void;
}
