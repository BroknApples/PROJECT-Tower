extends Node
##
## Player Class
## 
## Holds level, credits, and other essential data to the player
##
class_name Player


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
const _LEVEL_MAX = 8

## PlayerStats class holds stats for a player
## credits: Current credit count
## level: Current level
## xp: Current experience points
class PlayerStats:
	var credits: float
	var cubes: float
	var xp: int
	var level: int
	
	func _init(init_credits: float, init_cubes: float, init_level: int, init_xp: int) -> void:
		self.credits = init_credits
		self.cubes = init_cubes
		self.level = init_level
		self.xp = init_xp

@onready var towers = $"./Towers"
var core_tower = load("res://game_objects/player/tower.tscn").instantiate()
var player_weapon = preload("res://game_objects/player/player_weapons/player_weapon_class.tscn").instantiate()
var gui = preload("res://ui/player/player_gui.tscn").instantiate() ## PlayerGui Control Node

var stats: PlayerStats
var enemy_killed_queue: Array[Globals.Pair] ## Pair format: pair.first = Enemy, pair.second = what weapon killed the enemy

func _init() -> void:
	stats = PlayerStats.new(1000.0, 10.0, 5, 0)


func _ready() -> void:
	core_tower.initialize(towers.get_child_count(), Globals.TowerTags.CORE)
	towers.add_child(core_tower)
	add_child(player_weapon)
	add_child(gui)
	
	gui.setWorldNumber(120) # TESTING


func _process(delta: float) -> void:
	checkAndDoUpdates()


## Checks all child nodes for updates to hp, credits, etc.
func checkAndDoUpdates() -> void:
	processTowers()
	processEnemies()


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
	# TODO: Enemies must hold an xp value and gold value and cube value
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


# TODO: Apply credit % bonuses and Cube % bonuses to ||| addCredits() & addCubes() ||| once implemented

## Add credits to player and update UI
func addCredits(additional_credits: int) -> void:
	stats.credits += additional_credits
	gui.setCredits(stats.credits)

## Add cubes to player and update UI
func addCubes(additional_cubes: int) -> void:
	stats.cubes += additional_cubes
	gui.setCubes(stats.cubes)


## Add XP to player and check for level up
func addXp(additional_xp: int) -> void:
	stats.xp += additional_xp
	
	# Already at max level, so return
	if (stats.level == _LEVEL_MAX): return
	
	# Level Up
	if (stats.xp >= _LEVELUP_TARGET_XP[stats.level]):
		stats.xp -= _LEVELUP_TARGET_XP[stats.level]
		levelUp()


## Level up Player and apply bonuses
func levelUp() -> void:
	pass # TODO: Implement
