extends Node
##
## Defines essential types and functions for augments to function
##


## Rarity enum
## How common it to draw an augment
enum Rarity {
	EVOLUTION,
	LEGENDARY,
	EPIC,
	RARE,
	UNCOMMON,
	COMMON
}


## AugmentClassifier enum
## Classifies which type of object this augment can be applied to
enum Classifier {
	PLAYER,
	TOWER,
	WEAPON_CLASS, # includes all it's children types (tower_weapons, player_weapons, etc.)
	TOWER_WEAPON,
	PLAYER_WEAPON,
	MISC
}


## AugmentStatType enum
## Used to assign a stat augment to a player
## Every stat and special ability in the game should be in this enum
enum StatType {
	PLAYER_CREDITS, # Gives some flat credits
	PLAYER_CREDITS_PERCENT, # Gives a percentage increase to your credit gain in the future
	PLAYER_CUBES, # Gives some flat cubes
	PLAYER_CUBES_PERCENT, # Gives a percentage increase to your cube gain in the future
	PLAYER_LUCK, # Gives some flat luck
	PLAYER_XP_PERCENT, # Gives some percent of your xp bar in xp
	PLAYER_LEVEL, # Adds a flat level
	TOWER_BASE_MAX_HP, # Gives a flat increase to base max hp
	TOWER_BASE_MAX_HP_PERCENT, # Gives a percent increase to base max hp
	TOWER_BASE_ARMOR, # Gives a flat increase to base armor
	TOWER_BASE_ARMOR_PERCENT, # Gives a percent increase to base armor
	TOWER_BASE_HP_REGEN, # Gives a flat increase to base hp regen
	TOWER_BASE_HP_REGEN_PERCENT, # Gives a percent increase to base hp regen
	TOWER_MAX_HP, # Gives a flat increase to max hp
	TOWER_MAX_HP_PERCENT, # Gives a percent increase to max hp
	TOWER_ARMOR, # Gives a flat increase to armor
	TOWER_ARMOR_PERCENT, # Gives a percent increase to armor
	TOWER_HP_REGEN, # Gives a flat increase to hp regen
	TOWER_HP_REGEN_PERCENT, # Gives a percent increase to hp regen
}
