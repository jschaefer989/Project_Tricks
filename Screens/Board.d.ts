/** @noSelfInFile */
import { CharacterTypes, Suits } from "../Enums";
import Dealer from "../Dealer";
import Enemy, { EnemyData } from "Enemies/Enemy";
import GameManager from "../GameManager";
interface BoardData {
    discardUsed: number;
    playerPoints: number;
    enemyPoints: number;
    enemy: EnemyData;
    trumpSuit: Suits;
    playerPower: number;
    playerValue: number;
    enemyPower: number;
    enemyValue: number;
}
export default class Board {
    gameManager: GameManager;
    discardUsed: number;
    enemy: Enemy;
    dealer: Dealer;
    playerPoints: number;
    enemyPoints: number;
    trumpSuit: Suits;
    playerPower: number;
    playerValue: number;
    enemyPower: number;
    enemyValue: number;
    showingInitialView: boolean;
    constructor(gameManager: GameManager, enemy?: Enemy);
    load(data: BoardData): void;
    save(): BoardData;
    drawBoard(): void;
    drawInitialView(): void;
    drawNormalView(): void;
    getStartingCoordinates(contentW: number, btnH: number, groupH: number, padY: number): {
        startX: number;
        startY: number;
    };
    getContentWidth(): number;
    getPlayerCashout(): number;
    getEnemyCashout(): number;
    renderWinStatus(): void;
    renderTrumpSuitLabel(): void;
    renderPointsDisplay(): void;
    renderEnemyStatsPanel(padX: number, padY: number): void;
    renderEnemyDeck(): void;
    renderPlayerSelectedStatsPanel(): void;
    renderEnemyRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayerRowInitial(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayerRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderLetsFightButton(startY: number, btnW: number, btnH: number): void;
    renderPlayButton(startY: number, btnW: number, btnH: number, padX: number, padY: number): void;
    renderDiscardCounter(): void;
    handleAttack(): void;
    handleDiscard(): void;
    getWinner(): CharacterTypes;
    endFight(): void;
}
export {};
