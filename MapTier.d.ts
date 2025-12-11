/** @noSelfInFile */
import { MapNodeTypes } from "Enums";
import GameManager from "GameManager";
import MapNode, { MapNodeData } from "MapNode";
export interface MapTierData {
    nodes: MapNodeData[];
}
export default class MapTier {
    gameManager: GameManager;
    nodes: MapNode[];
    constructor(gameManager: GameManager);
    load(data: MapTierData): void;
    save(): MapTierData;
    generateNodes(numberOfNodes: number): void;
    shouldBeUniqueNodeType(nodeType: MapNodeTypes): boolean;
    isUniqueNodeType(nodeType: MapNodeTypes): boolean;
    drawTier(relativePosition: number): void;
}
