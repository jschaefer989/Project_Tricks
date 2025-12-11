/** @noSelfInFile */

export function isEmpty<T>(test: T | null | undefined): test is null | undefined {
    return test === null || test === undefined;
}

/**
 * Returns a random value from a TypeScript enum.
 * @param anEnum The enum object (e.g., Color, LoadBalancingPolicy).
 * @returns A random value of the enum's value type.
 */
export function getRandomElementFromEnum<T extends object>(anEnum: T): T[keyof T] {
  // Get all values of the enum (which can contain both strings and numbers for numeric enums)
  const enumValues = Object.values(anEnum) as T[keyof T][];
  
  // Filter out the numeric keys in a numeric enum to only keep the value names/string keys,
  // or simply keep all values in a string enum.
  const relevantValues = enumValues.filter(value => typeof value !== 'number');

  // Generate a random index based on the length of the filtered values array
  const randomIndex = Math.floor(Math.random() * relevantValues.length);
  
  // Return the random value
  return relevantValues[randomIndex];
}

export function getRandomElementFromArray<T>(arr: T[]): T | undefined {
  if (arr.length === 0) {
    return // Handle empty array case
  }
  const randomIndex = Math.floor(Math.random() * arr.length);
  return arr[randomIndex];
}

export function exhaustiveGuard(value: never): never {
  throw new Error(`ERROR! Reached forbidden guard function with unexpected value: ${JSON.stringify(value)}`);
}