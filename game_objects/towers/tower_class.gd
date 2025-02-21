extends Node2D

class_name Tower

# Stats
var health: int
var hp_regen: float
var dmg_multiplier: float
var coin_multiplier: float

# Weapons -- TODO: How do i make this class be accessible from another file??
var weapons: Weapon

# Helper variables
var atk_timer = 0.0
	
# Initialize all values
func _init() -> void:
	# Stats
	health = 100
	hp_regen = 0.33
	dmg_multiplier = 1.0
	coin_multiplier = 1.0

	# Weapons
	weapons = []
	
	# Helper variables
	atk_timer = 0.0

func _process(delta: float):
	# Do attacks
	for w in weapons:
		w.increaseAtkTimer(delta)
