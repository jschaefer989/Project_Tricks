local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____Board = require("Board")
local Board = ____Board.default
local ____Enums = require("Enums")
local GameStates = ____Enums.GameStates
local ____Helpers = require("Helpers")
local isEmpty = ____Helpers.isEmpty
local lovelyToasts = require("Libraries.Lovely-Toasts-main.lovelyToasts")
local json = require("Libraries.jsonlua-master")
____exports.default = __TS__Class()
local Save = ____exports.default
Save.name = "Save"
function Save.prototype.____constructor(self)
end
function Save.save(self, gameManager)
    local saveData = {
        gameState = gameManager.gameState,
        player = gameManager.player:save(),
        board = gameManager.board and gameManager.board:save() or nil,
        map = gameManager.map:save()
    }
    local dataString
    do
        local function ____catch(err)
            lovelyToasts.show("Error saving data: " .. tostring(err))
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            dataString = json.encode(saveData)
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
    local success = {love.filesystem.write("savegame.json", dataString)}
    if not success[1] then
        lovelyToasts.show("Error saving game: " .. success[2])
    else
        lovelyToasts.show("Game saved successfully.")
    end
    return success[1]
end
function Save.load(self, gameManager)
    if love.filesystem.getInfo("savegame.json") then
        local dataString = (love.filesystem.read("savegame.json"))
        if isEmpty(dataString) then
            lovelyToasts.show("Save file is empty or corrupted.")
            return false
        end
        local saveData
        do
            local function ____catch(err)
                lovelyToasts.show("Error loading save data: " .. tostring(err))
                return true, false
            end
            local ____try, ____hasReturned, ____returnValue = pcall(function()
                saveData = json.decode(dataString)
            end)
            if not ____try then
                ____hasReturned, ____returnValue = ____catch(____hasReturned)
            end
            if ____hasReturned then
                return ____returnValue
            end
        end
        local ____gameManager_1 = gameManager
        local ____saveData_gameState_0 = saveData.gameState
        if ____saveData_gameState_0 == nil then
            ____saveData_gameState_0 = GameStates.MAIN_MENU
        end
        ____gameManager_1.gameState = ____saveData_gameState_0
        local ____self_3 = gameManager.player
        local ____self_3_load_4 = ____self_3.load
        local ____saveData_player_2 = saveData.player
        if ____saveData_player_2 == nil then
            ____saveData_player_2 = {}
        end
        ____self_3_load_4(____self_3, ____saveData_player_2)
        gameManager.board = __TS__New(Board, gameManager)
        local ____self_6 = gameManager.board
        local ____self_6_load_7 = ____self_6.load
        local ____saveData_board_5 = saveData.board
        if ____saveData_board_5 == nil then
            ____saveData_board_5 = {}
        end
        ____self_6_load_7(____self_6, ____saveData_board_5)
        local ____self_9 = gameManager.map
        local ____self_9_load_10 = ____self_9.load
        local ____saveData_map_8 = saveData.map
        if ____saveData_map_8 == nil then
            ____saveData_map_8 = {}
        end
        ____self_9_load_10(____self_9, ____saveData_map_8)
    end
    return true
end
return ____exports
