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

var parent: Player
var tower_id: int
var tower_tag: Globals.TowerTags
var stats: TowerStats
var weapons: Array[Weapon] # Array of Weapon classes


## Initialize all values
## init_tower_id = Unique identifier for this tower
## init_tower_tag = What type of tower is it?
func initialize(init_tower_id: int, init_tower_tag: Globals.TowerTags) -> void:
	# TODO: Apply bonuses to stats through upgrades
	
	# General vars
	tower_id = init_tower_id
	tower_tag = init_tower_tag
	
	# Stats
	stats = TowerStats.new(100, 100, 0.02, 100)
	setStatBonuses()
	
	# Weapons
	weapons = []

func _ready() -> void:
	parent = get_parent().get_parent()
	
	# Set position on screen
	position = get_viewport().get_visible_rect().size / 2.0


func _process(delta: float):
	# Regenerate HP
	stats.curr_hp = clamp((stats.curr_hp + stats.hp_regen * delta), 0.0, stats.max_hp)
	
	# Do Attacks
	for weapon in weapons:
		weapon.increaseAtkTimer(delta)


## Set stat bonuses based on upgrades
func setStatBonuses() -> void:
	## TESTING
	stats.max_hp = 100.0
	stats.armor = 10.0
	stats.hp_regen = 0.2
	## TESTING


## Tower Has collided with an enemy's attack, reduce current HP
func takeDamage(attacker: Enemy):
	print("Tower with id: " + str(tower_id) + " took damage from EnemyType: '" + attacker.enemy_type + "'")
	stats.curr_hp -= (attacker.stats.damage * 100 / (100 + stats.armor))
	if (parent.has_method("takeDamage")):
		parent.takeDamage(tower_id)


## Return the player that owns this tower
func getParentPlayer() -> Player:
	return parent
