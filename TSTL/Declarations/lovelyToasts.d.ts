// TypeScript declaration file for Lovely Toasts
// https://github.com/Loucee/Lovely-Toasts

/** @noSelfInFile */

type ToastPosition = "top" | "middle" | "bottom" | number

interface ToastStyle {
    /** Font to use for toast text */
    font: any // love.graphics.Font
    /** Text color [r, g, b, a] (0-1 range) */
    textColor: [number, number, number, number?]
    /** Background color [r, g, b, a] (0-1 range) */
    backgroundColor: [number, number, number, number?]
    /** Left and right padding in pixels */
    paddingLR: number
    /** Top and bottom padding in pixels */
    paddingTB: number
}

interface ToastOptions {
    /** Allow dismissing toast by tapping/clicking on it */
    tapToDismiss: boolean
    /** Enable queueing multiple toasts (false = only show one at a time) */
    queueEnabled: boolean
    /** Duration of fade in/out animation in seconds */
    animationDuration: number
}

interface LovelyToastsModule {
    /** Canvas size [width, height] - auto-detected if not set */
    canvasSize: [number?, number?]
    
    /** Styling options for toasts */
    style: ToastStyle
    
    /** Behavior options for toasts */
    options: ToastOptions

    /**
     * Update toast animations (call in love.update)
     * @param dt Delta time in seconds
     */
    update(dt: number): void

    /**
     * Draw the current toast (call in love.draw)
     */
    draw(): void

    /**
     * Handle mouse release events (call in love.mousereleased)
     * @param x Mouse x position
     * @param y Mouse y position
     * @param button Mouse button that was released
     */
    mousereleased(x: number, y: number, button: number): void

    /**
     * Handle touch release events (call in love.touchreleased)
     * @param id Touch identifier
     * @param x Touch x position
     * @param y Touch y position
     * @param dx Delta x
     * @param dy Delta y
     * @param pressure Touch pressure
     */
    touchreleased(id: any, x: number, y: number, dx: number, dy: number, pressure: number): void

    /**
     * Show a toast notification
     * @param text Text to display in the toast
     * @param duration Duration in seconds (default: 3, adds animation time automatically)
     * @param position Position on screen: "top", "middle", "bottom", or custom y value (default: "bottom")
     */
    show(this: void, text: string, duration?: number, position?: ToastPosition): void
}

declare module "Libraries.Lovely-Toasts-main.lovelyToasts" {
    const lovelyToasts: LovelyToastsModule
    export = lovelyToasts
}
