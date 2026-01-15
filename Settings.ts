import { exhaustiveGuard } from "Helpers"
import * as push from "Libraries.push"

/** @noSelfInFile */

enum WindowOptions {
    WINDOWED = "WINDOWED",
    FULLSCREEN = "FULLSCREEN"
}

export const gameWidth = 640
export const gameHeight = 360 

export default class Settings {
    playMusic: boolean = true
    playSoundEffects: boolean = true
    windowSetting: WindowOptions = WindowOptions.WINDOWED
    dealerSpeed: number = 0.1;

    constructor() {}

    apply(): void {
        // TODO: Load settings from a file or set defaults

        switch (this.windowSetting) {
            case WindowOptions.FULLSCREEN:
                this.setupFullscreenMode()
                break
            case WindowOptions.WINDOWED:
                this.setupWindowedMode()
                break
            default:
                exhaustiveGuard(this.windowSetting)
        }
        this.playMusic = false // Temporary: disable music for now
    }

    setupWindowedMode(): void {
        let [windowWidth, windowHeight] = love.window.getDesktopDimensions()
        windowWidth = windowWidth - 25
        windowHeight = windowHeight - 100 // make the window a bit smaller than the screen itself
        push.setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen: false })
    }

    setupFullscreenMode(): void {
        let [windowWidth, windowHeight] = love.window.getDesktopDimensions()
        push.setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen: true })
    }
}
