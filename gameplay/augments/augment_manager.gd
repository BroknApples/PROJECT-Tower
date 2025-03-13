extends Node
##
## Handles how augments are processed and applied
##


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
	await get_tree().create_timer(3).timeout # Wait for 3 seconds
	rollAugments(Player.new())

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
		
		var full_path = directory_path + "/" + file
		
		# Check which rarities of the augment exist
		var augment = load(full_path)
		var instance = augment.instantiate() # Temporarily instantiate this augment
		
		all_augments.push_back(augment) 			# All Augments
		if (instance.setEvolution()): 				# Evolution augments
			evolution_augments.push_back(augment)
		if (instance.setLegendary()): 				# Legendary augments
			legendary_augments.push_back(augment)
		if (instance.setEpic()): 					# Epic augments
			epic_augments.push_back(augment)
		if (instance.setRare()): 					# Rare augments
			rare_augments.push_back(augment)
		if (instance.setUncommon()): 				# Uncommon augments
			uncommon_augments.push_back(augment)
		if (instance.setCommon()): 					# Common augments
			common_augments.push_back(augment)
		instance.free() # Delete augment instance.free() # Delete augment instance
		
		file = dir.get_next()
	
	print("Augments initialized...")


## Roll 3 augments
## player: which player owns the luck stat and will be assigned the augment
func rollAugments(player: Player) -> void:
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
		
		# Instantiate a new augment of a certain rarity
		#augments[i] == _getAugmentOfRarity(rarity).instantiate()
		augments.push_back(Augment.new())
	
	print("printing augs:")
	for i in augments:
		print(i.augment_name)
	
	var aug_selection_screen = load("res://gameplay/augments/augment_selection_screen.tscn").instantiate()
	aug_selection_screen.initialize(player, augments)
	self.add_child(aug_selection_screen)


## Get the chances to roll any given augment rarity
func _getChances(luck: int) -> Dictionary:
	var luck_factor = clamp(luck / 100.0, 0, 3) # Keep between 0 and 3 for scaling
	
	
	# Scales harder with super high values
	var luck_modifier = 0.16
	if (luck >= 200):
		luck_modifier = 0.20
	elif (luck >= 100):
		luck_modifier = 0.24 
	
	var chances = _DEFAULT_CHANCES.duplicate()
	
	var evolution_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.EVOLUTION] + luck_factor * luck_modifier
	var legendary_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.LEGENDARY] + luck_factor * luck_modifier
	var epic_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.EPIC] + luck_factor * luck_modifier
	var rare_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.RARE] + luck_factor * (luck_modifier * 0.5)
	var uncommon_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.UNCOMMON] + luck_factor * (luck_modifier * 0.3)
	var common_chance = _DEFAULT_CHANCES[AugmentEssentials.Rarity.COMMON] - luck_factor * luck_modifier
	
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
	
	var arr: Array[Augment]
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
