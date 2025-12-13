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
    showingInitialView: boolean;
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
    renderWinStatus(startX: number, startY: number): void;
    renderTrumpSuitLabel(): void;
    renderPointsDisplay(): void;
    renderEnemyStats(startX: number, startY: number): void;
    renderEnemyDeck(): void;
    renderPlayerSelectedStats(startX: number, startY: number, contentW: number, btnW: number): void;
    renderEnemyRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayerRowInitial(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderPlayerRow(startX: number, startY: number, contentW: number, btnW: number, btnH: number, lblH: number, padX: number, padY: number): void;
    renderLetsFightButton(startY: number, btnW: number, btnH: number): void;
    renderAttackButton(startY: number, btnW: number, btnH: number, padX: number, padY: number): void;
    renderDiscardCounter(): void;
    handleAttack(): void;
    handleDiscard(): void;
    getWinner(): CharacterTypes;
    endFight(): void;
    clearStats(): void;
}
export {};
