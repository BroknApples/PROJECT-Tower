extends Control
##
## TitleScreen UI
##
## Screen that appears when you first launch the game or exit your save file
##

# TESTING
func _ready() -> void:
	#var window = get_viewport().get_window()
	#var test_size = Vector2i(1280, 720)
	#window.size = test_size
	#window.position = test_size/4
	pass
# TESTING

@onready var quit_menu = $"QuitMenu PanelContainer"
@onready var save_select_menu = $"SaveSelectMenu PanelContainer"


## If the user presses play, display the SaveSelect UI
func _on_play_pressed() -> void:
	save_select_menu.visible = true


## If the user presses settings, display the Settings UI
func _on_settings_pressed() -> void:
	# TODO: Setup like how i have the save_select and quit_menu setup
	get_tree().change_scene_to_file("res://ui/settings/settings.tscn")


## If the user presses quit, display the QuitMenu UI
func _on_quit_pressed() -> void:
	quit_menu.visible = true
