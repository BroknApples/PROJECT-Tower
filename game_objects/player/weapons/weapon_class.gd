extends Node2D

class_name Weapon

# Stats
var damage_: float
var attack_speed_: float
var crit_chance_: float
var crit_dmg_: float
var weapon_range_: int

# Helper variables
var atk_timer_: float

func _init(damage: int, attack_speed: float, crit_chance: float, crit_dmg: float, weapon_range: int) -> void:
	damage_ = damage
	attack_speed_ = attack_speed
	crit_chance_ = crit_chance
	crit_dmg_ = crit_dmg
	weapon_range_ = weapon_range
	
	# Helper variables
	atk_timer_ = 0.0

func increaseAtkTimer(time_passed: float) -> void:
	atk_timer_ += time_passed;
	
	if (atk_timer_ >= attack_speed_):
		atk_timer_ -= attack_speed_
		doAttack()

func doAttack() -> void:
	# TODO: Add upgrades
	# var modifiers = get_parent().getModifiers()
	pass # do the attack
