/** @noSelfInFile */
import { MapNodeTypes } from "Enums";
import GameManager from "GameManager";
import MapNode, { MapNodeData } from "MapNode";
export interface MapTierData {
    nodes: MapNodeData[];
    level: number;
}
export default class MapTier {
    gameManager: GameManager;
    nodes: MapNode[];
    level: number;
    constructor(gameManager: GameManager, level?: number);
    load(data: MapTierData): void;
    save(): MapTierData;
    generateNodes(numberOfNodes: number): void;
    shouldBeExcludedFromFirstTier(nodeType: MapNodeTypes): boolean;
    shouldBeUniqueNodeType(nodeType: MapNodeTypes): boolean;
    isUniqueNodeType(nodeType: MapNodeTypes): boolean;
    drawTier(relativePosition: number): void;
}
