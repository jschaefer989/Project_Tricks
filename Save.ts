/** @noSelfInFile */

import Board from "Board"
import { GameStates } from "Enums"
import { isEmpty } from "Helpers"
import * as lovelyToasts from "Libraries.Lovely-Toasts-main.lovelyToasts"
import * as json from "Libraries.jsonlua-master"
import GameManager from "./GameManager"

export class Save {
    static save(gameManager: GameManager): boolean {
        const saveData = {
            gameState: gameManager.gameState,
            player: gameManager.player.save(),
            board: gameManager.board ? gameManager.board.save() : undefined
        }
        let dataString: any
        try {
            dataString = json.encode(saveData)
        } catch (err) {
            lovelyToasts.show("Error saving data: " + err)
            return false
        }
        const success = love.filesystem.write("savegame.json", dataString)
        if (!success[0]) {
            lovelyToasts.show("Error saving game: " + success[1])
        } else {
            lovelyToasts.show("Game saved successfully.")
        }
        return success[0]
    }

    static load(gameManager: GameManager): boolean {
        if (love.filesystem.getInfo("savegame.json")) {
            const dataString = love.filesystem.read("savegame.json")[0]
            if (isEmpty(dataString)) {
                lovelyToasts.show("Save file is empty or corrupted.")
                return false
            }
            let saveData: any
            try {
                saveData = json.decode(dataString)
            } catch (err) {
                lovelyToasts.show("Error loading save data: " + err)
                return false
            }
            gameManager.gameState = saveData.gameState || GameStates.MAIN_MENU
            gameManager.player.load(saveData.player || {})
            gameManager.board = new Board(gameManager)
            gameManager.board.load(saveData.board || {})
        }
        return true
    }
}
