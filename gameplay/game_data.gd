extends Node
##
##
## Holds the data for a game state save file.
##
##
##

class_name GameData

var game_loaded: bool # variable that checks if the game data has been loaded yet

@onready var player_list = $Players
var player_type

@onready var enemy_list = $Enemies
var current_world

const _SAVE_DIRECTORY = "user://game_saves/"
var save_id = 0 # If save_id == 0, then a save file has not been loaded

func _ready() -> void:
	if (loadSaveData()):
		game_loaded = true
	else:
		game_loaded = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func loadSaveData() -> bool:
	if (save_id == 0): return false
	
	# TODO: load from save file, not from preset variables
	
	current_world = load("res://gameplay/levels/TestWorld.tscn").instantiate()
	add_child(current_world)
	
	player_type = load("res://game_objects/player/player.tscn").instantiate()
	player_list.add_child(player_type)
	
	return true
	
func saveData() -> void:
	pass
