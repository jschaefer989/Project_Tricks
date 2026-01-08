/** @noSelfInFile */
declare enum WindowOptions {
    WINDOWED = "WINDOWED",
    FULLSCREEN = "FULLSCREEN"
}
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
