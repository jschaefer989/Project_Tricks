export default class FontManager {
    fonts: Map<string, FontWithPosition>

    constructor() {
        this.fonts = new Map<string, FontWithPosition>()
    }

    private drawText(): void {
        const prevFont = love.graphics.getFont()
        for (const font of this.fonts.values()) {
            
            if (font.id === AssetIds.ATTACK_BUTTON) {
                const text = "Attack"
                const bigFont = love.graphics.newFont(28)
                love.graphics.setFont(bigFont)

                const textW = bigFont.getWidth(text)
                const textH = bigFont.getHeight()
                const centerX = asset.x + asset.getWidth() / 2
                const centerY = asset.y + asset.getHeight() / 2

                // Drop shadow then main text for readability
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.print(text, Math.floor(centerX - textW / 2) + 1, Math.floor(centerY - textH / 2) + 1)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.print(text, Math.floor(centerX - textW / 2), Math.floor(centerY - textH / 2))
            }
        }
        love.graphics.setColor(1, 1, 1, 1)
                        // Restore previous font
                if (!isEmpty(prevFont)) {
                    love.graphics.setFont(prevFont)
                }
    }
}