/**
 * SYSL-Text - Fancy Text System for LÖVE2D
 * @see https://github.com/SystemLogoff/SYSL-Text
 */

/** @noSelfInFile */

/** Text alignment options */
type SYSLTextAlignment = "left" | "center" | "right";

/** Default textbox settings */
interface SYSLTextboxSettings {
    autotags?: string;
    font?: any;
    color?: [number, number, number, number];
    shadow_color?: [number, number, number, number];
    print_speed?: number;
    adjust_line_height?: number;
    default_strikethrough_position?: number;
    default_underline_position?: number;
    character_sound?: boolean;
    sound_number?: number;
    sound_every?: number;
    default_warble?: number;
}

/** Textbox get properties */
interface SYSLTextboxGetProperties {
    width: number;
    height: number;
    lines: number;
}

/** Textbox instance */
interface SYSLTextbox {
    get: SYSLTextboxGetProperties;
    send(text: string, wrap_num?: number, show_all?: boolean): void;
    draw(x: number, y: number): void;
    update(dt: number): void;
    is_finished(): boolean;
    continue(): void;
}

/** Configuration interface */
interface SYSLTextConfigure {
    audio_table(table_string: any): void;
    font_table(table_string: any): void;
    image_table(table_string: any): void;
    icon_table(table_string: any): void;
    palette_table(table_string: any): void;
    shader_table(table_string: any): void;
    function_command_enable(enable_bool: boolean): void;
    add_text_sound(sound: any, volume?: number): void;
}

/** SYSLText global namespace */
interface SYSLTextNamespace {
    debug: boolean;
    _NAME: string;
    _VERSION: string;
    _DESCRIPTION: string;
    _URL: string;
    _LICENSE: string;
    configure: SYSLTextConfigure;
    /** @noSelf */
    ["new"](alignment?: SYSLTextAlignment, settings?: SYSLTextboxSettings): SYSLTextbox;
}

declare const SYSLText: SYSLTextNamespace;
