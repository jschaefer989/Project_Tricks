import Asset from "Assets/Asset";
import FontWithPosition, { Fonts, Format } from "Assets/Fonts/FontWithPosition";
import IconAsset from "Assets/IconAsset";
import Character from "Character";
import {
  CharacterTypes,
  AssetIds,
  TextIds,
  HoverEffects,
  MousePressEffects,
} from "Enums";
import GameManager from "GameManager";
import { isEmpty } from "Helpers";
import * as push from "Libraries.push";

const portraitBackgroundW = 99;
const portraitBackgroundH = 106;
const portraitW = 54;
const portraitH = 53;
const portraitGap = 12;

export default class CharacterInfoPanel {
  gameManager: GameManager;
  character: Character;

  constructor(gameManager: GameManager, character: Character) {
    this.gameManager = gameManager;
    this.character = character;
  }

  showPortrait(): void {
    this.buildPortraitBackground();
    this.buildPortrait();
    const nameY = this.buildPortraitName();
    const levelY = this.buildPortraitLevel(nameY);
    this.buildCharacterSpecificInfo(nameY, levelY);
    this.buildPowerAndValues();
  }

  private buildPortraitBackground(): void {
    this.gameManager.assetManager.addAsset(
      this.getPortraitBackgroundId(),
      new Asset(
        this.gameManager,
        this.getPortraitBackgroundId(),
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PortraitBackground.png"
        ),
        5,
        this.getPortraitPosition(),
        portraitBackgroundW,
        portraitBackgroundH
      )
    );
  }

  private buildPortrait(): void {
    this.gameManager.assetManager.addAsset(
      this.getPortraitId(),
      new Asset(
        this.gameManager,
        this.getPortraitId(),
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/Portrait.png"
        ),
        5,
        this.getPortraitPosition(),
        portraitW,
        portraitH
      )
    );
  }

  private buildPortraitName(): number {
    const nameY = portraitH + this.getPortraitPosition() + 10;
    this.gameManager.assetManager.textManager.addText(
      this.getPortraitNameId(),
      new FontWithPosition(
        this.getPortraitNameId(),
        10,
        nameY,
        this.character.name,
        { size: 16, font: Fonts.FANTASY }
      )
    );
    return nameY;
  }

  private buildPortraitLevel(nameY: number): number {
    const levelY = nameY + portraitGap;
    this.gameManager.assetManager.textManager.addText(
      this.getPortraitLevelId(),
      new FontWithPosition(
        this.getPortraitLevelId(),
        10,
        levelY,
        `Lvl ${this.character.level}`,
        { size: 9 }
      )
    );
    return levelY;
  }

  private buildCharacterSpecificInfo(nameY: number, levelY: number): void {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        this.buildPlayerInfo(nameY, levelY);
        break;
      case CharacterTypes.ENEMY:
        break;
    }
  }

  private buildPlayerInfo(nameY: number, levelY: number): void {
    this.buildPlayerExperience(levelY);
    this.buildPerksButton();
    this.buildPlayerMoney(nameY);
  }

  private buildPlayerExperience(levelY: number): void {
    this.gameManager.assetManager.textManager.addText(
      TextIds.PLAYER_PORTRAIT_EXPERIENCE,
      new FontWithPosition(
        TextIds.PLAYER_PORTRAIT_EXPERIENCE,
        portraitBackgroundW,
        levelY,
        `${this.gameManager.player.experience} xp`,
        { size: 9, format: Format.RIGHT }
      )
    );
  }

  private buildPerksButton(): void {
    const perksText = new FontWithPosition(
      TextIds.PLAYER_PERKS,
      portraitW + 13,
      this.getPortraitPosition() + 20,
      "Perks",
      { size: 9 }
    );
    this.gameManager.assetManager.textManager.addText(
      TextIds.PLAYER_PERKS,
      perksText
    );

    this.gameManager.assetManager.addAsset(
      AssetIds.PERKS_BUTTON,
      new Asset(
        this.gameManager,
        AssetIds.PERKS_BUTTON,
        this.gameManager.assetManager.assetLoader.loadImage(
          "Assets/Images/PerksButton.png"
        ),
        portraitW + 8,
        this.getPortraitPosition() + 10,
        39,
        18,
        {
          onClick: () => this.gameManager.perkScreen.showPerks(),
          clickSound: this.gameManager.assetManager.buttonClickSound,
          associatedTexts: [perksText],
          hoverEffect: [HoverEffects.CHANGE_COLOR],
          mousePressEffect: [
            MousePressEffects.DARKEN,
            MousePressEffects.SHIFT_DOWN,
          ],
          alwaysEnabled: true,
        }
      )
    );
  }

  private buildPlayerMoney(nameY: number): void {
    this.gameManager.assetManager.textManager.addText(
      TextIds.PLAYER_PORTRAIT_MONEY,
      new FontWithPosition(
        TextIds.PLAYER_PORTRAIT_MONEY,
        portraitBackgroundW - 2,
        nameY,
        `${this.gameManager.player.money}`,
        {
          size: 9,
          icon: new IconAsset(
            this.gameManager,
            AssetIds.MONEY_ICON,
            this.gameManager.assetManager.assetLoader.loadImage(
              "Assets/Images/Mark.png"
            ),
            9,
            9
          ),
          format: Format.RIGHT,
        }
      )
    );
  }

  private buildPowerAndValues(): void {
    const board = this.gameManager.board;
    if (isEmpty(board)) {
      return;
    }

    const levelText = this.gameManager.assetManager.textManager.getText(
      this.getPortraitLevelId()
    );
    if (isEmpty(levelText)) {
      return;
    }

    const powerY = levelText.y + portraitGap;
    this.gameManager.assetManager.textManager.addText(
      this.getPortraitPowerId(),
      new FontWithPosition(
        this.getPortraitPowerId(),
        20,
        powerY,
        board.getCharacterPower(this.character.type).toString(),
        {
          icon: IconAsset.getPowerIconAsset(
            this.gameManager,
            this.getPortraitPowerIconId()
          ),
        }
      )
    );

    this.gameManager.assetManager.textManager.addText(
      this.getPortraitValueId(),
      new FontWithPosition(
        this.getPortraitValueId(),
        20,
        powerY + portraitGap,
        board.getCharacterValue(this.character.type).toString(),
        {
          icon: IconAsset.getValueIconAsset(
            this.gameManager,
            this.getPortraitValueIconId()
          ),
        }
      )
    );
  }

  getPortraitBackgroundId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return AssetIds.PLAYER_PORTRAIT_BACKGROUND;
      case CharacterTypes.ENEMY:
        return AssetIds.ENEMY_PORTRAIT_BACKGROUND;
    }
  }

  getPortraitId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return AssetIds.PLAYER_PORTRAIT;
      case CharacterTypes.ENEMY:
        return AssetIds.ENEMY_PORTRAIT;
    }
  }

  getPortraitNameId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return TextIds.PLAYER_PORTRAIT_NAME;
      case CharacterTypes.ENEMY:
        return TextIds.ENEMY_PORTRAIT_NAME;
    }
  }

  getPortraitLevelId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return TextIds.PLAYER_PORTRAIT_LEVEL;
      case CharacterTypes.ENEMY:
        return TextIds.ENEMY_PORTRAIT_LEVEL;
    }
  }

  getPortraitPowerId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return TextIds.PLAYER_POWER;
      case CharacterTypes.ENEMY:
        return TextIds.ENEMY_POWER;
    }
  }

  getPortraitPowerIconId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return AssetIds.PLAYER_ATTACK_POWER_ICON;
      case CharacterTypes.ENEMY:
        return AssetIds.ENEMY_ATTACK_POWER_ICON;
    }
  }

  getPortraitValueId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return TextIds.PLAYER_VALUE;
      case CharacterTypes.ENEMY:
        return TextIds.ENEMY_VALUE;
    }
  }

  getPortraitValueIconId(): string {
    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        return AssetIds.PLAYER_VALUE_ICON;
      case CharacterTypes.ENEMY:
        return AssetIds.ENEMY_VALUE_ICON;
    }
  }

  getPortraitHeight(): number | undefined {
    const portraitAsset = this.gameManager.assetManager.getAsset(
      AssetIds.PLAYER_PORTRAIT,
      AssetIds.PLAYER_PORTRAIT
    );
    if (isEmpty(portraitAsset)) {
      return;
    }
    return portraitAsset.getHeight();
  }

  getPortraitWidth(): number | undefined {
    const portraitAsset = this.gameManager.assetManager.getAsset(
      AssetIds.PLAYER_PORTRAIT,
      AssetIds.PLAYER_PORTRAIT
    );
    if (isEmpty(portraitAsset)) {
      return;
    }
    return portraitAsset.getWidth();
  }

  getPortraitPosition(): number {
    const assetY = this.gameManager.assetManager.getAsset(this.getPortraitId(), this.getPortraitId());
    if (!isEmpty(assetY)) {
      return assetY.y;
    }

    switch (this.character.type) {
      case CharacterTypes.PLAYER:
        const cardAssets = this.gameManager.board?.cardAssets;
        if (!isEmpty(cardAssets)) {
          return cardAssets.getHandYCoordinate(this.character.type);
        }
        return push.getHeight() - (this.getPortraitHeight() ?? 0) - 10;
      case CharacterTypes.ENEMY:
        return 5;
    }
  }
}
