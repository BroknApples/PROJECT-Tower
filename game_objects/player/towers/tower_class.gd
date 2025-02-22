extends Node2D

class_name Tower

# Stats
var health: int
var hp_regen: float
var dmg_multiplier: float
var coin_multiplier: float

# Weapons & Upgrades
var weapons: Array[Weapon] # Array of Weapon classes

# Helper variables
var atk_timer = 0.0
	
## Initialize all values
func _ready() -> void:
	# Set position on screen
	position = get_viewport().get_visible_rect().size / 2.0
	
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
	for weapon in weapons:
		weapon.increaseAtkTimer(delta)

# TODO: Add upgrades
# func getUpgrades() -> Array[Upgrade]:
# 	return upgrades
