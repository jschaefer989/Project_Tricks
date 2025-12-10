/** @noSelfInFile */
import { Ranks, Suits } from "./Enums";
export default class Card {
    suit: Suits;
    rank: Ranks;
    power: number;
    value: number;
    selected: boolean;
    constructor(suit: Suits, rank: Ranks);
    isEqual(otherCard: Card): boolean;
    getPower(suit: string, rank: string): number;
    getValue(rank: string): number;
}
