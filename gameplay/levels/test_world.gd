extends WorldClass

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	# Initialize super class
	var enemy_type_and_spawn_chance = {
		"res://game_objects/enemies/Square/square.tscn": 1.0,
	}
	var s_rate = 10

	super._init(s_rate, enemy_type_and_spawn_chance)
