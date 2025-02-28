extends Node
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
	var max_hp: float
	var curr_hp: float
	var damage: float
	var movement_speed: float
	var armor: float ## DMG Reduction uses the formula from League of Legends: DMG Taken = ATK * 100 / (100 + Armor)
	var hp_regen: float
	
	func _init(init_max_hp: float, init_damage:float, init_movement_speed: float) -> void:
		self.max_hp = init_max_hp
		self.damage = init_damage
		self.movement_speed = init_movement_speed


var rng = RandomNumberGenerator.new()

# Tags
var enemy_type: String ## Always initialized in child class init function

# Stats
var stats: EnemyStats


func _init(init_max_hp, init_damage, init_movement_speed) -> void:
	stats = EnemyStats.new(init_max_hp, init_damage, init_movement_speed)


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
		queue_free()
	
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
	
	var edge = rng.randi_range(0, 3)  # 0 = Left, 1 = Right, 2 = Top, 3 = Bottom
	
	match edge:
		0:  # Left side
			xPos = -rng.randi_range(MIN_PADDING, MAX_PADDING)
			yPos = rng.randi_range(-MIN_PADDING, Globals.screen_size.y + MIN_PADDING)
		1:  # Right side
			xPos = Globals.screen_size.x + rng.randi_range(MIN_PADDING, MAX_PADDING)
			yPos = rng.randi_range(-MIN_PADDING, Globals.screen_size.y + MIN_PADDING)
		2:  # Top side
			xPos = rng.randi_range(-MIN_PADDING, Globals.screen_size.x + MIN_PADDING)
			yPos = -rng.randi_range(MIN_PADDING, MAX_PADDING)
		3:  # Bottom side
			xPos = rng.randi_range(-MAX_PADDING, Globals.screen_size.x + MIN_PADDING)
			yPos = Globals.screen_size.y + rng.randi_range(MIN_PADDING, MAX_PADDING)
	
	$".".set_position(Vector2(xPos, yPos))
	
	var nearest_attackable = findNearestAttackable()
	$".".look_at(nearest_attackable)


## Find the nearest object to attack
func findNearestAttackable() -> Vector2:
	var players = get_parent().get_parent().get_node("Players").get_children()

	var closest_tower_pos = players[0].get_node("Tower").global_position
	
	for player in players:
		if (player.get_node("Tower").global_position < closest_tower_pos):
			closest_tower_pos = player.global_position

	return closest_tower_pos


## Default process for phyiscs simulation -> MOST enemies will use this
func defaultPhysicsProcess(delta: float):
	var enemy = $RigidBody2D
	var nearest_attackable = findNearestAttackable()
	
	# Move towards position
	var direction = (nearest_attackable - enemy.global_position).normalized()
	enemy.apply_force(direction * stats.movement_speed, Vector2.ZERO)
	
	# TODO: Rotate to angle
	#const ROTATION_SPEED = 50.0
	#var target_angle = (nearest_attackable - enemy.global_position).angle()
	#var angle_difference = fmod(target_angle - enemy.rotation + PI, 2 * PI) - PI
	#var torque = angle_difference * ROTATION_SPEED
	#enemy.apply_torque(torque)


func doOnCollision(body: Node) -> void:
	pass
