/** @noSelfInFile */

import Draw from "Draw"
import GameManager from "GameManager"
import MapTier, { MapTierData } from "MapTier"

interface MapData {
    tiers: MapTierData[]
    currentTierIndex: number
}

export default class Map {
    gameManager: GameManager
    tiers: MapTier[]
    currentTierIndex: number
    backgroundImage?: any

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.tiers = []
        this.currentTierIndex = 0   

        this.backgroundImage = Draw.loadImage("assets/map_background.png")
    }

    load(data: MapData): void {
        this.tiers = data.tiers.map(tierData => {
            const tier = new MapTier(this.gameManager)
            tier.load(tierData)
            return tier
        })
        this.currentTierIndex = data.currentTierIndex ?? 0
    }

    save(): MapData {
        return {
            tiers: this.tiers.map(tier => tier.save()),
            currentTierIndex: this.currentTierIndex
        }
    }

    drawMap(): void {        
        this.drawTiers()
    }

    drawBackground(): void {
        Draw.drawBackgroundImage(this.backgroundImage)
    }

    drawTiers(): void {
        for (let index = 0; index < this.tiers.length; index++) {
            const tier = this.tiers[index]
            const relativePosition = index - this.currentTierIndex
            tier.drawTier(relativePosition)
        }
    }

    generateNewMap(): void {
        // TODO: hardcoded to 5 tiers for now
        for (let i = 0; i < 5; i++) {
            const newTier = new MapTier(this.gameManager)
            newTier.generateNodes(3) // Hardcoded to 3 nodes per tier for now
            this.tiers.push(newTier)
        }
    }
}