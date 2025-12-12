import Card from "Cards/Card"
import * as suit from "Libraries.suit-master.suit"
import { Image } from "love.graphics"
import { isEmpty } from "Helpers"
import Player from "Player"
import GameManager from "GameManager"

interface CardOptions {
    multiSelect?: boolean
    onClick?: (card: Card) => void
    displayCost?: boolean
}

interface PlayerDeckOptions {
    showDiscards?: boolean
}

export default class Draw {
    static card( card: Card, btnW: number, btnH: number, options?: CardOptions): void {
        const isSelected = card.selected
        let btnText = card.rank + " " + card.suit + " (Val: " + card.value + ", Pow: " + card.power + ")"
        
        if (options?.multiSelect) {
            if (isSelected) {
                btnText = "[X] " + btnText
            } else {
                btnText = "[ ] " + btnText
            }
        }

        if (options?.displayCost) {
            btnText += " Cost: " + card.cost
        }

        const btnHit = suit.Button(btnText, {}, ...suit.layout.col(btnW, btnH)).hit

        if (btnHit) {
            if (!isEmpty(options?.onClick)) {
                options.onClick(card)
            }
            card.selected = !card.selected
        }
    }

    static loadImage(path: string): Image | undefined {
        const [success, imageOrError] = pcall(() => love.graphics.newImage(path))
        if (success) {
            return imageOrError
        }
    }

    static drawBackgroundImage(image: Image): void {
        const screenW = love.graphics.getWidth()
        const screenH = love.graphics.getHeight()
        love.graphics.draw(image, 0, 0, 0, screenW / image.getWidth(), screenH / image.getHeight())
    }

    static setThemeColors(r: number, g: number, b: number): void {
        suit.theme.color.normal.fg = [r, g, b]
    }

    static playerInfo(player: Player, gameManager: GameManager): void {
        const padX = 20
        const padY = 20
        const name = player.name
        const level = player.level
        const exp = player.experience
        const money = player.money
        const screenW = love.graphics.getWidth()
        const panelW = 200
        const panelX = screenW - panelW - padX

        suit.layout.reset(panelX, padY, 10, 10)
        suit.Label(name, { align: "center" }, ...suit.layout.row(panelW, 24))
        suit.Label("Level: " + level + " (Next: " + player.getNextLevelExperience() + " XP)", { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("XP: " + exp, { align: "left" }, ...suit.layout.row(panelW, 22))
        suit.Label("Money: " + money, { align: "left" }, ...suit.layout.row(panelW, 22))
        
        const btnH = 30
        const perkResult = suit.Button("Perks", {}, ...suit.layout.row(panelW, btnH))
        if (perkResult.hit) {
            gameManager.switchToPerkScreen()
        }
    }

    static playerDeck(player: Player, options?: PlayerDeckOptions): void {
        const deckSize = player.deck.length
        const discardSize = player.discardPile.length

        // Render discard pile and deck visualization in bottom right corner
        const screenW = love.graphics.getWidth()
        const screenH = love.graphics.getHeight()
        const panelX = screenW - 170 // Same right alignment as selected stats
        const panelY = screenH - 200 // Higher up to fit on screen

        if (options?.showDiscards) {
            suit.layout.reset(panelX, panelY, 10, 10)
            suit.Label("Discard Pile", { align: "center" }, ...suit.layout.row(150, 30))
            suit.Label("Cards: " + discardSize, { align: "center" }, ...suit.layout.row(150, 30))
        }

        suit.layout.row(0, 10)
        suit.Label("Player Deck", { align: "center" }, ...suit.layout.row(150, 30))
        suit.Label("Cards Remaining: " + deckSize, { align: "center" }, ...suit.layout.row(150, 30))
    }
}
