extends Control
##
## AugmentCard Class
##
## Creates an object on the screen in the shape of a card, 
##
class_name Augment


const AugmentEssentials = preload("res://gameplay/augments/augment_essentials.gd")


# var ability_type: AbilityType TODO: Add ability Type and implement augments that give them
var rarity: AugmentEssentials.Rarity ## How common is this augment
var classifiers: Array[AugmentEssentials.Classifier] ## What type of objects can this augment be applied to
var augment_name: String ## What is this augment called
var description: String ## Describes the augment's purpose in text
var stats: Array[AugmentEssentials.StatType] ## What is given by this augment

## If this is null, then it is NOT an evolution augment
## Each index corresponds to a rarity ( TODO: May change to dictionary later )
var evolution_conditions: Array[Array]


func _init() -> void:
	augment_name = "Blank Augment"
	description = "Placeholder augment used as the base of all augment classes."


func _ready() -> void:
	pass


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEvolution() -> bool:
	rarity = AugmentEssentials.Rarity.EVOLUTION
	
	return false


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendary() -> bool:
	rarity = AugmentEssentials.Rarity.LEGENDARY
	
	return false


## Set the augment to a epic rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEpic() -> bool:
	rarity = AugmentEssentials.Rarity.COMMON
	
	return false


## Set the augment to a rare rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setRare() -> bool:
	rarity = AugmentEssentials.Rarity.COMMON
	
	return false


## Set the augment to a uncommon rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setUncommon() -> bool:
	rarity = AugmentEssentials.Rarity.COMMON
	
	return false


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setCommon() -> bool:
	rarity = AugmentEssentials.Rarity.COMMON
	
	return false
