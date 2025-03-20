extends Augment


func _init() -> void:
	augment_name = "Level"
	description = "Instantly obtain a level"
	icon = PlaceholderTexture2D.new() # TODO: Add texture
	classifiers = [AugmentEssentials.Classifier.PLAYER]


## Set the augment to a legendary rarity
## returns: True if the rarity exists, False if the rarity does not exist
func setLegendaryRarity() -> bool:
	super.setLegendaryRarity()
	
	# Globals.Pair.new(AugmentEssentials.StatType, value: int, float, etc)
	stats = [
		Globals.Pair.new(AugmentEssentials.StatType.PLAYER_LEVEL, int(1))
	]
	
	return true
