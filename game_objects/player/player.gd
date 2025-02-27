extends Node
##
## Player Class
## 
## Holds level, credits, and other essential data to the player
##
class_name Player


## Target xp required for a level up, per level
const _LEVELUP_TARGET_XP = {
	1: 100.0,
	2: 150.0,
	3: 400.0,
}


## PlayerStats class holds stats for a player
## credits: Current credit count
## level: Current level
## xp: Current experience points
class PlayerStats:
	var credits: int
	var level: int
	var xp: float
	
	func _init(init_credits: int, init_level: int, init_xp: float) -> void:
		self.credits = init_credits
		self.level = init_level
		self.xp = init_xp

var stats: PlayerStats
var tower: Tower
var player_weapon


func _init() -> void:
	stats = PlayerStats.new(1000, 1, 1.0)


func _ready() -> void:
	tower = load("res://game_objects/player/tower.tscn").instantiate()
	add_child(tower)
	player_weapon = load("res://game_objects/player/weapons/player_weapon.tscn").instantiate()
	add_child(player_weapon)


func _process(delta: float) -> void:
	pass


## Add XP to player and check for level up
func addXP(xp: float) -> void:
	stats.current_xp += xp
	
	# Level Up
	if (stats.current_xp >= _LEVELUP_TARGET_XP[stats.level]):
		stats.current_xp -= _LEVELUP_TARGET_XP[stats.level]
		levelUp()


## Level up Player and apply bonuses
func levelUp() -> void:
	pass # TODO: Implement
