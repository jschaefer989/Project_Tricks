import Card from "Card"
import * as suit from "Libraries.suit-master.suit"
import GameManager from "./GameManager"

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
}
