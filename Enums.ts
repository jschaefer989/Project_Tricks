export enum GameStates {
    MAIN_MENU = "MAIN_MENU",
    NEW_GAME_MENU = "NEW_GAME_MENU",
    PLAYING = "PLAYING",
    PAUSE_MENU = "PAUSE_MENU",
    WIN_SCREEN = "WIN_SCREEN",
    LOSE_SCREEN = "LOSE_SCREEN",
    MAP = "MAP",
    SHOP = "SHOP",
    LEVEL_UP = "LEVEL_UP",
}
export enum Suits {
    HEARTS = "HEARTS",
    BELLS = "BELLS",
    ACORNS = "ACORNS",
    LEAVES = "SPADES",
}

export enum Ranks {
    KING = "KING",
    OVERLORD = "OVERLORD",
    SERGEANT = "SERGEANT",
    BANNER = "BANNER",
    THIEF = "THIEF",
    PRIEST = "PRIEST",
    SOLDIER = "SOLDIER",
    BARON = "BARON",
    JESTER = "JESTER",
    DEUCE = "DEUCE"
}

export enum TrumpRanks {
    TRICK = "TRICK",
    DEVIL = "DEVIL",
    POPE = "POPE",
    EMPEROR = "EMPEROR",
    BARD = "BARD",
    DUKE = "DUKE",
    KNIGHT = "KNIGHT",
}

export enum CharacterTypes {
    PLAYER = "PLAYER",
    ENEMY = "ENEMY",
}

export enum MapNodeTypes {
    BATTLE = "BATTLE",
    SHOP = "SHOP",
}

export enum EnemyTypes {
    GOBLIN = "GOBLIN",
    ORC = "ORC",
    TROLL = "TROLL",
    DRAGON = "DRAGON",
}

export enum Perks {
    EXTRA_CARD = "EXTRA_CARD",
    EXTRA_DISCARD = "EXTRA_DISCARD",
    INCREASED_LOOT = "INCREASED_LOOT",
}