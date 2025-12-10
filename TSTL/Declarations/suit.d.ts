// TypeScript declaration file for SUIT (Simple User Interface Toolkit)
// SUIT is a LÖVE2D immediate mode GUI library
// https://github.com/vrld/SUIT

/** @noSelfInFile */

declare module "Libraries.suit-master.suit" {
    // ============================================================
    // Widget Return Types
    // ============================================================

interface WidgetState {
    id: string | number;
    hit: boolean;
    hovered: boolean;
    entered: boolean;
    left: boolean;
}

interface CheckboxState extends WidgetState {
    checked: boolean;
}

interface InputState extends WidgetState {
    submitted: boolean;
}

interface SliderState extends WidgetState {
    value: number;
}

// ============================================================
// Widget Options
// ============================================================

interface BaseOptions {
    id?: string | number;
    font?: any; // love.graphics.Font
    color?: {
        normal?: [number, number, number, number?];
        hovered?: [number, number, number, number?];
        active?: [number, number, number, number?];
    };
    state?: string;
    draw?: (...args: any[]) => void;
}

interface LabelOptions extends BaseOptions {
    align?: "left" | "center" | "right";
}

interface ButtonOptions extends BaseOptions {}

interface ImageButtonOptions extends BaseOptions {
    hovered?: any; // love.graphics.Image
    active?: any; // love.graphics.Image
    mask?: any; // love.graphics.Image
}

interface CheckboxOptions extends BaseOptions {
    align?: "left" | "right";
}

interface InputOptions extends BaseOptions {
    cursor?: string;
}

interface SliderState {
    text?: string;
}

interface SliderOptions extends BaseOptions {
    vertical?: boolean;
    min?: number;
    max?: number;
    step?: number;
}

// ============================================================
// Layout System
// ============================================================

interface Layout {
    /**
     * Reset layout position and padding
     * @param x X position
     * @param y Y position
     * @param padx Horizontal padding
     * @param pady Vertical padding (defaults to padx if not specified)
     */
    reset(this: Layout, x?: number, y?: number, padx?: number, pady?: number): Layout;

    /**
     * Set padding
     * @param padx Horizontal padding
     * @param pady Vertical padding
     */
    padding(this: Layout, padx: number, pady?: number): Layout;

    /**
     * Get current size
     */
    size(this: Layout): LuaMultiReturn<[number, number]>;

    /**
     * Create a new row cell
     * @param w Width (number, "max", "min", "median", or undefined for previous width)
     * @param h Height (number, "max", "min", "median", or undefined for previous height)
     */
    row(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Alias for row()
     */
    down(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Create a new column cell
     * @param w Width
     * @param h Height
     */
    col(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Alias for col()
     */
    right(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Move up
     */
    up(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Move left
     */
    left(this: Layout, w?: number | string, h?: number | string): LuaMultiReturn<[number, number, number, number]>;

    /**
     * Get position for next row
     */
    nextRow(this: Layout): LuaMultiReturn<[number, number]>;

    /**
     * Alias for nextRow()
     */
    nextDown(this: Layout): LuaMultiReturn<[number, number]>;

    /**
     * Get position for next column
     */
    nextCol(this: Layout): LuaMultiReturn<[number, number]>;

    /**
     * Alias for nextCol()
     */
    nextRight(this: Layout): LuaMultiReturn<[number, number]>;

    /**
     * Push current layout state onto stack and optionally reset
     * @param x New X position
     * @param y New Y position
     * @param padx New horizontal padding
     * @param pady New vertical padding
     */
    push(this: Layout, x?: number, y?: number, padx?: number, pady?: number): Layout;

    /**
     * Pop layout state from stack
     */
    pop(this: Layout): LuaMultiReturn<[number, number]>;
}

// ============================================================
// Core Instance
// ============================================================

interface SuitInstance {
    layout: Layout;
    theme: any;

    // Widget functions
    /** @noSelf */
    Button(
        text: string,
        options?: ButtonOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): WidgetState;
    /** @noSelf */
    Button(
        text: string,
        options: ButtonOptions,
        ...position: [number, number, number, number]
    ): WidgetState;
    /** @noSelf */
    Label(
        text: string,
        options?: LabelOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): WidgetState;
    /** @noSelf */
    Label(
        text: string,
        options: LabelOptions,
        ...position: [number, number, number, number]
    ): WidgetState;
    /** @noSelf */
    ImageButton(
        image: any,
        options?: ImageButtonOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): WidgetState;
    /** @noSelf */
    ImageButton(
        image: any,
        options: ImageButtonOptions,
        position: [number, number, number, number]
    ): WidgetState;
    /** @noSelf */
    Checkbox(
        state: { checked: boolean },
        options?: CheckboxOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): CheckboxState;
    /** @noSelf */
    Checkbox(
        state: { checked: boolean },
        options: CheckboxOptions,
        position: [number, number, number, number]
    ): CheckboxState;
    /** @noSelf */
    Input(
        state: { text: string },
        options?: InputOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): InputState;
    /** @noSelf */
    Input(
        state: { text: string },
        options: InputOptions,
        position: [number, number, number, number]
    ): InputState;
    /** @noSelf */
    Slider(
        state: { value: number },
        options?: SliderOptions,
        x?: number,
        y?: number,
        w?: number,
        h?: number
    ): SliderState;
    /** @noSelf */
    Slider(
        state: { value: number },
        options: SliderOptions,
        position: [number, number, number, number]
    ): SliderState;

    // Core state management
    setHovered(id: string | number): void;
    anyHovered(): boolean;
    isHovered(id: string | number): boolean;
    wasHovered(id: string | number): boolean;
    anyActive(): boolean;
    setActive(id: string | number): void;
    isActive(id: string | number): boolean;
    setHit(id: string | number): void;
    anyHit(): boolean;
    isHit(id: string | number): boolean;

    // Mouse handling
    mouseInRect(x: number, y: number, w: number, h: number): boolean;
    registerHitbox(id: string | number, x: number, y: number, w: number, h: number): string;
    registerMouseHit(id: string | number, x: number, y: number, w: number, h: number): void;
    mouseReleasedOn(id: string | number): boolean;
    updateMouse(x: number, y: number, isdown: boolean): void;
    getMousePosition(): [number, number];

    // Keyboard handling
    getPressedKey(): string | undefined;
    keypressed(key: string): void;
    textinput(text: string): void;
    textedited(text: string, start: number, length: number): void;
    grabKeyboardFocus(id: string | number): void;
    hasKeyboardFocus(id: string | number): boolean;
    keyPressedOn(id: string | number, key: string): boolean;

    // Frame management
    enterFrame(): void;
    exitFrame(): void;
    registerDraw(draw: (...args: any[]) => void, ...args: any[]): void;
    draw(): void;

    // Utility
    getOptionsAndSize(...args: any[]): [any, number, number, number, number];
}

// ============================================================
// Module Interface
// ============================================================

/**
 * Create a new SUIT instance
 */
function _new(): SuitInstance;

/**
 * Get options and size from arguments
 */
function getOptionsAndSize(...args: any[]): [any, number, number, number, number];

// Core state management
function setHovered(id: string | number): void;
function anyHovered(): boolean;
function isHovered(id: string | number): boolean;
function wasHovered(id: string | number): boolean;
function anyActive(): boolean;
function setActive(id: string | number): void;
function isActive(id: string | number): boolean;
function setHit(id: string | number): void;
function anyHit(): boolean;
function isHit(id: string | number): boolean;

// Mouse handling
function mouseInRect(x: number, y: number, w: number, h: number): boolean;
function registerHitbox(id: string | number, x: number, y: number, w: number, h: number): string;
function registerMouseHit(id: string | number, x: number, y: number, w: number, h: number): void;
function mouseReleasedOn(id: string | number): boolean;
function updateMouse(x: number, y: number, isdown: boolean): void;
function getMousePosition(): [number, number];

// Keyboard handling
function getPressedKey(): string | undefined;
function keypressed(key: string): void;
function textinput(text: string): void;
function textedited(text: string, start: number, length: number): void;
function grabKeyboardFocus(id: string | number): void;
function hasKeyboardFocus(id: string | number): boolean;
function keyPressedOn(id: string | number, key: string): boolean;
// Frame management
function enterFrame(): void;
function exitFrame(): void;
function registerDraw(draw: (...args: any[]) => void, ...args: any[]): void;
function draw(): void;

// Widget functions
function Button(text: string, options?: ButtonOptions, x?: number, y?: number, w?: number, h?: number): WidgetState;
function Button(text: string, options: ButtonOptions, position: [number, number, number, number]): WidgetState;

function Label(text: string, options?: LabelOptions, x?: number, y?: number, w?: number, h?: number): WidgetState;
function Label(text: string, options: LabelOptions, position: [number, number, number, number]): WidgetState;

function ImageButton(image: any, options?: ImageButtonOptions, x?: number, y?: number, w?: number, h?: number): WidgetState;
function ImageButton(image: any, options: ImageButtonOptions, position: [number, number, number, number]): WidgetState;

function Checkbox(state: { checked: boolean }, options?: CheckboxOptions, x?: number, y?: number, w?: number, h?: number): CheckboxState;
function Checkbox(state: { checked: boolean }, options: CheckboxOptions, position: [number, number, number, number]): CheckboxState;

function Input(state: { text: string }, options?: InputOptions, x?: number, y?: number, w?: number, h?: number): InputState;
function Input(state: { text: string }, options: InputOptions, position: [number, number, number, number]): InputState;

function Slider(state: { value: number }, options?: SliderOptions, x?: number, y?: number, w?: number, h?: number): SliderState;
function Slider(state: { value: number }, options: SliderOptions, position: [number, number, number, number]): SliderState;

// Layout (global instance)
const layout: Layout;

    // Theme
    let theme: any;

    // Internal instance (advanced use)
    const _instance: SuitInstance;

    // Default export (the main SUIT instance)
    const suit: SuitInstance;
    export = suit;
}