import GameManager from "GameManager";
interface ConstructorOptions {
    secondaryMessage?: string;
}
export default class Prompt {
    gameManager: GameManager;
    private message;
    private onYesClick;
    private onNoClick;
    private button;
    constructor(gameManager: GameManager, message: string, onYesClick: () => void, onNoClick: () => void, constructionOptions?: ConstructorOptions);
    open(id: string): void;
    buildYesButton(): void;
    buildNoButton(): void;
}
export {};
