/** @noSelfInFile */
declare enum WindowOptions {
    WINDOWED = "WINDOWED",
    FULLSCREEN = "FULLSCREEN"
}
export default class Settings {
    playMusic: boolean;
    playSoundEffects: boolean;
    windowSetting: WindowOptions;
    constructor();
    apply(): void;
    setupWindowedMode(): void;
    setupFullscreenMode(): void;
}
export {};
