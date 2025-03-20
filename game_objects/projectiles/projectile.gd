extends Node2D
##
## Projectile Class
##
## Base class of all projectile: It implements movement and projectile stats
##
class_name Projectile


## ProjectileStats Class
## damage: How much damage does it do to player objects
## projectile_speed: How fast does it move
class ProjectileStats:
	var damage: float
	var projectile_speed: float

	func _init(init_damage:float, init_projectile_speed: float) -> void:
		self.damage = init_damage
		self.projectile_speed = init_projectile_speed


@onready var projectile_rigid_body = $RigidBody2D
@onready var projectile_sprite = $RigidBody2D/Sprite2D
@onready var projectile_collision_body = $RigidBody2D/CollisionShape2D
var spawn_position: Vector2 ## Initial spawn position of the node

var projectile_name: String ## Always initialized in child class init function
var projectile_owner: WeaponClass ## Who owns this projectile
var texture: Texture2D ## Texture of the projectile
var stats: ProjectileStats ## Stats of projectile
var tracker: bool ## Will it track the closest enemy
var projectile_collision_shape: CollisionShape2D
var projectile_size: Vector2


## Set stats and tags for the enemy

## init_spawn_pos: Where will the projectile be spawned at
## init_projectile_name: name of the projectile
## init_texture: texture of the projectile
## init_spawn_pos: initial spawn position of the projectile
## init_damage: how much damage does it do
## init_projectile_speed: how fast will it move
## init_tracker: Will it track to the nearest enemy(heat-seeking projectile
## init_collision_shape: Shape of the projectile hitbox
func _init(init_projectile_name: String, init_texture: Texture2D,
			init_collision_shape: CollisionShape2D, init_size: Vector2,
			init_spawn_pos: Vector2, init_damage: float,
			init_projectile_speed: float, init_tracker: bool) -> void:
	projectile_name = init_projectile_name
	texture = init_texture
	projectile_collision_shape = init_collision_shape
	projectile_size = init_size
	spawn_position = init_spawn_pos
	stats = ProjectileStats.new(init_damage, init_projectile_speed)
	tracker = init_tracker


func _ready() -> void:
	# Resize texture
	var image = texture.get_data()
	image.flip_y()
	image.resize(projectile_size.x, projectile_size.y)
	var resized_texture = ImageTexture.new()
	resized_texture.create_from_image(image)
	
	# Set texture and collision shape
	projectile_sprite.texture = resized_texture
	projectile_collision_body = projectile_collision_shape
	
	# Set position
	self.position = spawn_position
	
	# If tracking is not true, then set linear velocity only one time
	if (!tracker):
		var nearest_attackable = findNearestAttackable()
		var direction = (nearest_attackable - projectile_rigid_body.global_position).normalized()
		projectile_rigid_body.linear_velocity = direction * stats.projectile_speed
	else:
		# Set collision detection function
		projectile_rigid_body.body_entered.connect(_on_rigid_body_2d_body_entered)


func _physics_process(delta: float) -> void:
	# Move towards nearest enemy, tracking its position even through movement
	var nearest_attackable = findNearestAttackable()
	var direction = (nearest_attackable - projectile_rigid_body.global_position).normalized()
	projectile_rigid_body.linear_velocity = direction * stats.projectile_speed


## Detect Collision
func _on_rigid_body_2d_body_entered(body: Node) -> void:
	# Always happens on collision
	if (body.has_meta(Globals.MetadataStrings[Globals.Metadata.ENEMY])):
		body.takeDamage(projectile_owner, self.damage)


## Find the nearest object to attack
func findNearestAttackable() -> Vector2:
	var players = Globals.getPlayers()

	var closest_tower_pos = Vector2(INF, INF)
	
	for player in players:
		for tower in player.get_node("Towers").get_children():
			if (tower.global_position < closest_tower_pos):
				closest_tower_pos = tower.global_position

	return closest_tower_pos
