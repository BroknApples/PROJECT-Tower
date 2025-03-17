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
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 5.0)
	]
	
	return true


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendaryRarity() -> bool:
	super.setLegendaryRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 50.0)
	]
	
	return true


## Set the augment to a epic rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEpicRarity() -> bool:
	super.setEpicRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 35.0)
	]
	
	return true


## Set the augment to a rare rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setRareRarity() -> bool:
	super.setRareRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 20)
	]
	
	return true


## Set the augment to a uncommon rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setUncommonRarity() -> bool:
	super.setUncommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 10.0)
	]
	
	return true


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setCommonRarity() -> bool:
	super.setCommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CUBES, 5.0)
	]
	
	return true
