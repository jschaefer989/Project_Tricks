local json = require('Libraries.jsonlua-master.json')
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
require "Board"

Save = {}

function Save.save()
    local saveData = {
        gameState = GameManager.gameState,
        player = Player,
        board = GameManager.board
    }
    local dataString = json.encode(saveData)
    return love.filesystem.write("savegame.json", dataString)
end

function Save.load()
    if love.filesystem.getInfo("savegame.json") then
        local dataString = love.filesystem.read("savegame.json")
        local saveData, _, err = json.decode(dataString)
        if err then
            lovelyToasts.show("Error loading save data: " .. err)
            return
        end
        GameManager.gameState = saveData.gameState or GameStates.MAIN_MENU
        Player:loadFromTable(saveData.player or {})
        GameManager.board = Board()
        GameManager.board:loadFromTable(saveData.board or {})
    end
end