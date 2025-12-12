/** @noSelfInFile */

import Draw from "Draw"
import Enemy, { EnemyData } from "Enemies/Enemy"
import { EnemyTypes, MapNodeTypes } from "Enums"
import GameManager from "GameManager"
import { exhaustiveGuard, getRandomElementFromEnum } from "Helpers"
import * as suit from "Libraries.suit-master.suit"

export interface MapNodeData {
    type: MapNodeTypes,
    enemy?: EnemyData
}

export default class MapNode {
    gameManager: GameManager
    type: MapNodeTypes
    enemy?: Enemy
    swordImage?: any
    marketImage?: any

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
        this.type = this.getRandomNodeType()
        this.handleNodeInitialization()

        // Load sword image if it exists
        this.swordImage = Draw.loadImage("assets/battle.jpg")
        
        // Load market image if it exists
        this.marketImage = Draw.loadImage("assets/shop.jpg")
    }

    load(data: MapNodeData): void {
        this.type = data.type ?? this.getRandomNodeType()
        if (data.enemy) {
            this.enemy = new Enemy()
            this.enemy.load(data.enemy)
        }
    }

    save(): MapNodeData {
        return {
            type: this.type,
            enemy: this.enemy ? this.enemy.save() : undefined
        }
    }

    getRandomNodeType(): MapNodeTypes {
        return getRandomElementFromEnum(MapNodeTypes)
    }

    drawInteractiveMapNode(x: number, y: number): void {
        switch (this.type) {
            case MapNodeTypes.BATTLE:
                this.drawInteractiveBattleNode(x, y)
                break
            case MapNodeTypes.SHOP:
                this.drawInteractiveShopNode(x, y)
                break
            default:
                exhaustiveGuard(this.type)
        }    
    }

    drawInteractiveBattleNode(x: number, y: number): void {
        if (!this.enemy) {
            return
        }
        const imageW = this.swordImage.getWidth()
        const imageH = this.swordImage.getHeight()
        const labelHeight = 25

        // Draw label above the image button
        const buttonText = `${this.enemy.getEnemyName()} (Lv. ${this.enemy.level})`
        suit.layout.reset(x, y)
        suit.Label(buttonText, { align: "center" }, ...suit.layout.row(imageW, labelHeight))
        
        const imageY = y + labelHeight + 5
        
        // Draw bezel (border) around the image
        const bezelPadding = 4
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(1, 1, 1, 1)
        
        suit.layout.reset(x, imageY)
        const result = suit.ImageButton(this.swordImage, {}, ...suit.layout.row(imageW, imageH))
        
        if (result.hit) {
            this.gameManager.switchToBoard(this.enemy)
        }
    }

    drawInteractiveShopNode(x: number, y: number): void {
        const imageW = this.marketImage.getWidth()
        const imageH = this.marketImage.getHeight()
        const labelHeight = 25

        // Draw label above the image button
        suit.layout.reset(x, y)
        suit.Label("Shop", { align: "center" }, ...suit.layout.row(imageW, labelHeight))
        
        const imageY = y + labelHeight + 5
        
        // Draw bezel (border) around the image
        const bezelPadding = 4
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(1, 1, 1, 1)
        
        suit.layout.reset(x, imageY)
        const result = suit.ImageButton(this.marketImage, {}, ...suit.layout.row(imageW, imageH))
        
        if (result.hit) {
            this.gameManager.switchToShop()
        }
    }

    drawMapNode(x: number, y: number): void {
        switch (this.type) {
            case MapNodeTypes.BATTLE:
                this.drawBattleNode(x, y)
                break
            case MapNodeTypes.SHOP:
                this.drawShopNode(x, y)
                break
            default:
                exhaustiveGuard(this.type)
        }    
    }

    drawBattleNode(x: number, y: number): void {
        if (!this.enemy) {
            return
        }
        const imageW = this.swordImage.getWidth()
        const imageH = this.swordImage.getHeight()
        const labelHeight = 25

        // Draw label above the image button
        const buttonText = `${this.enemy.getEnemyName()} (Lv. ${this.enemy.level})`
        suit.layout.reset(x, y)
        suit.Label(buttonText, { align: "center" }, ...suit.layout.row(imageW, labelHeight))
        
        const imageY = y + labelHeight + 5
        
        // Draw bezel (border) around the image
        const bezelPadding = 4
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(1, 1, 1, 1)
        
        suit.layout.reset(x, imageY)
        love.graphics.draw(this.swordImage, x, imageY)
    }

    drawShopNode(x: number, y: number): void {
        const imageW = this.marketImage.getWidth()
        const imageH = this.marketImage.getHeight()
        const labelHeight = 25

        // Draw label above the image button
        suit.layout.reset(x, y)
        suit.Label("Shop", { align: "center" }, ...suit.layout.row(imageW, labelHeight))
        
        const imageY = y + labelHeight + 5
        
        // Draw bezel (border) around the image
        const bezelPadding = 4
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("line", x - bezelPadding, imageY - bezelPadding, imageW + bezelPadding * 2, imageH + bezelPadding * 2, 4)
        love.graphics.setColor(1, 1, 1, 1)
        
        suit.layout.reset(x, imageY)
        love.graphics.draw(this.marketImage, x, imageY)
    }

    handleNodeInitialization(): void {
        switch (this.type) {
            case MapNodeTypes.SHOP:
                // Shop-specific initialization if needed
                break
            case MapNodeTypes.BATTLE:
                this.initializeBattleNode()
                break
            default:
                exhaustiveGuard(this.type)
        }
    }

    initializeBattleNode(): void {
        // TODO: All of this stuff should be weighted based on player level and strength and generated at some point
        // const lootDie = loadedDice.new_die([50, 30, 30, 10, 7, 2])
        // const result = lootDie.random()
        this.enemy = new Enemy(undefined, undefined, undefined, getRandomElementFromEnum(EnemyTypes))
    }
}