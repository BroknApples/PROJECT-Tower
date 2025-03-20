extends Node
##
## Player Class
## 
## Holds level, credits, and other essential data to the player
##
class_name Player


## semi_paused: Don't stop gameplay, but do stop gameplay helpers(mouse pointer type, etc.)
var semi_paused: bool

## Target xp required for a level up, per level
const _LEVELUP_TARGET_XP = {
	1: 100,
	2: 150,
	3: 250,
	4: 450,
	5: 700,
	6: 950,
	7: 1275
}
const _LEVEL_MAX = 7

## PlayerStats class holds stats for a player
## credits: Current credit count
## level: Current level
## xp: Current experience points
class PlayerStats:
	# Normal stats
	var credits: float
	var cubes: float
	var luck: int
	var xp: float
	var level: int
	
	# Bonus stats
	var bonus_credit_percent: float
	var bonus_cube_percent: float
	var bonus_xp_percent: float
	
	func _init(init_credits: float, init_cubes: float, init_luck: int, init_xp: int, init_level: int) -> void:
		self.credits = init_credits
		self.cubes = init_cubes
		self.luck = init_luck
		self.xp = init_xp
		self.level = init_level

var AugmentEssentials = load("res://gameplay/augments/augment_essentials.gd") ## Essential functions for augments to work
@onready var towers = $"./Towers"
@onready var augment_manager = get_tree().get_root().get_node("Game/CanvasLayer/AugmentManager")
var core_tower = load("res://game_objects/player/tower.tscn").instantiate()
var player_weapon = preload("res://game_objects/player/player_weapons/laser.tscn").instantiate() # TESTING
var gui = preload("res://ui/player/player_gui.tscn").instantiate() ## PlayerGui Control Node
var credits_audio_path = preload("res://assets/sounds/coin.mp3")
var cubes_audio_path = preload("res://assets/sounds/block_drop.mp3")

var stats: PlayerStats
var augments: Array[Augment]
var enemy_killed_queue: Array[Globals.Pair] ## Pair format: pair.first = Enemy, pair.second = what weapon killed the enemy
const _CREDITS_AUDIO_STREAM := "Credits"
const _CUBES_AUDIO_STREAM := "Cubes"

# Specifically set to player_weapons
var current_weapon: WeaponClass
var previous_weapon: WeaponClass



func _init() -> void:
	# TODO: Load player stats from save file
	stats = PlayerStats.new(0, 0, 25, 0, 1)
	semi_paused = false


func _ready() -> void:
	core_tower.initialize(towers.get_child_count(), Globals.TowerTags.CORE)
	towers.add_child(core_tower)
	add_child(player_weapon)
	player_weapon.setOwner(self)
	add_child(gui)
	
	# Setup AudioStreams
	AudioManager.addStream(_CREDITS_AUDIO_STREAM, AudioManager.AudioType.CURRENCY)
	AudioManager.setStreamAudio(_CREDITS_AUDIO_STREAM, credits_audio_path)
	AudioManager.addStream(_CUBES_AUDIO_STREAM, AudioManager.AudioType.CURRENCY)
	AudioManager.setStreamAudio(_CUBES_AUDIO_STREAM, cubes_audio_path)
	
	gui.setWorldNumber(120) # TESTING
	augment_manager.rollAugments(self)


func _process(delta: float) -> void:
	processTowers()
	processEnemies()


func setSemiPausedState(state: bool) -> void:
	if (semi_paused == state): return # No point in changing anything if it is already the desired state
	
	semi_paused = state
	if (semi_paused):
		if (!player_weapon.attack_pos_locked):
			player_weapon.lockAttackPosition()
	else:
		if (player_weapon.lockAttackPosition()):
			player_weapon.lockAttackPosition()

## Process tower updates
func processTowers() -> void:
	for tower in towers.get_children():
		# Check for death
		if (tower.stats.curr_hp <= 0.0):
			print("Tower with id: " + str(tower.tower_id) + " died.") # TODO: Update to actual death stuff
			continue
		# Update HP Bars
		if (tower.tower_tag == Globals.TowerTags.CORE):
			gui.setCurrHp(tower.stats.curr_hp) # TODO: Update this function once the multi-tower system is implemented
	
	## Helper Lambda Function
	## Find a tower with a given tower_id
	## tower_id: unique id of the target tower
	var find_tower_id = func(target_id: int) -> Tower:
		for tower in towers.get_children():
			if tower.tower_id == target_id:
				return tower
		
		return null


## Process the enemies that have been killed by this player's weapons
## Add credits, cubes, and xp for killing an enemy
## enemy: Target enemies
func processEnemies() -> void:
	while (!enemy_killed_queue.is_empty()):
		var pair = enemy_killed_queue.pop_front()
		var enemy = pair.first
		var killer = pair.second
		
		addCredits(enemy.stats.credit_value)
		addCubes(enemy.stats.cube_value)
		addXp(enemy.stats.xp_value)
		# TODO: Update the number of enemies killed for the weapon
		
		enemy.queue_free()


## Add enemy to enemy_killed_queue
## enemy: what enemy has died
## killer: What weapon killed the enemy
func addEnemyKilled(enemy: Enemy, killer) -> void:
	enemy_killed_queue.push_back(Globals.Pair.new(enemy, killer))


## Add credits to player and update UI
func addCredits(additional_credits: int, play_sound := true) -> void:
	if (additional_credits == 0): return
	
	if (play_sound): AudioManager.playStream(_CREDITS_AUDIO_STREAM)
	stats.credits += additional_credits + (additional_credits * stats.bonus_credit_percent/100)
	gui.setCredits(stats.credits)


## Set variable that modifies the amount of credits earned per kill
func addCreditPercent(additional_credit_percent: float) -> void:
	if (additional_credit_percent == 0.0): return
	stats.bonus_credit_percent += additional_credit_percent


## Add cubes to player and update UI
func addCubes(additional_cubes: int, play_sound := true) -> void:
	if (additional_cubes == 0.0): return
	
	if (play_sound): AudioManager.playStream(_CUBES_AUDIO_STREAM)
	stats.cubes += additional_cubes + (additional_cubes * stats.bonus_cube_percent/100)
	gui.setCubes(stats.cubes)


## Set variable that modifies the amount of cubes earned per kill
func addCubePercent(additional_cube_percent: float) -> void:
	if (additional_cube_percent == 0.0): return
	stats.bonus_cube_percent += additional_cube_percent


## Add luck value to player stats -> modifies the percent chances for each augment tier
func addLuck(additional_luck: int) -> void:
	if (additional_luck == 0): return
	stats.luck += additional_luck


## Add XP to player and check for level up
func addXp(additional_xp: int) -> void:
	# Level is already max, so don't waste any time
	if (stats.level == _LEVEL_MAX): return
	
	stats.xp += additional_xp + (additional_xp * stats.bonus_xp_percent/100)
	
	# Level Up
	if (stats.xp >= _LEVELUP_TARGET_XP[stats.level]):
		stats.xp -= _LEVELUP_TARGET_XP[stats.level]
		levelUp()
	
	# Set GUI
	if (stats.level == _LEVEL_MAX):
		gui.setXp(0)
	else:
		gui.setXp(stats.xp)


## Set variable that modifies the amount of xp earned per kill
func addXpPercent(additional_xp_percent: float) -> void:
	if (additional_xp_percent == 0.0): return
	stats.bonus_xp_percent += additional_xp_percent


## Level up Player and apply bonuses
func levelUp() -> void:
	#stats.level += 1 TESTING: Do add a level when not testing augments
	augment_manager.rollAugments(self)
	gui.setXpMax(_LEVELUP_TARGET_XP[stats.level])


## Add new augment and apply the new augment
func addAugment(new_augment: Augment) -> void:
	# Add augment
	augments.push_back(new_augment)
	print("Displaying augments for player:")
	for augment in augments:
		print(augment.augment_name)
	
	# Now apply the augment
	for pair in new_augment.stats:
		var stat_type = pair.first
		var value = pair.second
		match(stat_type): # Match StatType
			AugmentEssentials.StatType.PLAYER_CREDITS:
				addCredits(value, false)
			AugmentEssentials.StatType.PLAYER_CREDITS_PERCENT:
				addCreditPercent(value)
			AugmentEssentials.StatType.PLAYER_CUBES:
				addCubes(value, false)
			AugmentEssentials.StatType.PLAYER_CUBES_PERCENT:
				addCubePercent(value)
			AugmentEssentials.StatType.PLAYER_LUCK:	
				addLuck(value)
			AugmentEssentials.StatType.PLAYER_XP_PERCENT:
				addXpPercent(value)
			AugmentEssentials.StatType.PLAYER_LEVEL:
				for i in range(0, value): levelUp()
			AugmentEssentials.StatType.TOWER_BASE_MAX_HP:
				core_tower.addBonusBaseMaxHp(value)
			AugmentEssentials.StatType.TOWER_BASE_MAX_HP_PERCENT:
				core_tower.addBonusBaseMaxHpPercent(value)
			AugmentEssentials.StatType.TOWER_BASE_ARMOR:
				core_tower.addBonusBaseArmor(value) 
			AugmentEssentials.StatType.TOWER_BASE_ARMOR_PERCENT:
				core_tower.addBonusBaseArmorPercent(value) 
			AugmentEssentials.StatType.TOWER_BASE_HP_REGEN:
				core_tower.addBonusBaseHpRegen(value)
			AugmentEssentials.StatType.TOWER_BASE_HP_REGEN_PERCENT:
				core_tower.addBonusBaseHpRegenPercent(value)
			AugmentEssentials.StatType.TOWER_MAX_HP:
				core_tower.addBonusMaxHp(value)
			AugmentEssentials.StatType.TOWER_MAX_HP_PERCENT:
				core_tower.addBonusMaxHpPercent(value)
			AugmentEssentials.StatType.TOWER_ARMOR:
				core_tower.addBonusArmor(value)
			AugmentEssentials.StatType.TOWER_ARMOR_PERCENT:
				core_tower.addBonusArmorPercent(value)
			AugmentEssentials.StatType.TOWER_HP_REGEN:
				core_tower.addBonusHpRegen(value) 
			AugmentEssentials.StatType.TOWER_HP_REGEN_PERCENT:
				core_tower.addBonusHpRegenPercent(value)
