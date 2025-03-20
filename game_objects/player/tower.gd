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
	var tower_ref: Tower
	
	# Base stats
	var base_max_hp: float
	var base_armor: float
	var base_hp_regen: float
	
	# Current stats
	var max_hp: float
	var curr_hp: float
	var armor: float ## DMG Reduction uses the formula from League of Legends: DMG Taken = ATK * 100 / (100 + Armor)
	var hp_regen: float
	
	##
	## Upgrade Stats
	## Percents are treated as if they are not yet divided by 100
	## 100% will be divided by 100 to become 1.0
	##
	
	# Base
	var bonus_base_max_hp: float
	var bonus_base_max_hp_percent: float
	var bonus_base_armor: float
	var bonus_base_armor_percent: float
	var bonus_base_hp_regen: float
	var bonus_base_hp_regen_percent: float
	# Current
	var bonus_max_hp: float
	var bonus_max_hp_percent: float
	var bonus_armor: float
	var bonus_armor_percent: float
	var bonus_hp_regen: float
	var bonus_hp_regen_percent: float
	
	func _init(init_tower_ref: Tower, init_base_max_hp: float, init_base_armor: float,
			   init_base_hp_regen: float, init_curr_hp: float) -> void:
		self.tower_ref = init_tower_ref
		self.base_max_hp = init_base_max_hp
		self.base_armor = init_base_armor
		self.base_hp_regen = init_base_hp_regen
		self.curr_hp = init_curr_hp
	
	
	func calculateMainStats() -> void:
		self.base_max_hp += self.bonus_base_max_hp
		self.base_max_hp += self.base_max_hp * self.bonus_base_max_hp_percent/100
		
		self.base_armor += self.bonus_base_armor
		self.base_armor += self.base_armor * self.bonus_base_armor_percent/100
		
		self.base_hp_regen += self.bonus_base_hp_regen
		self.base_hp_regen += self.base_hp_regen * self.bonus_base_hp_regen_percent/100
		
		self.max_hp += self.bonus_max_hp
		self.max_hp += self.max_hp * self.bonus_max_hp_percent/100
		
		self.armor += self.bonus_armor
		self.armor += self.curr_hp * self.bonus_armor_percent/100
		
		self.hp_regen += self.bonus_hp_regen
		self.hp_regen += self.hp_regen * self.bonus_hp_regen_percent/100


var parent: Player
var tower_id: int
var tower_tag: Globals.TowerTags
var stats: TowerStats
var weapons: Array[WeaponClass] # Array of Weapon classes


## Initialize all values
## init_tower_id = Unique identifier for this tower
## init_tower_tag = What type of tower is it?
func initialize(init_tower_id: int, init_tower_tag: Globals.TowerTags) -> void:
	# TODO: Apply bonuses to stats through upgrades
	
	# General vars
	tower_id = init_tower_id
	tower_tag = init_tower_tag
	
	# Stats
	# TODO: LOad from save file
	stats = TowerStats.new(self, 100, 100, 0.02, 100)
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


# TODO: Move to stats class
## Set stat bonuses based on upgrades
func setStatBonuses() -> void:
	## TESTING
	stats.max_hp = 100.0
	stats.armor = 10.0
	stats.hp_regen = 0.2
	## TESTING


## Tower Has collided with an enemy's attack, reduce current HP
## attacker: Who did the tower collide with
func takeDamageFromEnemy(attacker: Enemy):
	print("Tower with id: " + str(tower_id) + " took damage from EnemyType: '" + attacker.enemy_type + "'")
	stats.curr_hp -= (attacker.stats.damage * 100 / (100 + stats.armor))
	if (parent.has_method("takeDamage")):
		parent.takeDamage(tower_id)
	
	# Recalculate stats just in case
	stats.calculateMainStats()


## Return the player that owns this tower
func getParentPlayer() -> Player:
	return parent



#
#
#
# Set Bonus Stats
#
#
#

## Set bonus base max hp of a tower using a FLAT VALUE
func addBonusBaseHp(bonus_hp: float) -> void:
	print("Added Bonus Base HP: '" + str(bonus_hp) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_max_hp += bonus_hp
	stats.calculateMainStats()


## Set bonus base max hp of a tower using a PERCENTAGE
func addBonusBaseHpPercent(bonus_hp: float) -> void:
	print("Added Bonus Base HP Percent: '" + str(bonus_hp) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_max_hp_percent += bonus_hp
	stats.calculateMainStats()


## Set bonus base armor of a tower using a FLAT VALUE
func addBonusBaseArmor(bonus_armor: float) -> void:
	print("Added Bonus Base Armor: '" + str(bonus_armor) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_armor += bonus_armor
	stats.calculateMainStats()


## Set bonus base armor of a tower using a PERCENTAGE
func addBonusBaseArmorPercent(bonus_armor: float) -> void:
	print("Added Bonus Base Armor Percent: '" + str(bonus_armor) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_armor_percent += bonus_armor
	stats.calculateMainStats()


## Set bonus base hp regen of a tower using a FLAT VALUE
func addBonusBaseHpRegen(bonus_hp_regen: float) -> void:
	print("Added Bonus Base HP Regen: '" + str(bonus_hp_regen) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_hp_regen += bonus_hp_regen
	stats.calculateMainStats()


## Set bonus base hp regen of a tower using a PERCENTAGE
func addBonusBaseHpRegenPercent(bonus_hp_regen: float) -> void:
	print("Added Bonus Base HP Regen Percent: '" + str(bonus_hp_regen) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_base_hp_regen_percent += bonus_hp_regen
	stats.calculateMainStats()


## Set bonus hp of a tower using a FLAT VALUE
func addBonusMaxHp(bonus_max_hp: float) -> void:
	print("Added Bonus Max HP Regen: '" + str(bonus_max_hp) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_max_hp += bonus_max_hp
	stats.calculateMainStats()


## Set bonus hp of a tower using a PERCENTAGE
func addBonusMaxHpPercent(bonus_max_hp: float) -> void:
	print("Added Bonus Max HP Percent: '" + str(bonus_max_hp) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_max_hp_percent += bonus_max_hp
	stats.calculateMainStats()


## Set bonus armor of a tower using a FLAT VALUE
func addBonusArmor(bonus_armor: float) -> void:
	print("Added Bonus Armor: '" + str(bonus_armor) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_armor += bonus_armor
	stats.calculateMainStats()


## Set bonus armor of a tower using a PERCENTAGE
func addBonusArmorPercent(bonus_armor: float) -> void:
	print("Added Bonus Armor Percent: '" + str(bonus_armor) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_armor_percent += bonus_armor
	stats.calculateMainStats()


## Set bonus hp regen of a tower using a FLAT VALUE
func addBonusHpRegen(bonus_hp_regen: float) -> void:
	print("Added Bonus HP Regen: '" + str(bonus_hp_regen) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_hp_regen += bonus_hp_regen
	stats.calculateMainStats()


## Set bonus hp regen of a tower using a PERCENTAGE
func addBonusHpRegenPercent(bonus_hp_regen: float) -> void:
	print("Added Bonus HP Regen Percent: '" + str(bonus_hp_regen) + "' to tower with id: '" + str(stats.tower_ref.tower_id) + "'")
	stats.bonus_hp_regen_percent += bonus_hp_regen
	stats.calculateMainStats()
