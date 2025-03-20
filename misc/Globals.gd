extends Node
##
## Main Global Variables
##


## Current window size
@onready var window_size := get_tree().get_root().get_size()

## Global Random Number Generator
var rng = RandomNumberGenerator.new()

## paused: Fully stop gameplay and gameplay helpers(mouse pointer type, etc.)
var paused: bool


enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	INSANE
}

enum TowerTags {
	CORE ## If a tower with this tag dies, the you lose
}

enum EnemyTags {
	# Personalities
	STAGGER
}

## Meta tags for nodes to differentiate between types
enum Metadata {
	ENEMY
}

const MetadataStrings = {
	Metadata.ENEMY: "Enemy"
}

## Pair type
class Pair:
	var first
	var second
	func _init(init_first, init_second) -> void:
		first = init_first
		second = init_second


func _ready() -> void:
	get_window().connect("size_changed", _on_window_size_changed)
	paused = false


func _on_window_size_changed():
	window_size = get_viewport().size
	print("Screen size changed to: " + str(window_size.x) + ", " + str(window_size.y))
	# TODO: On screen resize during a game, we need to calculate EVERYTHING again (except for enemies)


## Get the mouse's position on the screen
func getMousePosition() -> Vector2i:
	return get_viewport().get_mouse_position()


## Set a new shape for the mouse cursor
## new_cursor_shape: New resource to set arrow shape to
## new_cursor_type: Which cursor mode will be changed(arrow, I-beam, scroll, etc.)
func setCursorShape(new_cursor_shape: CompressedTexture2D, new_cursor_type = Input.CURSOR_ARROW, hotspot = Vector2(0, 0)) -> void:
	if (new_cursor_shape == null):
		print("Reset Cursor")
	else:
		print("Set cursor type: " + str(new_cursor_type) + " to texture: " + new_cursor_shape.resource_path)
	Input.set_custom_mouse_cursor(new_cursor_shape, new_cursor_type, hotspot)


## Get what physics node exists at some given position
## pos: where on the screen to check
## returns: the top level node or null
func getPhysicsNodeAtPosition(pos: Vector2) -> PhysicsBody2D:
	var space_state = get_tree().get_root().get_node("Game").get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_bodies = true  # Enable detection of physics bodies
	query.collide_with_areas = false  # Disable area detection (optional)
	var result = space_state.intersect_point(query, 1)  # Limit to 1 result
	
	if result.size() > 0:
		var node = result[0]["collider"]
		return node
	
	# Return null if no physics nodes found
	return null


## Get what physics node exists at some given position and shape to check in
## pos: where on the screen to check
## shape: shape to check objects in
## returns: the top level node or null
func getPhysicsNodesInArea(pos: Vector2, shape: Shape2D) -> Array[PhysicsBody2D]:
	var space_state = get_tree().get_root().get_node("Game").get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.transform = Transform2D(0, pos)
	query.shape = shape
	query.collide_with_bodies = true  # Enable detection of physics bodies
	query.collide_with_areas = false  # Disable area detection (optional)
	var results = space_state.intersect_shape(query, 100)  # Limit to 100 nodes
	
	var nodes: Array[PhysicsBody2D] = []
	for result in results:
		var node = result["collider"]
		if (node is PhysicsBody2D):
			nodes.append(node)
	
	return nodes


## Get the list of players in the game
func getPlayers() -> Array[Node]:
	return get_parent().get_parent().get_node("Players").get_children()


## Quit the game
func quitGame():
	if get_tree():
		get_tree().quit()
	else:
		print("ERROR: get_tree() is null!")
