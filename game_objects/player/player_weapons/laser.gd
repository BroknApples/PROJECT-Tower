extends PlayerWeapon
##
## Laser
##
## Hitscan weapon that fires exactly where the mouse pointer is; no travel time.
##

# TESTING
const _WEAPON_NAME := "Laser"
const _CURSOR_SHAPE := preload("res://assets/textures/crosshair1.png")
var _MAIN_ATTACK_SFX := preload("res://assets/sounds/laser_shot.mp3")
# TESTING

func _init() -> void:
	# TESTING
	var test_stats = WeaponStats.new(10, 1.0, 0.04, 25, 25)
	# TESTING
	
	var weapon_audio = WeaponAudio.new(_MAIN_ATTACK_SFX)
	
	# TODO: Load from save file
	super._init(_CURSOR_SHAPE, _WEAPON_NAME, weapon_audio, test_stats)
	stats.setMainStats(10, 20.0, 0.05, 25, 25)


func doAttack(attack_pos: Vector2):
	var node = Globals.getPhysicsNodeAtPosition(attack_pos)
	if (node is RigidBody2D && node.get_parent().has_method("takeDamage")):
		node.get_parent().takeDamage(self, calculateDamage())
