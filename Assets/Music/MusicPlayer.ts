import Biome from "Biomes/Biome";
import { GameStates } from "Enums";
import GameManager from "GameManager";
import { exhaustiveGuard } from "Helpers";
import { Source } from "love.audio";

export default class MusicPlayer {
    gameManager: GameManager
    currentlyPlaying?: Source
    gameState?: GameStates
    biome?: Biome

    constructor(gameManager: GameManager) {
        this.gameManager = gameManager
    }

    play(gameState: GameStates, biome: Biome): void {
        if (this.gameState === gameState && this.biome === biome) {
            return; // No change
        }

        this.gameState = gameState
        this.biome = biome

        if (gameState === GameStates.PAUSE_MENU) {
            this.currentlyPlaying?.setVolume(0.2);
            return; // Just lower the volume when pausing
        }

        if (this.currentlyPlaying?.isPlaying()) {            
            this.currentlyPlaying.stop();
        }
        
        switch (gameState) {
            case GameStates.BOARD:
                this.playBoardMusic(biome);
                break;
            case GameStates.MAIN_MENU:
                this.playMainMenuMusic();
                break;
            case GameStates.LEVEL_UP:
                this.playLevelUpMusic();
                break;
            case GameStates.LOSE_SCREEN:
                this.playGameOverMusic();
                break;
            case GameStates.WIN_SCREEN:
                this.playVictoryMusic();
                break;
            case GameStates.PERKS:
                this.playPerkSelectionMusic();
                break;            
            case GameStates.SHOP:
                this.playShopMusic();
                break;
            case GameStates.MAP:
                this.playMapMusic();
                break;
            case GameStates.NEW_GAME_MENU:
                this.playNewGameMenuMusic();
                break;
            default:
                exhaustiveGuard(gameState);
        }
    }

    private playBoardMusic(biome: Biome): void {
        this.currentlyPlaying = love.audio.newSource(biome.battleMusicPath, "stream");
        this.currentlyPlaying.setLooping(true);
        this.currentlyPlaying.play();
    }

    private playMainMenuMusic(): void {

    }

    private playLevelUpMusic(): void {

    }

    private playGameOverMusic(): void {

    }

    private playVictoryMusic(): void {

    }

    private playPerkSelectionMusic(): void {

    }

    private playShopMusic(): void {

    }

    private playMapMusic(): void {

    }

    private playNewGameMenuMusic(): void {

    }
}