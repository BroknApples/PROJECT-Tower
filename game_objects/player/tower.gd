extends Node2D
##
## Tower Class
##
## Must have a parent 'Player' Node to function
##
class_name Tower


## TowerStats Class:
## base_max_hp: Base maximum health of tower
## max_hp: Current maximum health of tower
## curr_hp: Current health of the tower
## base_armor: Base armor value
## armor: Current armor value
## base_hp_regen: Base HP regenerated in 1 second
## hp_regen: HP regnerated in 1 second
class TowerStats:
	# Base stats
	var base_max_hp: float
	var base_armor: float
	var base_hp_regen: float
	
	# Current stats
	var max_hp: float
	var curr_hp: float
	var armor: float ## DMG Reduction uses the formula from League of Legends: DMG Taken = ATK * 100 / (100 + Armor)
	var hp_regen: float
	
	func _init(init_base_max_hp: float, init_base_armor: float,
	init_base_hp_regen: float, init_curr_hp: float) -> void:
		self.base_max_hp = init_base_max_hp
		self.base_armor = init_base_armor
		self.base_hp_regen = init_base_hp_regen
		self.curr_hp = init_curr_hp

var stats: TowerStats
var weapons: Array[Weapon] # Array of Weapon classes


func _init() -> void:
	# TODO: Apply bonuses to stats through upgrades
	# Stats
	stats = TowerStats.new(100, 100, 10, 0.33)
	setStatBonuses()
	
	# Weapons
	weapons = []


func _ready() -> void:
	# Set position on screen
	position = get_viewport().get_visible_rect().size / 2.0


func _process(delta: float):
	# Regenerate HP
	stats.hp += clamp((stats.hp_regen * delta), 0.0, stats.max_hp)
	
	# Do Attacks
	for weapon in weapons:
		weapon.increaseAtkTimer(delta)


## Set stat bonuses based on upgrades
func setStatBonuses() -> void:
	stats.max_hp = 100
	stats.armor = 10
	stats.hp_regen = 100


## Tower Has collided with an enemy's attack, reduce current HP
func takeDamage(attacker: Enemy):
	print("I took damage from EnemyType: '" + attacker.enemy_type + "'")
	stats.curr_hp -= (attacker.stats.damage * 100 / (100 + stats.armor))
