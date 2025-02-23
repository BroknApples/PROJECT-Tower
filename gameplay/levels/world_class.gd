extends Node2D

class_name WorldClass

## Path to add the enemies to
@onready var enemy_path = get_tree().get_root().get_node("Game/Enemies")

## Enemy Spawner
var enemy_spawn_rng = RandomNumberGenerator.new()

## Chance for any type of enemy to spawn on any given frame
## This should increase as the playtime on a world increases
## Formula used to choose a spawn -> (spawn_rate / 10000)
var spawn_rate: int

# Each world will have it's own chances for each enemy spawn type -- can be modified through difficulty, playtime, etc.
var enemies: Dictionary

## s_rate = spawn rate of the enemy ( chance for an enemy to spawn on any given frame)
## e_chances = Dictionary in format { Enemy scene path: float(spawn_chance) }
## TODO: Add a background texture path here
func _init(s_rate: int, enemies_dict: Dictionary) -> void:
	enemies = enemies_dict
	spawn_rate = s_rate

func _process(delta: float) -> void:
	getEnemySpawn()

func getEnemySpawn():
	var rand_int = enemy_spawn_rng.randi_range(0, 10000)
	
	if (rand_int < spawn_rate):
		var rand_float = enemy_spawn_rng.randf_range(0, 1.0)
		
		# calculate the ranges of each spawn
		enemy_path.add_child(load("res://game_objects/enemies/Square/square.tscn").instantiate())
