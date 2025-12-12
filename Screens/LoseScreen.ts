/** @noSelfInFile */

import * as suit from "Libraries.suit-master.suit"

export default class LoseScreen {
    constructor() {}

    drawScreen(): void {
        const screenW = love.graphics.getWidth()
        const panelW = 240
        const labelY = 50

        const panelX = (screenW - panelW) / 2
        const labelHeight = 36

        // Display a game over message (centered)
        suit.layout.reset(panelX, labelY)
        suit.Label("Game Over", { align: "center" }, ...suit.layout.row(panelW, labelHeight))

        // Create a quit button below
        const btnW = 200
        const btnH = 50
        const btnY = labelY + labelHeight + 20
        suit.layout.reset(panelX, btnY)
        const btnResult = suit.Button("Quit", {}, ...suit.layout.row(btnW, btnH))
        if (btnResult.hit) {
            love.event.quit()
        }
    }
}
