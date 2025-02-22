extends Node

var credits
var level

var player_weapon
var tower


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower = load("res://game_objects/player/towers/tower_class.tscn").instantiate()
	add_child(tower)
	player_weapon = load("res://game_objects/player/weapons/player_weapon.tscn").instantiate()
	add_child(player_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
