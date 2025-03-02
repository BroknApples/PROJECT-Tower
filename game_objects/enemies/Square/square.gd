extends Enemy
##
## Triangle : extends EnemyClass
## 
## This enemy is fast, but does low damage
##


# Stats for this specific enemy
# Copy and paste this into every new enemy type class
const _ENEMY_TYPE = "Square"
const _MAX_HP = 10.0
const _DAMAGE = 2.0
const _MOVEMENT_SPEED = 100
const _CREDIT_VALUE = 3
const _CUBE_VALUE = 0.02
const _XP_VALUE = 4


func _init() -> void:
	super._init(_ENEMY_TYPE, _MAX_HP, _DAMAGE, _MOVEMENT_SPEED, _CREDIT_VALUE, _CUBE_VALUE, _XP_VALUE)


func _ready():
	super._ready()
	
	# Setup shape
	var rigid_body = $RigidBody2D
	rigid_body.mass = 1.0
	
	var polygon = $RigidBody2D/Polygon2D
	var collider = $RigidBody2D/CollisionPolygon2D
	
	var s = 15 ## Side Length / 2
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
