extends Augment


func _init() -> void:
	augment_name = "Credit Earn Rate"
	description = "Increase the amount of credits you earn in the future"
	icon = PlaceholderTexture2D.new() # TODO: Add texture
	classifiers = [AugmentEssentials.Classifier.PLAYER]


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendaryRarity() -> bool:
	super.setLegendaryRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT, 67.25)
	]
	
	return true


## Set the augment to a epic rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setEpicRarity() -> bool:
	super.setEpicRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT, 42.5)
	]
	
	return true


## Set the augment to a rare rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setRareRarity() -> bool:
	super.setRareRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT, 25.0)
	]
	
	return true


## Set the augment to a uncommon rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setUncommonRarity() -> bool:
	super.setUncommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT, 15.0)
	]
	
	return true


## Set the augment to a common rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setCommonRarity() -> bool:
	super.setCommonRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT, 10.0)
	]
	
	return true
