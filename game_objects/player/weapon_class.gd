extends Node2D
##
## Weapon Class
##
## Used as a blueprint to create different weapons
## Parent of both player_weapons and tower_weapons
##
class_name WeaponClass


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
	var attack_speed: float ## Attacks per second
	var crit_chance: float
	var crit_damage: float
	var weapon_range: int
	
	func _init(init_base_damage: float, init_base_attack_speed: float,
			   init_base_crit_chance: float, init_base_crit_damage: float,
			   init_base_weapon_range: int) -> void:
		setBaseStats(init_base_damage, init_base_attack_speed, init_base_crit_chance, init_base_crit_damage, init_base_weapon_range)
		setMainStats(init_base_damage, init_base_attack_speed, init_base_crit_chance, init_base_crit_damage, init_base_weapon_range)
	
	
	## Set base stats of weapon
	func setBaseStats(new_base_damage: float, new_base_attack_speed: float,
					  new_base_crit_chance: float, new_base_crit_damage: float,
					  new_base_weapon_range: int) -> void:
		self.base_damage = new_base_damage
		self.base_attack_speed = new_base_attack_speed
		self.base_crit_chance = new_base_crit_chance
		self.base_crit_damage = new_base_crit_damage
		self.base_weapon_range = new_base_weapon_range
	
	
	## Set main stats of weapon(damage, range, etc.)
	func setMainStats(new_damage: float, new_attack_speed: float, new_crit_chance: float,
					  new_crit_damage: float, new_weapon_range: float) -> void:
		self.damage = new_damage
		self.attack_speed = new_attack_speed
		self.crit_chance = new_crit_chance
		self.crit_damage = new_crit_damage
		self.weapon_range = new_weapon_range


## WeaponAudio Class
## main_attack_sfx: What sound is played when the weapon attacks
class WeaponAudio:
	var main_attack_sfx: AudioStream
	
	func _init(init_main_attack_sfx: AudioStream) -> void:
		main_attack_sfx = init_main_attack_sfx

## Used to draw 2D elements on the scene
var canvas_layer: CanvasLayer 

## Who owns this weapon
var player_owner: Player

# Member variables
var weapon_name: String
var stats: WeaponStats
var weapon_audio: WeaponAudio

# Helper variables
var attack_timer: float


## Init values of a weapon
## init_weapon_name: Name of the weapon type
## init_audio: Custom class that defines all the weapon sfx
## init_weapon_stats: Stats of a weapon
func _init(init_weapon_name: String, init_audio: WeaponAudio, init_weapon_stats: WeaponStats) -> void:
	weapon_name = init_weapon_name
	weapon_audio = init_audio
	stats = init_weapon_stats
	applyStatBonuses()
	attack_timer = 0.0


func _ready() -> void:
	## Setup the canvas layer
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	AudioManager.addStream(weapon_name, AudioManager.AudioType.WEAPON)


func _process(delta: float) -> void:
	increaseAtkTimer(delta)


## Increase attack timer and check for attacks
func increaseAtkTimer(time_passed: float) -> void:
	attack_timer += time_passed;
	var time_threshold = 1.0 / stats.attack_speed
	clamp(attack_timer, 0.0, time_threshold)
	
	if (attack_timer >= time_threshold):
		if (doAttack(findAttackPosition())):
			attack_timer = 0.0


## Add stat bonuses based on upgrades
func applyStatBonuses() -> void:
	pass # TODO: Implement


## VIRTUAL Method
## Do an attack
func doAttack(attack_pos: Vector2) -> bool:
	return false


## Calculate damage with crit chance and stuff
## Also plays AUDIO for the attack
## TODO: Update to take parameters of enemy element type to check for critical damage to that specific enemy
func calculateDamage() -> float:
	var rand_num = Globals.rng.randf_range(0.0, 1.0)
	
	var dmg = stats.damage
	if (rand_num <= stats.crit_chance):
		dmg = dmg + (dmg * stats.crit_damage)
		AudioManager.setStreamAudio(weapon_name, weapon_audio.main_attack_sfx) # TODO: Make crit attack sfx
	else:
		AudioManager.setStreamAudio(weapon_name, weapon_audio.main_attack_sfx)
	
	AudioManager.playStream(weapon_name) # Play audio
	return dmg


## Virutal Function to find the nearest enemy to attack
func findNearestEnemy() -> Vector2:
	return Vector2(0, 0)


## Virtual method to find position to attack at, typically an enemy
func findAttackPosition() -> Vector2:
	return findNearestEnemy()


## Set the owner of a weapon -- used for level, credits, etc.
## owner: Player that owns this weapon
func setOwner(owner: Player) -> void:
	player_owner = owner


## Get the player that owns this weapon
func getOwner() -> Player:
	return player_owner
