extends Enemy


func _physics_process(delta: float) -> void:
	if ($RigidBody2D.global_position == findNearestAttackable()): return
	
	var direction = (findNearestAttackable() - $RigidBody2D.global_position).normalized()
	$RigidBody2D.add_constant_force(direction * movement_speed, Vector2.ZERO)
	print($RigidBody2D.global_position)
