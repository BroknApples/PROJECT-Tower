extends Node

class_name Enemy

var rng = RandomNumberGenerator.new()

# Enemy stats
# TODO: REMOVE PRESET STATS
# TODO: FOR BOTH THIS AND TOWER / WEAPONS, ADD BASE STATS
var hp = 5
var damage = 1
var movement_speed: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_speed /= 60.0
	findSpawnPosition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Use this for game mechanics
	
	pass

func findSpawnPosition() -> void:
	var screen_size = DisplayServer.screen_get_size()
	
	# Start the position in the middle of the screen: (screen_size.width / 2)
	# Then get a random number that will place it at the edge of the screen: rng.randi_range(screen_size.width, screen_size.width + 100)
	# If the number is odd, subtract the half-screen distance, otherwise add it
	var xPos = rng.randi_range((screen_size.x / 2) + 200, (screen_size.x / 2) + 250)
	var yPos = rng.randi_range((screen_size.y / 2) + 200, (screen_size.y / 2) + 250) 
	
	if (xPos % 2 == 0):
		xPos += (screen_size.x / 2)
	else:
		xPos -= (screen_size.x / 2)
		
	if (yPos % 2 == 0):
		yPos += (screen_size.y / 2)
	else:
		yPos -= (screen_size.y / 2)
	
	$".".set_position(Vector2(xPos, yPos))
	print("Position: " + str(xPos) + ", " + str(yPos))

func findNearestAttackable() -> Vector2:
	var players = get_parent().get_parent().get_node("Players").get_children()

	var closest_tower_pos = players[0].get_node("Tower").global_position
	
	for player in players:
		if (player.get_node("Tower").global_position < closest_tower_pos):
			closest_tower_pos = player.global_position

	return closest_tower_pos

func defaultPhysicsProcess(delta: float):
	var direction = (findNearestAttackable() - $RigidBody2D.global_position).normalized()
	$RigidBody2D.add_constant_force(direction * movement_speed, Vector2.ZERO)
