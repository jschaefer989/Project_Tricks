import Character from "Character";
import GameManager from "GameManager";
export default class CharacterInfoPanel {
    gameManager: GameManager;
    character: Character;
    constructor(gameManager: GameManager, character: Character);
    showPortrait(): void;
    private buildPortraitBackground;
    private buildPortrait;
    private buildPortraitName;
    private buildPortraitLevel;
    private buildCharacterSpecificInfo;
    private buildPlayerInfo;
    private buildPlayerExperience;
    private buildPerksButton;
    private buildPlayerMoney;
    private buildPowerAndValues;
    getPortraitBackgroundId(): string;
    getPortraitId(): string;
    getPortraitNameId(): string;
    getPortraitLevelId(): string;
    getPortraitPowerId(): string;
    getPortraitPowerIconId(): string;
    getPortraitValueId(): string;
    getPortraitValueIconId(): string;
    getPortraitHeight(): number | undefined;
    getPortraitWidth(): number | undefined;
    getPortraitPosition(): number;
}
