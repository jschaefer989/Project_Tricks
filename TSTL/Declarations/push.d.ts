// TypeScript declaration file for push.lua v0.4
// push.lua is a simple resolution-handling library for LÖVE2D
// https://github.com/Ulydev/push

/** @noSelfInFile */

declare module "Libraries.push" {
    /**
     * Settings for push:setupScreen
     */
    interface PushSettings {
        /** Enable fullscreen mode */
        fullscreen?: boolean;
        /** Allow window resizing */
        resizable?: boolean;
        /** Snap scaling to integer values for pixel-perfect rendering */
        pixelperfect?: boolean;
        /** Enable high DPI support */
        highdpi?: boolean;
        /** Use canvas rendering */
        canvas?: boolean;
        /** Enable stencil buffer */
        stencil?: boolean;
        /** Stretch to fill the window (ignore aspect ratio) */
        stretched?: boolean;
    }

    /**
     * Canvas parameters for push:addCanvas
     */
    interface CanvasParams {
        /** Canvas name */
        name: string;
        /** If true, canvas won't be automatically drawn */
        private?: boolean;
        /** Shader to apply to this canvas */
        shader?: any;
        /** Enable stencil buffer for this canvas */
        stencil?: boolean;
    }

    /**
     * Push instance interface
     */
    interface Push {
        /**
         * Setup the screen with virtual resolution
         * @param WWIDTH Virtual window width
         * @param WHEIGHT Virtual window height
         * @param RWIDTH Real window width
         * @param RHEIGHT Real window height
         * @param settings Optional settings
         * @returns The push instance
         */
        setupScreen(
            WWIDTH: number,
            WHEIGHT: number,
            RWIDTH: number,
            RHEIGHT: number,
            settings?: PushSettings
        ): Push;

        /**
         * Setup custom canvases
         * @param canvases Array of canvas parameters
         * @returns The push instance
         */
        setupCanvas(canvases: (CanvasParams | string)[]): Push;

        /**
         * Add a new canvas
         * @param params Canvas parameters
         */
        addCanvas(params: CanvasParams): void;

        /**
         * Set the active canvas for drawing
         * @param name Canvas name
         */
        setCanvas(name: string): void;

        /**
         * Set a shader for a canvas
         * @param name Canvas name (or shader if second param omitted)
         * @param shader The shader to apply
         */
        setShader(name: string | any, shader?: any): void;

        /**
         * Start drawing to the virtual resolution
         */
        start(): void;

        /**
         * Finish drawing and render to screen
         * @param shader Optional shader to apply when rendering
         */
        finish(shader?: any): void;

        /**
         * Apply an operation (start or end)
         * @param operation "start" or "end"
         * @param shader Optional shader
         */
        apply(operation: "start" | "end", shader?: any): void;

        /**
         * Set the border color
         * @param color RGB array [r, g, b] or single red value
         * @param g Green value (if color is a number)
         * @param b Blue value (if color is a number)
         */
        setBorderColor(color: [number, number, number] | number, g?: number, b?: number): void;

        /**
         * Convert screen coordinates to game coordinates
         * @param x Screen X coordinate
         * @param y Screen Y coordinate
         * @returns Game coordinates [x, y] or [undefined, undefined] if outside bounds
         */
        toGame(x: number, y: number): LuaMultiReturn<[x: number | undefined, y: number | undefined]>;

        /**
         * Convert game coordinates to screen coordinates
         * @param x Game X coordinate
         * @param y Game Y coordinate
         * @returns Screen coordinates [x, y]
         */
        toReal(x: number, y: number): LuaMultiReturn<[x: number, y: number]>;

        /**
         * Toggle fullscreen mode
         * @param winw Optional windowed width
         * @param winh Optional windowed height
         */
        switchFullscreen(winw?: number, winh?: number): void;

        /**
         * Handle window resize
         * @param w New width
         * @param h New height
         */
        resize(w: number, h: number): void;

        /**
         * Get virtual width
         */
        getWidth(): number;

        /**
         * Get virtual height
         */
        getHeight(): number;

        /**
         * Get virtual dimensions
         * @returns [width, height]
         */
        getDimensions(): LuaMultiReturn<[width: number, height: number]>;
    }

    const push: Push;
    export = push;
}
