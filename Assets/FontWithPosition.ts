/** @noSelfInFile */

import { Font } from "love.graphics"
import TextManager from "./TextManager"
import { isEmpty } from "Helpers"

interface ConstructionOptions {
    filepath?: string
    size?: number
}

export default class FontWithPosition {
    size?: number
    filepath: string
    x: number
    y: number
    text: string

    constructor(x: number, y: number, text: string, options?: ConstructionOptions) {
        this.size = options?.size
        this.filepath = options?.filepath ?? TextManager.getDefaultFontFilepath()
        this.x = x
        this.y = y
        this.text = text
    }

    printFont(): void {        
        const font = !isEmpty(this.size) ? love.graphics.newFont(this.filepath, this.size) : love.graphics.newFont(this.filepath)
        love.graphics.setFont(font)

        const textW = font.getWidth(this.text)
        const textH = font.getHeight()

        // Drop shadow then main text for readability
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(this.text, Math.floor(this.x - textW / 2) + 1, Math.floor(this.y - textH / 2) + 1)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(this.text, Math.floor(this.x - textW / 2), Math.floor(this.y - textH / 2))
    }
}