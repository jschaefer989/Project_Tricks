/** @noSelfInFile */
export declare function isEmpty<T>(test: T | null | undefined): test is null | undefined;
/**
 * Returns a random value from a TypeScript enum.
 * @param anEnum The enum object (e.g., Color, LoadBalancingPolicy).
 * @returns A random value of the enum's value type.
 */
export declare function getRandomElementFromEnum<T extends object>(anEnum: T): T[keyof T];
export declare function getRandomElementFromArray<T>(arr: T[]): T | undefined;
export declare function exhaustiveGuard(value: never): never;
