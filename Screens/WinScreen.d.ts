import GameManager from "../GameManager";
import Card from "Cards/Card";
/**
 * WinScreen class handles the display of the victory screen
 */
export default class WinScreen {
    gameManager: GameManager;
    constructor(gameManager: GameManager);
    drawScreen(): void;
    renderVictoryLabel(): void;
    renderLootCards(panelX: number, startY: number, panelW: number): number;
    handleLootCardSelection(card: Card): void;
    addLootCardsToPlayer(): void;
}
