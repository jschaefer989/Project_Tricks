import { isEmpty } from "Helpers"
import FontWithPosition from "./FontWithPosition"
import { Font } from "love.graphics"

export default class TextManager {
    texts: Map<string, FontWithPosition>

    constructor() {
        this.texts = new Map<string, FontWithPosition>()
    }

    drawText(): void {
        const prevFont = love.graphics.getFont()
        for (const font of this.texts.values()) {            
            font.printFont()
        }
        love.graphics.setColor(1, 1, 1, 1)
        // Restore previous font
        if (!isEmpty(prevFont)) {
            love.graphics.setFont(prevFont)
        }
    }

    addText(id: string, font: FontWithPosition): void {
        this.texts.set(id, font)
    }

    getText(id: string): FontWithPosition | undefined {
        return this.texts.get(id)
    }

    hideText(id: string): void {
        this.texts.delete(id)
    }

    updateText(id: string, newText: string): void {
        const text = this.texts.get(id)
        if (!isEmpty(text)) {
            text.text = newText
        }
    }

    static getDefaultFontFilepath(): string {
        return "Assets/Fonts/Germania.ttf"
    }

    static setDefaultFont(): Font {
        const mainFont = love.graphics.newFont(this.getDefaultFontFilepath())
        love.graphics.setFont(mainFont)
        return mainFont
    }
}