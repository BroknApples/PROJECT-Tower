extends Node2D
##
## Enemy Class
##
## Base class of all enemies, implements basic damage and attack functions
##
class_name Enemy


## EnemyStats Class
## enemy_type: Name of the enemy type
## max_hp: Maximum health of the enemy
## curr_hp: Current health of the enemy
## damage: How much damage does it do to player objects
## movement_speed: How fast does it move
## armor: Reduces damage taken
## hp_regen: How much health does it regenerate in a second
class EnemyStats:
	# Personality and element
	var personality: EnemyTypes.PersonalityType
	
	# Type values
	var credit_value: float
	var cube_value: float
	var xp_value: int
	
	
	# Stats
	var max_hp: float
	var curr_hp: float
	var damage: float
	var movement_speed: float
	var armor: float ## DMG Reduction uses the formula from League of Legends: DMG Taken = ATK * 100 / (100 + Armor)
	var hp_regen: float
	
	func _init(init_max_hp: float, init_damage:float, init_movement_speed: float,
			   init_credit_value: float, init_cube_value: float, init_xp_value: int) -> void:
		self.max_hp = init_max_hp
		self.damage = init_damage
		self.movement_speed = init_movement_speed
		self.credit_value = init_credit_value
		self.cube_value = init_cube_value
		self.xp_value = init_xp_value
	
	func setPersonality(new_personality: EnemyTypes.PersonalityType):
		personality = new_personality

@onready var enemy = $RigidBody2D

var enemy_type: String ## Always initialized in child class init function
var stats: EnemyStats # Stats


## Set stats and tags for the enemy
func _init(init_enemy_type: String, init_max_hp: float, init_damage: float, init_movement_speed: float,
		   init_credit_value: float, init_cube_value: float, init_xp_value: int) -> void:
	enemy_type = init_enemy_type
	stats = EnemyStats.new(init_max_hp, init_damage, init_movement_speed, init_credit_value, init_cube_value, init_xp_value)
	stats.setPersonality(EnemyTypes.PersonalityType.new()) # Set empty personality by default


func _ready() -> void:
	findSpawnPosition()
	
	# Set contact monitoring to true
	var rigid_body = $RigidBody2D
	rigid_body.set_contact_monitor(true)
	rigid_body.max_contacts_reported = 25
	
	# Set collision detection function
	rigid_body.body_entered.connect(_on_rigid_body_2d_body_entered)


func _process(delta: float) -> void:
	stats.curr_hp += delta * stats.hp_regen


## Detect Collision
func _on_rigid_body_2d_body_entered(body: Node) -> void:
	# Always happens on collision
	if body is StaticBody2D:
		body.get_parent().takeDamage(self)
		
		# TESTING
		if body.get_parent().has_method("getParentPlayer"):
			body.get_parent().getParentPlayer().addEnemyKilled(self, "SUICIDE")
		# TESTING
	
	# Do unique interactions on collision based on child declaration
	doOnCollision(body)


## Find a position off the screen to spawn a new enemy
func findSpawnPosition() -> void:
	## Minimum amount of padding to create when spawning
	## (prevents large objects from spawning on the screen)
	const MIN_PADDING = 500
	const MAX_PADDING = 750
	
	var xPos: int
	var yPos: int
	
	var edge = Globals.rng.randi_range(0, 3)  # 0 = Left, 1 = Right, 2 = Top, 3 = Bottom
	
	match edge:
		0:  # Left side
			xPos = -Globals.rng.randi_range(MIN_PADDING, MAX_PADDING)
			yPos = Globals.rng.randi_range(-MIN_PADDING, Globals.window_size.y + MIN_PADDING)
		1:  # Right side
			xPos = Globals.window_size.x + Globals.rng.randi_range(MIN_PADDING, MAX_PADDING)
			yPos = Globals.rng.randi_range(-MIN_PADDING, Globals.window_size.y + MIN_PADDING)
		2:  # Top side
			xPos = Globals.rng.randi_range(-MIN_PADDING, Globals.window_size.x + MIN_PADDING)
			yPos = -Globals.rng.randi_range(MIN_PADDING, MAX_PADDING)
		3:  # Bottom side
			xPos = Globals.rng.randi_range(-MAX_PADDING, Globals.window_size.x + MIN_PADDING)
			yPos = Globals.window_size.y + Globals.rng.randi_range(MIN_PADDING, MAX_PADDING)
	
	$".".set_position(Vector2(xPos, yPos))
	
	var nearest_attackable = findNearestAttackable()
	$".".look_at(nearest_attackable)


## Find the nearest object to attack
func findNearestAttackable() -> Vector2:
	var players = get_parent().get_parent().get_node("Players").get_children()

	var closest_tower_pos = Vector2(INF, INF)
	
	for player in players:
		for tower in player.get_node("Towers").get_children():
			if (tower.global_position < closest_tower_pos):
				closest_tower_pos = tower.global_position

	return closest_tower_pos


## Default process for phyiscs simulation -> MOST enemies will use this
func defaultPhysicsProcess(delta: float):
	if (!stats.personality.runPhysicsProcess(delta, enemy)):
		var nearest_attackable = findNearestAttackable()
		
		# Move towards position
		var direction = (nearest_attackable - enemy.global_position).normalized()
		enemy.linear_velocity = direction * stats.movement_speed


## VIRTUAL FUNCTION
## Modify in child types and do special interactions on collisions like
## explode into smaller enemies or something(trojan horse style)
func doOnCollision(body: Node) -> void:
	pass
