/** @noSelfInFile */
import Card from "Cards/Card";
import GameManager from "GameManager";
interface ShopData {
    cardsForSale?: Card[];
}
export default class Shop {
    gameManager: GameManager;
    cardsForSale: Card[];
    constructor(gameManager: GameManager);
    load(data: ShopData): void;
    save(): ShopData;
    drawShop(): void;
    setup(): void;
    generateCardsForSale(): void;
    canAfford(card: Card): boolean;
    buyCard(card: Card): void;
    removeCardFromSale(card: Card): void;
}
export {};
