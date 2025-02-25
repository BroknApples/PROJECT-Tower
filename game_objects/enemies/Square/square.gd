extends Enemy

func _ready():
	super._ready()
	
	# Setup shape
	var rigid_body = $RigidBody2D
	rigid_body.mass = 1.0
	
	var polygon = $RigidBody2D/Polygon2D
	var collider = $RigidBody2D/CollisionPolygon2D
	
	var s = 30 ## Side Length / 2
	var vertices = PackedVector2Array([
		Vector2(-s, s),
		Vector2(-s, -s),
		Vector2(s, -s),
		Vector2(s, s)
	])
	
	polygon.polygon = vertices
	polygon.color = Color.RED
	collider.polygon = vertices
	
	# Enemy stats
	enemy_type = "Square"
	hp = 10.0
	damage = 2.0
	movement_speed = 25.0


func _physics_process(delta: float) -> void:
	defaultPhysicsProcess(delta)


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body is StaticBody2D:
		body.get_parent().takeDamage(self)
		queue_free()
