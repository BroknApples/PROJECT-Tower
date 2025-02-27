extends Node2D
##
## Weapon Class
##
## Used as a blueprint to create different weapons
##
class_name Weapon


## WeaponStats Class
## base_damage: Base attack damage of the weapon
## base_attack_speed: Base attack speed of the weapon
## base_crit_chance: Base critical strike chance
## base_crit_damage: Base critical strike damage percent
## base_weapon_range: Base value for how far can this weapon "see"
## damage: Current attack damage of the weapon
## attack_speed: Current attack speed of the weapon
## crit_chance: Current critical strike chance
## crit_damgage: Current critical strike damage percent
## weapon_range: Currently, how far can this weapon "see"
class WeaponStats:
	# Base stats
	var base_damage: float
	var base_attack_speed: float
	var base_crit_chance: float
	var base_crit_damage: float
	var base_weapon_range: int
	
	# Current stats
	var damage: float
	var attack_speed: float
	var crit_chance: float
	var crit_damage: float
	var weapon_range: int
	
	func _init(init_base_damage: float, init_base_attack_speed: float,
	init_base_crit_chance: float, init_base_crit_damage: float,
	init_base_weapon_range: int) -> void:
		self.base_damage = init_base_damage
		self.base_attack_speed = init_base_attack_speed
		self.base_crit_chance = init_base_crit_chance
		self.base_crit_damage = init_base_crit_damage
		self.base_weapon_range = init_base_weapon_range

# Member variables
var stats: WeaponStats

# Helper variables
var atk_timer: float


func _init(damage: int, attack_speed: float, crit_chance: float, crit_dmg: float, weapon_range: int) -> void:
	stats = WeaponStats.new(5, 1, 0.0, 0.5, 500)
	applyStatBonuses()
	
	# Helper variables
	atk_timer = 0.0


func _process(delta: float) -> void:
	increaseAtkTimer(delta)


## Increase attack timer and check for attacks
func increaseAtkTimer(time_passed: float) -> void:
	atk_timer += time_passed;
	
	if (atk_timer >= stats.attack_speed):
		atk_timer -= stats.attack_speed
		doAttack()


## Add stat bonuses based on upgrades
func applyStatBonuses() -> void:
	pass # TODO: Implement


## Do an attack
func doAttack() -> void:
	# TODO: Add upgrades
	# var modifiers = get_parent().getModifiers()
	pass # do the attack
