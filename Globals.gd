extends Node
##
## Global Variables
##

@onready var screen_size = get_tree().root.size


enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	INSANE
}

enum TowerTags {
	CORE ## If a tower with this tag dies, the you lose
}

## Pair type
class Pair:
	var first
	var second
	func _init(init_first, init_second) -> void:
		first = init_first
		second = init_second


func _ready() -> void:
	get_window().connect("size_changed", _on_screen_size_changed)


func _on_screen_size_changed():
	screen_size = get_viewport().size
	print("Screen size changed to: " + str(screen_size.x) + ", " + str(screen_size.y))
	# TODO: On screen resize during a game, we need to calculate EVERYTHING again (except for enemies)


## Quit the game
func quitGame():
	if get_tree():
		get_tree().quit()
	else:
		print("ERROR: get_tree() is null!")
