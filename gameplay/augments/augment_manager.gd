extends Node
##
## Handles how augments are processed and applied
##


var aug_queue: Array ## If there is already an augment selection screen, add the new one to a queue
const AugmentEssentials = preload("res://gameplay/augments/augment_essentials.gd")

## Augment Lists
var all_augments: Array[Augment]
var legendary_augments: Array[Augment]
var epic_augments: Array[Augment]
var rare_augments: Array[Augment]
var uncommon_augments: Array[Augment]
var common_augments: Array[Augment]


func _ready() -> void:
	_setupAugmentLists("res://gameplay/augments/augment_list/")
	# TESTING
	#var chances2 = []
	#var chance3 = [0, 25, 50, 100, 150, 200, 250, 300]
	#chances2.push_back(_getChances(0))
	#chances2.push_back(_getChances(25))
	#chances2.push_back(_getChances(50))
	#chances2.push_back(_getChances(100))
	#chances2.push_back(_getChances(150))
	#chances2.push_back(_getChances(200))
	#chances2.push_back(_getChances(250))
	#chances2.push_back(_getChances(300))
	#
	#print("TESTCHANCES NEW ENTIRE BATCH")
	#var i = 0
	#for a in chances2:
		#print("TESTCHANCES " + str(chance3[i]) + "\n")
		#i += 1
		#var c = 0
		#for j in a:
			#print("TESTCHANCES: " + str(c + 1) + ": " + str(AugmentEssentials.new().rarityToString(c) + " ->   " + str(a[j])))
			#c += 1
		#print("TESTCHANCES\n")
	# TESTING


func _process(_delta: float) -> void:
	if (self.get_child_count() == 0 && aug_queue.size() != 0):
		self.add_child(aug_queue.pop_front())

## Setup Augment Lists
func _setupAugmentLists(directory_path: String) -> void:
	var dir = DirAccess.open(directory_path)
	if (dir == null):
		print("ERROR: Could not initialize augments.")
		return
	
	dir.list_dir_begin()
	var file = dir.get_next()
	
	while (file != ""):
		# Skip . and .. files -> skip current & parent dir
		if (file == "." || file == ".."):
			file = dir.get_next()
			continue
		
		# If there is an inner directory, do not continue, it is not the format I want
		if (dir.current_is_dir()):
			print("ERROR: Directory detected in an augment folder. Please remove.")
			return
		
		var full_path = directory_path + file
		
		# Check which rarities of the augment exist
		var instance = load(full_path).new()  # Temporarily instantiate this augment
		
		all_augments.push_back(instance.duplicate()) # All Augments
		
		if (instance.setLegendaryRarity()): 				# Legendary augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setLegendaryRarity()
			legendary_augments.push_back(rarity_aug)

		if (instance.setEpicRarity()): 						# Epic augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setEpicRarity()
			epic_augments.push_back(rarity_aug)
		
		if (instance.setRareRarity()): 						# Rare augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setRareRarity()
			rare_augments.push_back(rarity_aug)
		
		if (instance.setUncommonRarity()): 					# Uncommon augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setUncommonRarity()
			uncommon_augments.push_back(rarity_aug)
		
		if (instance.setCommonRarity()): 					# Common augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setCommonRarity()
			common_augments.push_back(rarity_aug)
		
		instance.free() # Delete augment instance
		
		file = dir.get_next()
	
	print("Augments initialized...")


## Roll 3 augments
## player: which player owns the luck stat and will be assigned the augment
## type_classifiers: Specifiers which augment types can be rolled by this augment batch
func rollAugments(player: Player, type_classifiers: Array[AugmentEssentials.Classifier] = []) -> void:
	var augments: Array[Augment] = []
	
	for i in range(1, 4):
		var rarity: AugmentEssentials.Rarity
		
		var chances := _getChances(player.stats.luck)
		
		# Choose a random rarity
		var rand_float = Globals.rng.randf_range(0, 1.0)
		
		var curr_total = 0.0
		for key in chances:
			curr_total += chances[key]
			
			if (rand_float <= curr_total):
				rarity = key
				break
		
		# Instantiate a new augment of a certain rarity
		var new_aug = _getAugmentOfRarity(rarity)
		if (new_aug != null):
			augments.push_back(new_aug)
	
	print("Augments Rolled:")
	for i in range(0, 3):
		print("     Augment" + str(i + 1) + ": " + augments[i].augment_name)
	
	var aug_selection_screen = load("res://gameplay/augments/augment_selection_screen.tscn").instantiate()
	aug_selection_screen.initialize(player, augments)
	if (self.get_child_count() == 0):
		self.add_child(aug_selection_screen)
	else:
		aug_queue.push_back(aug_selection_screen)


## Get the chances to roll any given augment rarity
func _getChances(luck: int) -> Dictionary:
	clamp(luck, 0, 300) # Max luck is 300
	var luck_factor: float = luck / 300.0
	
	# Chance ranges
	const LEGENDARY_INITIAL := 0.01
	const EPIC_INITIAL := 0.05
	const RARE_INITIAL := 0.12
	const UNCOMMON_INITIAL := 0.22
	const COMMON_INITIAL := 0.60
	
	const RARE_MIDPOINT := 0.27
	const RARE_LUCK_MIDPOINT := 180.0 ## Luck value needed to chance distribution method
	const UNCOMMON_MIDPOINT := 0.35
	const UNCOMMON_LUCK_MIDPOINT := 130.0 ## Luck value needed to chance distribution method
	
	const LEGENDARY_FINAL := 0.15
	const EPIC_FINAL:= 0.24
	const RARE_FINAL := 0.34
	const UNCOMMON_FINAL := 0.20
	const COMMON_FINAL := 0.12
	
	# Calculate chances with some given distributions
	var legendary_chance := lerpf(LEGENDARY_INITIAL, LEGENDARY_FINAL, ease(luck_factor, 2.6))
	var epic_chance := lerpf(EPIC_INITIAL, EPIC_FINAL, ease(luck_factor, -1.8))
	var rare_chance := lerpf(RARE_INITIAL, RARE_MIDPOINT, ease(luck/RARE_LUCK_MIDPOINT, -2.4)) if luck < RARE_LUCK_MIDPOINT else lerpf(RARE_MIDPOINT, RARE_FINAL, ease(luck_factor, 1.8))
	var uncommon_chance := lerpf(UNCOMMON_INITIAL, UNCOMMON_MIDPOINT, ease(luck/UNCOMMON_LUCK_MIDPOINT, -1.4)) if luck < UNCOMMON_LUCK_MIDPOINT else lerpf(UNCOMMON_MIDPOINT, UNCOMMON_FINAL, ease(luck_factor, 0.8))
	var common_chance := lerpf(COMMON_INITIAL, COMMON_FINAL, ease(luck_factor, 0.4))
	
	# Normalize values to keep between 0 and 1
	var total_chance = legendary_chance + epic_chance + rare_chance + uncommon_chance + common_chance
	if total_chance > 0:
		legendary_chance /= total_chance
		epic_chance /= total_chance
		rare_chance /= total_chance
		uncommon_chance /= total_chance
		common_chance /= total_chance
	else:
		print("ERROR: Sum of augment chances is not a positive float.")
	
	return {
		AugmentEssentials.Rarity.LEGENDARY: legendary_chance,
		AugmentEssentials.Rarity.EPIC: epic_chance,
		AugmentEssentials.Rarity.RARE: rare_chance,
		AugmentEssentials.Rarity.UNCOMMON: uncommon_chance,
		AugmentEssentials.Rarity.COMMON: common_chance
	}


func _getAugmentOfRarity(rarity: AugmentEssentials.Rarity) -> Augment:
	var rand_aug = func(array: Array[Augment]): return array[Globals.rng.randi_range(0, array.size() - 1)]
	
	match rarity:
		AugmentEssentials.Rarity.LEGENDARY:
			return rand_aug.call(legendary_augments)
		AugmentEssentials.Rarity.EPIC:
			return rand_aug.call(epic_augments)
		AugmentEssentials.Rarity.RARE:
			return rand_aug.call(rare_augments)
		AugmentEssentials.Rarity.UNCOMMON:
			return rand_aug.call(uncommon_augments)
		AugmentEssentials.Rarity.COMMON:
			return rand_aug.call(common_augments)
	
	return null
