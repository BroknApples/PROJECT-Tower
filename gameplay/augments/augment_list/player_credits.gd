extends Augment


func _init() -> void:
	augment_name = "Credits"
	description = "Instantly obtain credits"
	icon = PlaceholderTexture2D.new() # TODO: Add texture
	classifiers = [AugmentEssentials.Classifier.PLAYER]


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendaryRarity() -> bool:
	super.setLegendaryRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 2500)
	]
	
	return true


## Set the augment to a epic rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEpicRarity() -> bool:
	super.setEpicRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 1500)
	]
	
	return true


## Set the augment to a rare rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setRareRarity() -> bool:
	super.setRareRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 1000)
	]
	
	return true


## Set the augment to a uncommon rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setUncommonRarity() -> bool:
	super.setUncommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 500)
	]
	
	return true


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setCommonRarity() -> bool:
	super.setCommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS, 250)
	]
	
	return true
