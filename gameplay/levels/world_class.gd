extends Node2D
##
## WorldClass
##
## Parent class of all worlds, implements universal methods
##
class_name WorldClass

## Path to add the enemies to
@onready var enemies_node_path = get_tree().get_root().get_node("Game/Enemies")

## Name of the world
var world_name: String
var rng = RandomNumberGenerator.new()

## Chance for any type of enemy to spawn on any given frame
## This should increase as the playtime on a world increases
## Formula used to choose a spawn -> (spawn_rate / 10000)
var spawn_rate: int

## Each world will have it's own chances for each enemy spawn type -- can be modified through difficulty, playtime, etc.
var enemy_types_dict: Dictionary

## s_rate = spawn rate of the enemy ( chance for an enemy to spawn on any given frame)
## e_chances = Dictionary in format { Enemy scene path: float(spawn_chance) }
## TODO: Add a background texture path here
func _init(w_name: String, s_rate: int, enemies_dict: Dictionary) -> void:
	# Ensure the chances of enemies is within the range 0.0 to 1.0
	var total_spawn_chances = 0.0
	for e in enemies_dict:
		if enemies_dict[e] <= 0.0 || enemies_dict[e] > 1.0:
			couldNotInit(w_name)
		total_spawn_chances += enemies_dict[e]
		
	if (total_spawn_chances < 0.0 || total_spawn_chances > 1.0):
		couldNotInit(w_name)

	world_name = w_name
	enemy_types_dict = enemies_dict
	spawn_rate = s_rate


## Could not initialize world
func couldNotInit(world_name: String):
	# TODO: Make this display a splash screen error
	print("Fatal ERROR: Could not initialize world: '" + world_name + "'")
	# OS.delay_msec(1000) # Sleep for a second before quitting
	Globals.call_deferred("quitGame") # TODO: Change this to simply going back to the title screen


func _process(delta: float) -> void:
	getEnemySpawn()

func getEnemySpawn():
	var rand_int = rng.randi_range(0, 10000)
	
	if (rand_int < spawn_rate):
		var rand_float = rng.randf_range(0.0, 1.0)
		
		# calculate the ranges of each spawn
		var lower_bound = 0.0
		var upper_bound = 0.0
		for enemy_key in enemy_types_dict:
			upper_bound += enemy_types_dict[enemy_key]
			
			if (rand_float >= lower_bound && rand_float <= upper_bound):
				var new_enemy = load(enemy_key).instantiate()
				enemies_node_path.add_child(new_enemy)
				print("EnemyType '" + new_enemy.enemy_type + "' spawned at: " + str(new_enemy.global_position.x) + ", " + str(new_enemy.global_position.y))
				return
			
			lower_bound += enemy_types_dict[enemy_key]
