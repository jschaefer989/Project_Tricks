import * as push from "Libraries.push"

/** @noSelfInFile */

export default class Settings {
    constructor() {}

    defaults(): void {
        // Load settings from a file or set defaults
        this.setupWindowedMode()
    }

    setupWindowedMode(): void {
        const gameWidth = 1920
        const gameHeight = 1080 // fixed game resolution
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
