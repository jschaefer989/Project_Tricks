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
____exports.Save = __TS__Class()
local Save = ____exports.Save
Save.name = "Save"
function Save.prototype.____constructor(self)
end
function Save.save(self, gameManager)
    local saveData = {
        gameState = gameManager.gameState,
        player = gameManager.player:save(),
        board = gameManager.board and gameManager.board:save() or nil
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
        gameManager.gameState = saveData.gameState or GameStates.MAIN_MENU
        gameManager.player:load(saveData.player or ({}))
        gameManager.board = __TS__New(Board, gameManager)
        gameManager.board:load(saveData.board or ({}))
    end
    return true
end
return ____exports
