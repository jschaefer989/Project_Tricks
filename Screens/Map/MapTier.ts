/** @noSelfInFile */

import { MapNodeTypes } from "Enums"
import GameManager from "GameManager"
import { exhaustiveGuard } from "Helpers"
import MapNode, { MapNodeData } from "./MapNode"

const startY = 100
const labelHeight = 25
const imageHeight = 100 
const gapBetweenLabelAndImage = 5
const padding = 40
const nodeWidth = 200
const spacing = labelHeight + gapBetweenLabelAndImage + imageHeight + padding

export interface MapTierData {
    nodes: MapNodeData[]
    level: number
}

export default class MapTier {
    gameManager: GameManager
    nodes: MapNode[]
    level: number

    constructor(gameManager: GameManager, level?: number) {
        this.gameManager = gameManager
        this.nodes = []
        this.level = level ?? 1
    }

    load(data: MapTierData): void {
        this.nodes = (data.nodes || []).map(nodeData => {
            const node = new MapNode(this.gameManager)
            node.load(nodeData)
            return node
        })
        this.level = data.level
    }

    save(): MapTierData {
        return {
            nodes: this.nodes.map(node => node.save()),
            level: this.level
        }
    }

    generateNodes(numberOfNodes: number): void {
        for (let i = 0; i < numberOfNodes; i++) {
            const newNode = new MapNode(this.gameManager)
            if (this.level === 1 && this.shouldBeExcludedFromFirstTier(newNode.type)) {
                continue
            }
            if (this.shouldBeUniqueNodeType(newNode.type) && !this.isUniqueNodeType(newNode.type)) {
                continue
            }
            this.nodes.push(newNode)
        }
    }

    shouldBeExcludedFromFirstTier(nodeType: MapNodeTypes): boolean {
        switch (nodeType) {
            case MapNodeTypes.SHOP:
                return true
            case MapNodeTypes.BATTLE:
                return false
            default:
                exhaustiveGuard(nodeType)
        }
    }

    shouldBeUniqueNodeType(nodeType: MapNodeTypes): boolean {
        switch (nodeType) {
            case MapNodeTypes.SHOP:
                return true
            case MapNodeTypes.BATTLE:
                return false
            default:
                exhaustiveGuard(nodeType)
        }
    }

    isUniqueNodeType(nodeType: MapNodeTypes): boolean {
        for (const node of this.nodes) {
            if (node.type === nodeType) {
                return false
            }
        }
        return true
    }

    drawTier(relativePosition: number): void {
        const tierWidth = nodeWidth + 50 // Width allocated for each tier column
        const tierX = relativePosition * tierWidth + 50 // Base X position for this tier, with left margin
        
        for (let index = 0; index < this.nodes.length; index++) {
            const node = this.nodes[index]
            const x = tierX
            const y = startY + (index * spacing)

            // If we are on the current tier, draw interactive nodes
            if (relativePosition === 0) {
                node.drawInteractiveMapNode(x, y) 
            }
            else {
                node.drawMapNode(x, y)
            }
        }
    }
}