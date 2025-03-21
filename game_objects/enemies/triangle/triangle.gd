extends Enemy
##
## Triangle : extends EnemyClass
## 
## This enemy is fast, but does low damage
##

# Stats for this specific enemy
# Copy and paste this into every new enemy type class
const _ENEMY_TYPE = "Triangle"
const _MAX_HP = 3
const _DAMAGE = 1.33
const _MOVEMENT_SPEED = 164.2
const _CREDIT_VALUE = 2
const _CUBE_VALUE = 0.01
const _XP_VALUE = 1


func _init() -> void:
	super._init(_ENEMY_TYPE, EnemyStats.new(_MAX_HP, _MAX_HP, _DAMAGE, _MOVEMENT_SPEED, _CREDIT_VALUE, _CUBE_VALUE, _XP_VALUE))
	#stats.setPersonality(EnemyTypes.StaggerType.new()) # TESTING

func _ready():
	super._ready()
	
	# Setup shape
	var rigid_body = $RigidBody2D
	rigid_body.mass = 0.5
	
	var polygon = $RigidBody2D/Polygon2D
	var collider = $RigidBody2D/CollisionPolygon2D
	
	var s = 18 ## Side Length
	var vertices = PackedVector2Array([
		Vector2(s, 0),
		Vector2(cos(PI * 120 / 180) * s, sin(PI * 120 / 180) * s),
		Vector2(cos(PI * 240 / 180) * s, sin(PI * 240 / 180) * s)
	])
	
	polygon.polygon = vertices
	polygon.color = Color.BLUE
	collider.polygon = vertices


func _physics_process(delta: float) -> void:
	defaultPhysicsProcess(delta)
