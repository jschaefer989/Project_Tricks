// TypeScript declaration file for GameStateManager
// https://github.com/GoonHouse/GameStateManager

/** @noSelfInFile */

interface GameState {
    enter?(): void
    quit?(): void
    update?(dt: number): void
    draw?(): void
    mousemoved?(x: number, y: number, dx: number, dy: number, istouch: boolean): void
    mousepressed?(x: number, y: number, button: number, istouch: boolean, presses: number): void
    mousereleased?(x: number, y: number, button: number, istouch: boolean, presses: number): void
    keypressed?(key: string, scancode: string, isrepeat: boolean): void
    keyreleased?(key: string, scancode: string): void
    textinput?(text: string): void
    wheelmoved?(x: number, y: number): void
    joystickpressed?(joystick: any, button: number): void
    resize?(w: number, h: number): void
}

interface GameStateManagerModule {
    currentState: GameState | null
    stateStack: GameState[]

    /**
     * Get the previous state from the state stack
     */
    getPreviousState(): GameState | undefined

    /**
     * Get the current active state
     */
    getState(): GameState | null

    /**
     * Set a new state (calls quit on current state and enter on new state)
     * @param newState The new state to set
     */
    setState(newState: GameState | null): void

    /**
     * Reload the current state (calls enter again)
     */
    reloadState(): void

    /**
     * Revert to the previous state in the stack
     */
    revertState(): void

    /**
     * Forward mouse moved event to current state
     */
    mousemoved(x: number, y: number, dx: number, dy: number, istouch: boolean): void

    /**
     * Forward joystick pressed event to current state
     */
    joystickpressed(joystick: any, button: number): void

    /**
     * Forward wheel moved event to current state
     */
    wheelmoved(x: number, y: number): void

    /**
     * Forward mouse pressed event to current state
     */
    mousepressed(x: number, y: number, button: number, istouch: boolean, presses: number): void

    /**
     * Forward mouse released event to current state
     */
    mousereleased(x: number, y: number, button: number, istouch: boolean, presses: number): void

    /**
     * Forward key pressed event to current state
     */
    keypressed(key: string, scancode: string, isrepeat: boolean): void

    /**
     * Forward key released event to current state
     */
    keyreleased(key: string, scancode: string): void

    /**
     * Forward text input event to current state
     */
    textinput(text: string): void

    /**
     * Forward update event to current state
     */
    update(dt: number): void

    /**
     * Forward quit event to current state
     */
    quit(): void

    /**
     * Forward draw event to current state
     */
    draw(): void

    /**
     * Forward resize event to current state
     */
    resize(w: number, h: number): void
}

declare module "Libraries.GameStateManager-main.gamestateManager" {
    const GameStateManager: GameStateManagerModule
    export = GameStateManager
}

