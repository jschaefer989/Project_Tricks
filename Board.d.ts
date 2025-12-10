/** @noSelfInFile */
import { CharacterTypes } from "./Enums";
import Dealer from "./Dealer";
import Enemy, { EnemyData } from "./Enemy";
import GameManager from "./GameManager";
interface BoardData {
    discardUsed?: number;
    playerPoints?: number;
    enemyPoints?: number;
    enemy?: EnemyData;
}
export default class Board {
    gameManager: GameManager;
    discardUsed: number;
    enemy: Enemy;
    dealer: Dealer;
    playerPoints: number;
    enemyPoints: number;
    constructor(gameManager: GameManager);
    load(data: BoardData): void;
    save(): BoardData;
    drawBoard(): void;
    getStartingCoordinates(contentW: number, btnH: number, groupH: number, padY: number): {
        startX: number;
        startY: number;
    };
    getContentWidth(): number;
    getCashout(): number;
    renderWinStatus(): void;
    renderPointsDisplay(): void;
    renderEnemyStatsPanel(padX: number, padY: number): void;
    renderEnemyDeckVisualization(): void;
    renderPlayerSelectedStatsPanel(): void;
    renderPlayerInfoPanel(padX: number, padY: number): void;
    renderPlayerDeckVisualization(): void;
    renderEnemyRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayerRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayButton(startY: number, btnW: number, btnH: number, padX: number, padY: number): void;
    renderDiscardCounter(): void;
    handlePlay(): void;
    handleDiscard(): void;
    getWinner(): CharacterTypes;
    endFight(): void;
}
export {};
