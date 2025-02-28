extends Node
##
## Global Variables
##


enum Difficulty {
	EASY,
	MEDIUM,
	HARD,
	INSANE
}


@onready var screen_size = get_tree().root.size


func _ready() -> void:
	get_window().connect("size_changed", _on_screen_size_changed)


func _on_screen_size_changed():
	screen_size = get_viewport().size
	print("Screen size changed to: ", screen_size.x + ", " + screen_size.y) 
