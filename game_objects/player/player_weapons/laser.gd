extends PlayerWeapon
##
## Laser
##
## Hitscan weapon that fires exactly where the mouse pointer is; no travel time.
##

const _WEAPON_NAME := "Laser"
const _CURSOR_SHAPE := preload("res://assets/textures/crosshair1.png")
var _MAIN_ATTACK_SFX := preload("res://assets/sounds/laser_shot.mp3")
@export var _base_damage := 10.0
@export var _base_attack_speed := 0.8
@export var _base_crit_chance := 0.05
@export var _base_crit_damage := 0.70
@export var _base_weapon_range := 3 ## Radius of the circle shape checking for collision


func _init() -> void:
	var test_stats = WeaponStats.new(_base_damage, _base_attack_speed, 
			_base_crit_chance, _base_crit_damage, _base_weapon_range)
	
	var weapon_audio = WeaponAudio.new(_MAIN_ATTACK_SFX)
	
	# TODO: Load from save file
	super._init(_CURSOR_SHAPE, _WEAPON_NAME, weapon_audio, test_stats)


func doAttack(attack_pos: Vector2) -> bool:
	var shape = CircleShape2D.new()
	shape.radius = stats.weapon_range
	var nodes = Globals.getPhysicsNodesInArea(attack_pos, shape)
	if (nodes.size() > 0):
		for node in nodes:
			if (node is RigidBody2D && node.get_parent().has_method("takeDamage")):
				node.get_parent().takeDamage(self, calculateDamage())
		
		return true
	
	return false
