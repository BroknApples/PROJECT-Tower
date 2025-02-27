extends Enemy
##
## Triangle : extends EnemyClass
## 
## This enemy is fast, but does low damage
##


func _init() -> void:
	# Enemy stats
	enemy_type = "Square"
	super._init(10.0, 2.0, 25.0)


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


func _physics_process(delta: float) -> void:
	defaultPhysicsProcess(delta)
