import Card from "Card"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"
import { Image } from "love.graphics"

export default class Draw {
    static card(gameManager: GameManager, card: Card, btnW: number, btnH: number, onlySelectOne?: boolean): void {
        const isSelected = card.selected
        let btnText = card.rank + " " + card.suit + " (Val: " + card.value + ", Pow: " + card.power + ")"
        
        if (isSelected) {
            btnText = "[X] " + btnText
        } else {
            btnText = "[ ] " + btnText
        }

        const btnHit = suit.Button(btnText, {}, ...suit.layout.col(btnW, btnH)).hit

        if (btnHit) {
            if (onlySelectOne) {
                // TODO: this should be made generic
                // Deselect all other cards
                if (gameManager.board && gameManager.board.dealer) {
                    gameManager.board.dealer.deselectAllCards()
                }
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
}
