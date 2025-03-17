extends Node
##
## GameData
##
## Holds the data for the game to work
## Used to create/load save files
##


@onready var player_list = $Players
var player

@onready var enemy_list = $Enemies
var current_world

@onready var augment_manager = $CanvasLayer/AugmentManager

const _SAVE_DIRECTORY = "user://game_saves/"
var save_id = 0 # If save_id == 0, then a save file has not been loaded
var game_loaded: bool ## Has the game loaded yet


func _ready() -> void:
	if (loadSaveData()):
		game_loaded = true
	else:
		game_loaded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Load data from save file
func loadSaveData() -> bool:
	if (save_id == 0): return false
	
	# TODO: load from save file, not from preset variables
	
	current_world = load("res://gameplay/levels/test_world.tscn").instantiate()
	add_child(current_world)
	
	player = load("res://game_objects/player/player.tscn").instantiate()
	player_list.add_child(player)
	
	return true


## Save current game data to a file
func saveData() -> void:
	pass
