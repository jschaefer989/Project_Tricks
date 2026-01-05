local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____Enums = require("Enums")
local GameStates = ____Enums.GameStates
local ____Helpers = require("Helpers")
local exhaustiveGuard = ____Helpers.exhaustiveGuard
____exports.default = __TS__Class()
local MusicPlayer = ____exports.default
MusicPlayer.name = "MusicPlayer"
function MusicPlayer.prototype.____constructor(self, gameManager)
    self.gameManager = gameManager
end
function MusicPlayer.prototype.play(self, gameState, biome)
    if self.gameState == gameState and self.biome == biome then
        return
    end
    self.gameState = gameState
    self.biome = biome
    if gameState == GameStates.PAUSE_MENU then
        local ____opt_0 = self.currentlyPlaying
        if ____opt_0 ~= nil then
            ____opt_0:setVolume(0.2)
        end
        return
    end
    local ____opt_2 = self.currentlyPlaying
    if ____opt_2 and ____opt_2:isPlaying() then
        self.currentlyPlaying:stop()
    end
    repeat
        local ____switch7 = gameState
        local ____cond7 = ____switch7 == GameStates.BOARD
        if ____cond7 then
            self:playBoardMusic(biome)
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.MAIN_MENU
        if ____cond7 then
            self:playMainMenuMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.LEVEL_UP
        if ____cond7 then
            self:playLevelUpMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.LOSE_SCREEN
        if ____cond7 then
            self:playGameOverMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.WIN_SCREEN
        if ____cond7 then
            self:playVictoryMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.PERKS
        if ____cond7 then
            self:playPerkSelectionMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.SHOP
        if ____cond7 then
            self:playShopMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.MAP
        if ____cond7 then
            self:playMapMusic()
            break
        end
        ____cond7 = ____cond7 or ____switch7 == GameStates.NEW_GAME_MENU
        if ____cond7 then
            self:playNewGameMenuMusic()
            break
        end
        do
            exhaustiveGuard(gameState)
        end
    until true
end
function MusicPlayer.prototype.playBoardMusic(self, biome)
    self.currentlyPlaying = love.audio.newSource(biome.battleMusicPath, "stream")
    self.currentlyPlaying:setLooping(true)
    self.currentlyPlaying:play()
end
function MusicPlayer.prototype.playMainMenuMusic(self)
end
function MusicPlayer.prototype.playLevelUpMusic(self)
end
function MusicPlayer.prototype.playGameOverMusic(self)
end
function MusicPlayer.prototype.playVictoryMusic(self)
end
function MusicPlayer.prototype.playPerkSelectionMusic(self)
end
function MusicPlayer.prototype.playShopMusic(self)
end
function MusicPlayer.prototype.playMapMusic(self)
end
function MusicPlayer.prototype.playNewGameMenuMusic(self)
end
return ____exports
