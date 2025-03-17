extends Node
##
## Handles how augments are processed and applied
##


var aug_queue: Array ## If there is already an augment selection screen, add the new one to a queue
const AugmentEssentials = preload("res://gameplay/augments/augment_essentials.gd")

## Default chance to roll a given rarity
const _DEFAULT_CHANCES = {
	AugmentEssentials.Rarity.EVOLUTION: 0.02, # More common than a legendary, but it takes way more effort to make it a legendary-valued augment
	AugmentEssentials.Rarity.LEGENDARY: 0.01,
	AugmentEssentials.Rarity.EPIC: 0.05,
	AugmentEssentials.Rarity.RARE: 0.12,
	AugmentEssentials.Rarity.UNCOMMON: 0.20,
	AugmentEssentials.Rarity.COMMON: 0.60
}

## Augment Lists
var all_augments: Array[Augment]
var evolution_augments: Array[Augment]
var legendary_augments: Array[Augment]
var epic_augments: Array[Augment]
var rare_augments: Array[Augment]
var uncommon_augments: Array[Augment]
var common_augments: Array[Augment]


func _ready() -> void:
	_setupAugmentLists("res://gameplay/augments/augment_list/")
	# TESTING
	#var chances2 = []
	#chances2.push_back(_getChances(25))
	#chances2.push_back(_getChances(50))
	#chances2.push_back(_getChances(100))
	#chances2.push_back(_getChances(150))
	#chances2.push_back(_getChances(200))
	#chances2.push_back(_getChances(250))
	#chances2.push_back(_getChances(300))
	#
	#print("TESTCHANCES NEW ENTIRE BATCH")
	#for a in chances2:
		#print("TESTCHANCES\n")
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
		if (instance.setEvolutionRarity()): 				# Evolution augments
			var rarity_aug = instance.duplicate()
			rarity_aug.setEvolutionRarity()
			evolution_augments.push_back(rarity_aug)
		
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
	# TODO: Fix luck based rarities
	#const EVOLUTION_SCALER = 
	#const LEGENDARY_SCALER = 
	#const EPIC_SCALER = 
	#const RARE_SCALER = 
	#const UNCOMMON_SCALER =
	#const COMMON_SCALER =
	
	clamp(luck, 0, 300) # Max luck is 300
	
	var chances = _DEFAULT_CHANCES.duplicate()
	
	var evolution_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.EVOLUTION]
	var legendary_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.LEGENDARY]
	var epic_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.EPIC]
	var rare_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.RARE]
	var uncommon_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.UNCOMMON]
	var common_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.COMMON]
	
	# Normalize values to keep between 0 and 1
	var total_chance = evolution_chance + legendary_chance + epic_chance + rare_chance + uncommon_chance + common_chance
	evolution_chance /= total_chance
	legendary_chance /= total_chance
	epic_chance /= total_chance
	rare_chance /= total_chance
	uncommon_chance /= total_chance
	common_chance /= total_chance
	
	# Set values
	chances[AugmentEssentials.Rarity.EVOLUTION] = evolution_chance
	chances[AugmentEssentials.Rarity.LEGENDARY] = legendary_chance
	chances[AugmentEssentials.Rarity.EPIC] = epic_chance
	chances[AugmentEssentials.Rarity.RARE] = rare_chance
	chances[AugmentEssentials.Rarity.UNCOMMON] = uncommon_chance
	chances[AugmentEssentials.Rarity.COMMON] = common_chance
	
	return chances


func _getAugmentOfRarity(rarity: AugmentEssentials.Rarity) -> Augment:
	var rand_aug = func(array: Array[Augment]): return array[Globals.rng.randi_range(0, array.size() - 1)]
	
	match rarity:
		AugmentEssentials.Rarity.EVOLUTION:
			return rand_aug.call(evolution_augments)
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
