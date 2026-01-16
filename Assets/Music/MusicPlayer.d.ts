import Biome from "Biomes/Biome";
import { GameStates } from "Enums";
import GameManager from "GameManager";
import { Source } from "love.audio";
export default class MusicPlayer {
    gameManager: GameManager;
    currentlyPlaying?: Source;
    gameState?: GameStates;
    biome?: Biome;
    constructor(gameManager: GameManager);
    play(gameState: GameStates, biome: Biome): void;
    private playBoardMusic;
    private playMainMenuMusic;
    private playLevelUpMusic;
    private playGameOverMusic;
    private playVictoryMusic;
    private playShopMusic;
    private playMapMusic;
    private playNewGameMenuMusic;
}
