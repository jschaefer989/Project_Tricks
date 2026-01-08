import { GameStates } from "Enums";
import GameManager from "GameManager";
import { Image } from "love.graphics";
export default class BackgroundManager {
    gameManager: GameManager;
    constructor(gameManager: GameManager);
    updateBackground(gameState: GameStates): void;
    getBackgroundImage(gameState: GameStates): Image | undefined;
}
