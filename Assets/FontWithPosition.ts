import { Font } from "love.graphics"

export default class FontWithPosition {
    size: number
    font: Font
    x: number
    y: number
    text: string

    constructor(font: Font, size: number, x: number, y: number, text: string) {
        this.size = size
        this.font = font
        this.x = x
        this.y = y
        this.text = text
    }

    printFont(): void {
        const text = this.text
        
        const bigFont = love.graphics.newFont(28)
        love.graphics.setFont(bigFont)

        const textW = bigFont.getWidth(text)
        const textH = bigFont.getHeight()
        const centerX = this.x + this.font.getWidth(text) / 2
        const centerY = this.y + this.font.getHeight() / 2

        // Drop shadow then main text for readability
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(text, Math.floor(centerX - textW / 2) + 1, Math.floor(centerY - textH / 2) + 1)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(text, Math.floor(centerX - textW / 2), Math.floor(centerY - textH / 2))
    }
}