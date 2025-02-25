extends Enemy
# import math

func _ready():
	super._ready()
	
	# Setup shape
	var rigid_body = $RigidBody2D
	rigid_body.mass = 0.5
	
	var polygon = $RigidBody2D/Polygon2D
	var collider = $RigidBody2D/CollisionPolygon2D
	
	var s = 30 ## Side Length
	var vertices = PackedVector2Array([
		Vector2(s, 0),
		Vector2(cos(PI * 120 / 180) * s, sin(PI * 120 / 180) * s),
		Vector2(cos(PI * 240 / 180) * s, sin(PI * 240 / 180) * s)
	])
	
	polygon.polygon = vertices
	polygon.color = Color.BLUE
	collider.polygon = vertices
	
	# Enemy stats -- All have something to do with 3 lol cause triangle(I'm so funny(it's not funny))
	enemy_type = "Triangle"
	hp = 3.33
	damage = 1.33
	movement_speed = 66.66
	

func _physics_process(delta: float) -> void:
	defaultPhysicsProcess(delta)
	

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body is StaticBody2D:
		body.get_parent().takeDamage(self)
		queue_free()
