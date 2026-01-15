/** @noSelfInFile */
declare enum WindowOptions {
    WINDOWED = "WINDOWED",
    FULLSCREEN = "FULLSCREEN"
}
export declare const gameWidth = 640;
export declare const gameHeight = 360;
export default class Settings {
    playMusic: boolean;
    playSoundEffects: boolean;
    windowSetting: WindowOptions;
    dealerSpeed: number;
    constructor();
    apply(): void;
    setupWindowedMode(): void;
    setupFullscreenMode(): void;
}
export {};
