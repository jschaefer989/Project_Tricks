// TypeScript declaration file for json.lua
// https://github.com/rxi/json.lua

/** @noSelfInFile */

interface JsonModule {
    /** Library version */
    _version: string

    /**
     * Encode a Lua value to a JSON string
     * @param value The value to encode (table, string, number, boolean, or nil)
     * @returns JSON string representation
     * @throws Error if value contains circular references, mixed/invalid key types, or sparse arrays
     */
    encode(this: void, value: any): string

    /**
     * Decode a JSON string to a Lua value
     * @param str The JSON string to decode
     * @returns Decoded Lua value (table, string, number, boolean, or null as nil)
     * @throws Error if string contains invalid JSON
     */
    decode(this: void, str: string): any
}

declare module "Libraries.jsonlua-master" {
    const json: JsonModule
    export = json
}

