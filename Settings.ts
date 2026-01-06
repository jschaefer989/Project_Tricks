import { exhaustiveGuard } from "Helpers"
import * as push from "Libraries.push"

/** @noSelfInFile */

enum WindowOptions {
    WINDOWED = "WINDOWED",
    FULLSCREEN = "FULLSCREEN"
}

export default class Settings {
    playMusic: boolean = true
    playSoundEffects: boolean = true
    windowSetting: WindowOptions = WindowOptions.WINDOWED

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
        const gameWidth = 640
        const gameHeight = 360 // fixed game resolution
        let [windowWidth, windowHeight] = love.window.getDesktopDimensions()
        windowWidth = windowWidth - 25
        windowHeight = windowHeight - 60 // make the window a bit smaller than the screen itself
        push.setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen: false })
    }

    setupFullscreenMode(): void {
        // Configure push for fullscreen using the desktop resolution
        const gameWidth = 1920
        const gameHeight = 1080
        let [windowWidth, windowHeight] = love.window.getDesktopDimensions()

        // Some platforms report the desktop size as 0 when not yet initialized;
        // fall back to the game resolution in that case.
        if (!windowWidth || windowWidth === 0) windowWidth = gameWidth
        if (!windowHeight || windowHeight === 0) windowHeight = gameHeight

        // Use the same call style as existing code (push.setupScreen(push, ...))
        push.setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen: true })
    }
}
