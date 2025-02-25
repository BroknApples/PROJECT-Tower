extends Node

class_name Enemy

var rng = RandomNumberGenerator.new()

# Enemy stats
var hp: float
var damage: float
var movement_speed: float
var enemy_type: String ## Initialized in child class init function


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	findSpawnPosition()
	
	# Set contact monitoring to true
	var rigid_body = $RigidBody2D
	rigid_body.set_contact_monitor(true)
	rigid_body.max_contacts_reported = 25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Use this for game mechanics
	pass


func findSpawnPosition() -> void:
	var screen_size = get_tree().root.size  # Get screen size
	
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
			yPos = rng.randi_range(-MIN_PADDING, screen_size.y + MIN_PADDING)
		1:  # Right side
			xPos = screen_size.x + rng.randi_range(MIN_PADDING, MAX_PADDING)
			yPos = rng.randi_range(-MIN_PADDING, screen_size.y + MIN_PADDING)
		2:  # Top side
			xPos = rng.randi_range(-MIN_PADDING, screen_size.x + MIN_PADDING)
			yPos = -rng.randi_range(MIN_PADDING, MAX_PADDING)
		3:  # Bottom side
			xPos = rng.randi_range(-MAX_PADDING, screen_size.x + MIN_PADDING)
			yPos = screen_size.y + rng.randi_range(MIN_PADDING, MAX_PADDING)
	
	$".".set_position(Vector2(xPos, yPos))
	
	var nearest_attackable = findNearestAttackable()
	$".".look_at(nearest_attackable)


func findNearestAttackable() -> Vector2:
	var players = get_parent().get_parent().get_node("Players").get_children()

	var closest_tower_pos = players[0].get_node("TowerClass").global_position
	
	for player in players:
		if (player.get_node("TowerClass").global_position < closest_tower_pos):
			closest_tower_pos = player.global_position

	return closest_tower_pos


func defaultPhysicsProcess(delta: float):
	var enemy = $RigidBody2D
	var nearest_attackable = findNearestAttackable()
	
	# Move towards position
	var direction = (nearest_attackable - enemy.global_position).normalized()
	enemy.apply_force(direction * movement_speed, Vector2.ZERO)
	
	# TODO: Rotate to angle
	#const ROTATION_SPEED = 50.0
	#var target_angle = (nearest_attackable - enemy.global_position).angle()
	#var angle_difference = fmod(target_angle - enemy.rotation + PI, 2 * PI) - PI
	#var torque = angle_difference * ROTATION_SPEED
	#enemy.apply_torque(torque)
