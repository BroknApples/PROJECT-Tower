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

## Get a string from a rarity type
func rarityToString(rarity: Rarity) -> String:
	match(rarity):
		Rarity.EVOLUTION:
			return "Evolution"
		Rarity.LEGENDARY:
			return "Legendary"
		Rarity.EPIC:
			return "Epic"
		Rarity.RARE:
			return "Rare"
		Rarity.UNCOMMON:
			return "Uncommon"
		Rarity.COMMON:
			return "Common"
	
	return "Null"

## Get the color of the main elements of an augment given the rarity
func rarityToColor(rarity: Rarity) -> Color:
	const EVOLUTION_COLOR = Color("#add4db")
	const LEGENDARY_COLOR = Color("#fcd10f")
	const EPIC_COLOR = Color("#5f00a0")
	const RARE_COLOR = Color("#2c2cff")
	const UNCOMMON_COLOR = Color("#0add08")
	const COMMON_COLOR = Color("#d3d3d3")
	
	match(rarity):
		Rarity.EVOLUTION:	return EVOLUTION_COLOR
		Rarity.LEGENDARY:	return LEGENDARY_COLOR
		Rarity.EPIC:		return EPIC_COLOR
		Rarity.RARE:		return RARE_COLOR
		Rarity.UNCOMMON:	return UNCOMMON_COLOR
		Rarity.COMMON:		return COMMON_COLOR
	
	return Color()

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


## EvolutionCondition enum
## Conditions for an evolution rarity augment to upgrade itself
enum EvolutionCondition {
	NONE
}


## AugmentStatType enum
## Used to assign a stat augment to a player
## Every stat and special ability in the game should be in this enum
enum StatType {
	PLAYER_CREDITS, # Gives some flat credits
	PLAYER_CREDITS_PERCENT, # Gives a percentage increase to your credit earnings in the future
	PLAYER_CUBES, # Gives some flat cubes
	PLAYER_CUBES_PERCENT, # Gives a percentage increase to your cube earnings in the future
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

func statTypeToString(type: StatType) -> String:
	match(type):
		StatType.PLAYER_CREDITS:					return "Credits"
		StatType.PLAYER_CREDITS_PERCENT:			return "Credit Earn Rate"
		StatType.PLAYER_CUBES:						return "Cubes"
		StatType.PLAYER_CUBES_PERCENT:				return "Cube Earn Rate"
		StatType.PLAYER_LUCK:						return "Luck"
		StatType.PLAYER_XP_PERCENT:					return "XP Earn Rate"
		StatType.PLAYER_LEVEL:						return "Levels"
		StatType.TOWER_BASE_MAX_HP:					return "Tower Base Max HP"
		StatType.TOWER_BASE_MAX_HP_PERCENT:			return "Tower Base Max HP Percent"
		StatType.TOWER_BASE_ARMOR:					return "Tower Base Armor"
		StatType.TOWER_BASE_ARMOR_PERCENT:			return "Tower Base Armor Percent"
		StatType.TOWER_BASE_HP_REGEN:				return "Tower Base HP Regen Percent"
		StatType.TOWER_BASE_HP_REGEN_PERCENT:		return "Tower Base HP Regen Percent" 
		StatType.TOWER_MAX_HP:						return "Tower Max HP"
		StatType.TOWER_MAX_HP_PERCENT:				return "Tower Max HP Percent"
		StatType.TOWER_ARMOR:						return "Tower Armor"
		StatType.TOWER_ARMOR_PERCENT:				return "Tower Armor Percent"
		StatType.TOWER_HP_REGEN:					return "Tower HP Regen Percent"
		StatType.TOWER_HP_REGEN_PERCENT:			return "Tower HP Regen Percent"
	
	return "Invalid StatType"
