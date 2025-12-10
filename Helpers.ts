/** @noSelfInFile */

export function isEmpty<T>(test: T | null | undefined): test is null | undefined {
    return test === null || test === undefined;
}

export function getRandomElementFromTable<T>(tbl: Record<string, T>): T | undefined {
    const keys: string[] = []
    
    // Populate the 'keys' array with the named keys from 'tbl'
    for (const k in tbl) {
        keys.push(k)
    }

    // If the table is empty, return undefined
    if (keys.length === 0) {
        return
    }

    // Get a random index from the 'keys' array
    const randomIndex = Math.floor(Math.random() * keys.length)
    // Get the random key
    const randomKey = keys[randomIndex]
    // Return the value associated with the random key from the original table
    return tbl[randomKey]
}

export function getRandomElementFromArray<T>(arr: T[]): T | undefined {
  if (arr.length === 0) {
    return // Handle empty array case
  }
  const randomIndex = Math.floor(Math.random() * arr.length);
  return arr[randomIndex];
}
