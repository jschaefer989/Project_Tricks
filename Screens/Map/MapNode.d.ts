/** @noSelfInFile */
import Enemy, { EnemyData } from "Enemies/Enemy";
import { MapNodeTypes } from "Enums";
import GameManager from "GameManager";
export interface MapNodeData {
    type: MapNodeTypes;
    enemy?: EnemyData;
}
export default class MapNode {
    gameManager: GameManager;
    type: MapNodeTypes;
    enemy?: Enemy;
    swordImage?: any;
    marketImage?: any;
    constructor(gameManager: GameManager);
    load(data: MapNodeData): void;
    save(): MapNodeData;
    getRandomNodeType(): MapNodeTypes;
    drawInteractiveMapNode(x: number, y: number): void;
    drawInteractiveBattleNode(x: number, y: number): void;
    drawInteractiveShopNode(x: number, y: number): void;
    drawMapNode(x: number, y: number): void;
    drawBattleNode(x: number, y: number): void;
    drawShopNode(x: number, y: number): void;
    handleNodeInitialization(): void;
    initializeBattleNode(): void;
}
