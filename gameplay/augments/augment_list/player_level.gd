extends Augment


func _init() -> void:
	augment_name = "Cubes"
	description = "Instantly obtain cubes"
	icon = PlaceholderTexture2D.new() # TODO: Add texture
	classifiers = [AugmentEssentials.Classifier.PLAYER]


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEvolutionRarity() -> bool:
	super.setEvolutionRarity()
	
	evolution_conditions = [
		[AugmentEssentials.EvolutionCondition.NONE], # Common
		[AugmentEssentials.EvolutionCondition.NONE], # Uncommon
		[AugmentEssentials.EvolutionCondition.NONE], # Rare
		[AugmentEssentials.EvolutionCondition.NONE], # Epic
		[AugmentEssentials.EvolutionCondition.NONE]  # Legendary
	]
	
	# TODO: Implement evolution types later
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, int(1))
	]
	
	return true
