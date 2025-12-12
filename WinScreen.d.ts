import GameManager from "./GameManager";
import Card from "Card";
/**
 * WinScreen class handles the display of the victory screen
 */
export default class WinScreen {
    gameManager: GameManager;
    constructor(gameManager: GameManager);
    drawScreen(): void;
    renderVictoryLabel(): void;
    /**
     *
     * @param x
     * @param y
     * @param panelW
     * @returns
     */
    renderPlayerInfoPanel(x: number, y: number, panelW: number): number;
    renderLootCards(panelX: number, startY: number, panelW: number): number;
    handleLootCardSelection(card: Card): void;
    addLootCardsToPlayer(): void;
}
