extends Control
##
## TitleScreen UI
##
## Screen that appears when you first launch the game or exit your save file
##


@onready var quit_menu = $"QuitMenu PanelContainer"
@onready var save_select_menu = $"SaveSelectMenu PanelContainer"


## If the user presses play, display the SaveSelect UI
func _on_play_pressed() -> void:
	save_select_menu.visible = true


## If the user presses settings, display the Settings UI
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/settings/settings.tscn")


## If the user presses quit, display the QuitMenu UI
func _on_quit_pressed() -> void:
	quit_menu.visible = true
