/**
 * TypeScript declarations for loaded_dice library
 * A library that implements Walker-Vose alias method for efficiently simulating a loaded die
 * @see https://github.com/excessive/loaded_dice
 */

/** @noSelfInFile */

/**
 * A loaded die object that can generate weighted random numbers
 */
interface LoadedDie {
    /** Array of weights for each side of the die */
    weights: number[]
    /** Internal alias table for sampling */
    alias: number[]
    /** Internal probability table for sampling */
    prob: number[]
    /** Flag indicating if alias table needs rebuilding */
    dirty: boolean

    /**
     * Add a new weighted side to the die
     * @param weight - The weight value (dimensionless, probability is proportional to total sum)
     */
    add(this: LoadedDie, weight: number): void

    /**
     * Replace weight at existing index
     * @param index - The index of the weight to replace (1-based)
     * @param weight - The new weight value
     */
    set(this: LoadedDie, index: number, weight: number): void

    /**
     * Get the weight at a specific index
     * @param index - The index of the weight (1-based)
     * @returns The weight value at the specified index
     */
    get(this: LoadedDie, index: number): number | undefined

    /**
     * Build the alias table manually
     * Note: This is called automatically when needed
     */
    build_alias(this: LoadedDie): void

    /**
     * Generate a weighted random number
     * @param rd - Optional random number in range [0,1) for die selection
     * @param rn - Optional random number in range [0,1) for probability check
     * @returns A weighted random integer between 1 and the number of weights
     */
    sample(this: LoadedDie, rd?: number, rn?: number): number

    /**
     * Alias for sample() - Generate a weighted random number
     * @param rd - Optional random number in range [0,1) for die selection
     * @param rn - Optional random number in range [0,1) for probability check
     * @returns A weighted random integer between 1 and the number of weights
     */
    random(this: LoadedDie, rd?: number, rn?: number): number

    /**
     * Generate a weighted random number using a custom random function
     * @param fn - Function that returns a random number in range [0,1)
     * @returns A weighted random integer between 1 and the number of weights
     */
    random_fn(this: LoadedDie, fn: () => number): number

    /**
     * Generate a weighted random number using a random number generator object
     * @param rng - Random number generator object
     * @param fn - Optional method name to call on rng (defaults to "random")
     * @returns A weighted random integer between 1 and the number of weights
     */
    random_gen(this: LoadedDie, rng: any, fn?: string): number
}

/**
 * Loaded dice library module
 */
interface LoadedDiceModule {
    /**
     * Create a new loaded die
     * @param weights - Optional initial weights as varargs or a table
     * @returns A new LoadedDie object
     */
    new_die(this: void, ...weights: number[]): LoadedDie
    /**
     * Create a new loaded die from a table of weights
     * @param weights - Array of weight values
     * @returns A new LoadedDie object
     */
    new_die(this: void, weights: number[]): LoadedDie
}

declare module "Libraries.loaded_dice-main.loaded_dice" {
    const loadedDice: LoadedDiceModule
    export = loadedDice
}
