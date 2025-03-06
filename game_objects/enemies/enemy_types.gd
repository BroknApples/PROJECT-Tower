extends Node
##
## Enemy Types Class
##
## Holds all personalities and elemental types an enemy can have
##
class_name EnemyTypes

class PersonalityType:
	## Virtual runPhysicsProcess function
	## delta: time passed since last frame
	## enemy: RigidBody2D that will be affected
	func runPhysicsProcess(delta: float, enemy_rigid_body) -> bool:
		return false


## StaggerType
##
## Randomly moves sideways with a burst of movement speed
class StaggerType extends PersonalityType:
	## How long and often will a stagger occur
	const _STAGGER_CHANCE = 15 ## Chance out of 1000 to stagger on any non-stagger frame
	const _STAGGER_FRAMES = 13 ## How many frames will a stagger last
	
	## What will the enemy's current movement speed be multiplied by
	const _MIN_STAGGER_SPEED = 2.0 ## Minimum movement speed given to a stagger type when staggering
	const _MAX_STAGGER_SPEED = 3.2 ## Maximum movement speed given to a stagger type when staggering
	
	## Used to determine what direction the stagger will be in
	## if angle > 90, it is going backwards, if angle < 90, it is moving forwards
	const _MIN_STAGGER_ANGLE = 70 ## Minimum angle of movement
	const _MAX_STAGGER_ANGLE = 120 ## Maximum angle of movement
	
	## Determines whether or not a stagger should currently be occuring
	## If this queue is not empty, apply stagger movement
	var stagger_movement_queue: Array[Vector2] ## Holds direction data for the current stagger
	
	func runPhysicsProcess(delta: float, enemy_rigid_body) -> bool:
		if (!stagger_movement_queue.is_empty()):
			enemy_rigid_body.linear_velocity = stagger_movement_queue.pop_front()
			return true
		else: # Check if we should add another stagger movement
			var rand_num = Globals.rng.randi_range(0, 1000)
			if (rand_num <= _STAGGER_CHANCE):
				# Calculate new stagger Vector
				var stagger_speed_x = Globals.rng.randf_range(_MIN_STAGGER_SPEED, _MAX_STAGGER_SPEED)
				var stagger_speed_y = Globals.rng.randf_range(_MIN_STAGGER_SPEED, _MAX_STAGGER_SPEED)
				var stagger_movement_vector = Vector2(stagger_speed_x, stagger_speed_y)
				stagger_movement_vector *= enemy_rigid_body.linear_velocity
				
				# Randomly move an object between +70deg & +110deg or -70deg & -110deg
				# of the current movement vector
				var stagger_angle = randf_range(_MIN_STAGGER_ANGLE, _MAX_STAGGER_ANGLE)
				stagger_angle *= (1 if randf() > 0.5 else -1)
				stagger_angle = deg_to_rad(stagger_angle)
				stagger_movement_vector = stagger_movement_vector.rotated(stagger_angle)
				
				# Add the stagger movement for a few frames
				for i in range(_STAGGER_FRAMES):
					stagger_movement_queue.push_back(stagger_movement_vector)
			
			return false
